#define _GNU_SOURCE
#include <jni.h>
#include <dirent.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <termios.h>
#include <errno.h>
#include <signal.h>
#include <sys/ioctl.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <android/log.h>

#define TAG "AXPty"
#define LOGE(...) __android_log_print(ANDROID_LOG_ERROR, TAG, __VA_ARGS__)
#define LOGD(...) __android_log_print(ANDROID_LOG_DEBUG, TAG, __VA_ARGS__)

JNIEXPORT jint JNICALL
Java_com_colourswift_cssecurity_terminal_bridge_PtyHelper_openMaster(
        JNIEnv *env, jobject thiz, jint rows, jint cols) {
    int master = posix_openpt(O_RDWR | O_NOCTTY | O_CLOEXEC);
    if (master < 0) { LOGE("posix_openpt failed errno=%d", errno); return -1; }
    if (grantpt(master) < 0 || unlockpt(master) < 0) {
        LOGE("grantpt/unlockpt failed errno=%d", errno);
        close(master); return -1;
    }
    struct winsize ws = { .ws_row = (unsigned short)rows, .ws_col = (unsigned short)cols };
    ioctl(master, TIOCSWINSZ, &ws);

    struct termios tios;
    tcgetattr(master, &tios);
    tios.c_iflag |= IUTF8;
    tios.c_iflag &= ~(IXON | IXOFF);
    tcsetattr(master, TCSANOW, &tios);

    LOGD("master fd=%d", master);
    return master;
}

JNIEXPORT jstring JNICALL
Java_com_colourswift_cssecurity_terminal_bridge_PtyHelper_getSlaveName(
        JNIEnv *env, jobject thiz, jint masterFd) {
    char *name = ptsname((int)masterFd);
    if (!name) { LOGE("ptsname failed errno=%d", errno); return NULL; }
    LOGD("slave name: %s", name);
    return (*env)->NewStringUTF(env, name);
}

JNIEXPORT jint JNICALL
Java_com_colourswift_cssecurity_terminal_bridge_PtyHelper_spawnShell(
        JNIEnv *env, jobject thiz,
        jint masterFd, jstring slaveName,
        jstring busyboxPath, jstring homePath,
        jstring prootPath,   jstring rootfsPath,
        jstring cachePath,   jstring nativeLibDir) {

    int errPipe[2];
    if (pipe2(errPipe, O_CLOEXEC) < 0) {
        LOGE("pipe2 failed errno=%d", errno); return -1;
    }

    const char *s1 = (*env)->GetStringUTFChars(env, slaveName,     NULL);
    const char *s2 = (*env)->GetStringUTFChars(env, busyboxPath,   NULL);
    const char *s3 = (*env)->GetStringUTFChars(env, homePath,      NULL);
    const char *s4 = (*env)->GetStringUTFChars(env, prootPath,     NULL);
    const char *s5 = (*env)->GetStringUTFChars(env, rootfsPath,    NULL);
    const char *s6 = (*env)->GetStringUTFChars(env, cachePath,     NULL);
    const char *s7 = (*env)->GetStringUTFChars(env, nativeLibDir,  NULL);

    char slaveC[256], busyboxC[512], homeC[512], prootC[512], rootfsC[512], cacheC[512], nativeLibC[512];
    strncpy(slaveC,      s1, sizeof(slaveC)      - 1); slaveC[sizeof(slaveC)-1]          = '\0';
    strncpy(busyboxC,    s2, sizeof(busyboxC)    - 1); busyboxC[sizeof(busyboxC)-1]       = '\0';
    strncpy(homeC,       s3, sizeof(homeC)       - 1); homeC[sizeof(homeC)-1]             = '\0';
    strncpy(prootC,      s4, sizeof(prootC)      - 1); prootC[sizeof(prootC)-1]           = '\0';
    strncpy(rootfsC,     s5, sizeof(rootfsC)     - 1); rootfsC[sizeof(rootfsC)-1]         = '\0';
    strncpy(cacheC,      s6, sizeof(cacheC)      - 1); cacheC[sizeof(cacheC)-1]           = '\0';
    strncpy(nativeLibC,  s7, sizeof(nativeLibC)  - 1); nativeLibC[sizeof(nativeLibC)-1]   = '\0';

    (*env)->ReleaseStringUTFChars(env, slaveName,    s1);
    (*env)->ReleaseStringUTFChars(env, busyboxPath,  s2);
    (*env)->ReleaseStringUTFChars(env, homePath,     s3);
    (*env)->ReleaseStringUTFChars(env, prootPath,    s4);
    (*env)->ReleaseStringUTFChars(env, rootfsPath,   s5);
    (*env)->ReleaseStringUTFChars(env, cachePath,    s6);
    (*env)->ReleaseStringUTFChars(env, nativeLibDir, s7);

    int useAlpine = (prootC[0] != '\0' && rootfsC[0] != '\0');

    char pathEnv[1024], homeEnv[512], shellEnv[512], tmpEnv[512];
    snprintf(pathEnv,  sizeof(pathEnv),  "PATH=%s/../bin:/system/bin:/system/xbin", homeC);
    snprintf(homeEnv,  sizeof(homeEnv),  "HOME=%s", homeC);
    snprintf(shellEnv, sizeof(shellEnv), "SHELL=%s", busyboxC);
    snprintf(tmpEnv,   sizeof(tmpEnv),   "TMPDIR=%s", homeC);

    char rootfsArg[600];
    snprintf(rootfsArg, sizeof(rootfsArg), "--rootfs=%s", rootfsC);

    char loaderArg[600];
    snprintf(loaderArg, sizeof(loaderArg), "%s/libproot-loader.so", nativeLibC);

    LOGD("spawning: mode=%s slave=%s", useAlpine ? "alpine" : "busybox", slaveC);

    pid_t pid = fork();
    if (pid < 0) {
        LOGE("fork failed errno=%d", errno);
        close(errPipe[0]); close(errPipe[1]); return -1;
    }

    if (pid == 0) {
        close(errPipe[0]);

#define CHILD_FAIL(stage) do { \
            int _v[2] = { (stage), errno }; \
            write(errPipe[1], _v, sizeof(_v)); \
            close(errPipe[1]); \
            _exit(127); \
        } while(0)

        sigset_t sigs;
        sigfillset(&sigs);
        sigprocmask(SIG_UNBLOCK, &sigs, NULL);

        if (setsid() < 0) CHILD_FAIL(1);

        int slave = open(slaveC, O_RDWR);
        if (slave < 0) CHILD_FAIL(2);

        if (ioctl(slave, TIOCSCTTY, 0) < 0) CHILD_FAIL(3);

        if (dup2(slave, STDIN_FILENO)  < 0) CHILD_FAIL(4);
        if (dup2(slave, STDOUT_FILENO) < 0) CHILD_FAIL(5);
        if (dup2(slave, STDERR_FILENO) < 0) CHILD_FAIL(6);
        if (slave > STDERR_FILENO) close(slave);

        DIR *fds = opendir("/proc/self/fd");
        if (fds) {
            int dirfd_ = dirfd(fds);
            struct dirent *de;
            while ((de = readdir(fds)) != NULL) {
                int fd = atoi(de->d_name);
                if (fd > STDERR_FILENO && fd != dirfd_ && fd != errPipe[1]) close(fd);
            }
            closedir(fds);
        }

        if (useAlpine) {
            clearenv();
            putenv("PROOT_NO_SECCOMP=1");
            putenv("TERM=xterm-256color");
            putenv("USER=root");
            putenv("LOGNAME=root");
            putenv("HOME=/root");
            putenv("SHELL=/bin/sh");
            putenv("LANG=C.UTF-8");
            static char s_loaderEnv[620];
            snprintf(s_loaderEnv, sizeof(s_loaderEnv), "PROOT_LOADER=%s", loaderArg);
            putenv(s_loaderEnv);
            static char s_tmpEnv[620];
            snprintf(s_tmpEnv, sizeof(s_tmpEnv), "PROOT_TMP_DIR=%s", cacheC);
            putenv(s_tmpEnv);
            putenv("PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin");

            char dnsPath[600];
            snprintf(dnsPath, sizeof(dnsPath), "%s/resolv.conf", cacheC);
            int dnsFd = open(dnsPath, O_WRONLY | O_CREAT | O_TRUNC, 0644);
            if (dnsFd >= 0) {
                const char *dnsContent = "nameserver 8.8.8.8\nnameserver 1.1.1.1\n";
                write(dnsFd, dnsContent, strlen(dnsContent));
                close(dnsFd);
            }

            static char dnsBindArg[1200];
            snprintf(dnsBindArg, sizeof(dnsBindArg), "%s:/etc/resolv.conf", dnsPath);

            char *argv[] = {
                    prootC,
                    rootfsArg,
                    "--link2symlink",
                    "-b", "/dev",
                    "-b", "/proc",
                    "-b", "/sys",
                    "-b", dnsBindArg,
                    "-w", "/root",
                    "-0",
                    "--kill-on-exit",
                    "/bin/sh",
                    "-l",
                    NULL
            };

            LOGD("execv proot: %s %s", prootC, rootfsArg);
            execv(prootC, argv);
            CHILD_FAIL(7);
        } else {
            char *argv[] = { (char*)busyboxC, "sh", "-l", NULL };
            execv(busyboxC, argv);
            CHILD_FAIL(8);
        }
    }

    // Parent Process code path
    close(errPipe[1]);
    int childErr[2];
    if (read(errPipe[0], childErr, sizeof(childErr)) == sizeof(childErr)) {
        LOGE("Child failed at stage=%d errno=%d (%s)", childErr[0], childErr[1], strerror(childErr[1]));
        close(errPipe[0]);
        int status; waitpid(pid, &status, WNOHANG);
        return -1;
    }
    close(errPipe[0]);

    usleep(300000);
    int status = 0;
    pid_t r = waitpid(pid, &status, WNOHANG);
    if (r == pid) {
        if (WIFSIGNALED(status)) {
            LOGE("Shell killed by signal %d (%s) immediately after exec",
                 WTERMSIG(status), strsignal(WTERMSIG(status)));
        } else if (WIFEXITED(status)) {
            LOGE("Shell exited immediately with code %d after exec", WEXITSTATUS(status));
            char logPath[560];
            snprintf(logPath, sizeof(logPath), "%s/proot-err.txt", cacheC);
            int logFd = open(logPath, O_RDONLY);
            if (logFd >= 0) {
                char buf[2048] = {0};
                read(logFd, buf, sizeof(buf) - 1);
                close(logFd);
                LOGE("proot stderr: %s", buf);
            }
        }
        return -1;
    }

    LOGD("Child exec succeeded pid=%d", pid);
    return pid;
}

JNIEXPORT jint JNICALL
Java_com_colourswift_cssecurity_terminal_bridge_PtyHelper_forkAndExec(
        JNIEnv *env, jobject thiz, jint masterFd, jstring slaveName, jstring busyboxPath,
        jstring homePath, jstring prootPath, jstring rootfsPath, jstring cachePath, jstring nativeLibDir) {

    const char *slave = (*env)->GetStringUTFChars(env, slaveName, 0);
    pid_t pid = fork();

    if (pid < 0) {
        (*env)->ReleaseStringUTFChars(env, slaveName, slave);
        return -1;
    } else if (pid == 0) {
        int slaveFd = open(slave, O_RDWR);
        if (slaveFd >= 0) {
            dup2(slaveFd, 0);
            dup2(slaveFd, 1);
            dup2(slaveFd, 2);
            close(slaveFd);
        }
        close(masterFd);
        _exit(0);
    }

    (*env)->ReleaseStringUTFChars(env, slaveName, slave);
    return pid;
}

JNIEXPORT void JNICALL
Java_com_colourswift_cssecurity_terminal_bridge_PtyHelper_resize(
        JNIEnv *env, jobject thiz, jint fd, jint rows, jint cols) {
struct winsize ws = { .ws_row = (unsigned short)rows, .ws_col = (unsigned short)cols };
ioctl(fd, TIOCSWINSZ, &ws);
}

JNIEXPORT void JNICALL
Java_com_colourswift_cssecurity_terminal_bridge_PtyHelper_close(
        JNIEnv *env, jobject thiz, jint fd) {
close(fd);
}