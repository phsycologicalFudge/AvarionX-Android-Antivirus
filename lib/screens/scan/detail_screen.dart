import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:photo_view/photo_view.dart';
import 'package:video_player/video_player.dart';
import 'package:open_filex/open_filex.dart';

import '../../translations/app_localizations.dart';
enum CleanerSort { newest, oldest, largest, smallest }

class CleanerDetailScreen extends StatefulWidget {
  final String title;
  final List<File> files;
  const CleanerDetailScreen({super.key, required this.title, required this.files});

  @override
  State<CleanerDetailScreen> createState() => _CleanerDetailScreenState();
}

class _CleanerDetailScreenState extends State<CleanerDetailScreen> {
  final Set<File> _selected = {};
  CleanerSort _sort = CleanerSort.newest;
  bool _deleting = false;

  late List<File> _files;
  final Map<String, int> _sizeCache = {};
  final Map<String, DateTime> _mtimeCache = {};
  final Map<String, Future<String?>> _thumbnailFutures = {};

  @override
  void initState() {
    super.initState();
    _files = List<File>.from(widget.files);
    _precomputeMeta();
  }

  void _precomputeMeta() {
    for (final f in _files) {
      try {
        _sizeCache[f.path] = f.lengthSync();
      } catch (_) {
        _sizeCache[f.path] = 0;
      }
      try {
        _mtimeCache[f.path] = f.statSync().modified;
      } catch (_) {
        _mtimeCache[f.path] = DateTime.fromMillisecondsSinceEpoch(0);
      }
    }
  }

  bool _isImage(File f) {
    final e = p.extension(f.path).toLowerCase();
    return ['.jpg', '.jpeg', '.png', '.gif', '.webp', '.heic'].contains(e);
  }

  bool _isVideo(File f) {
    final e = p.extension(f.path).toLowerCase();
    return ['.mp4', '.mov', '.mkv', '.avi', '.webm'].contains(e);
  }

  bool get _isLargeFilesCategory => widget.title.toLowerCase().contains('large');

  int _sizeOf(File f) => _sizeCache[f.path] ?? 0;

  List<File> get _sortedFiles {
    final list = List<File>.from(_files);
    final epoch = DateTime.fromMillisecondsSinceEpoch(0);
    switch (_sort) {
      case CleanerSort.newest:
        list.sort((a, b) =>
            (_mtimeCache[b.path] ?? epoch).compareTo(_mtimeCache[a.path] ?? epoch));
        break;
      case CleanerSort.oldest:
        list.sort((a, b) =>
            (_mtimeCache[a.path] ?? epoch).compareTo(_mtimeCache[b.path] ?? epoch));
        break;
      case CleanerSort.largest:
        list.sort((a, b) => _sizeOf(b).compareTo(_sizeOf(a)));
        break;
      case CleanerSort.smallest:
        list.sort((a, b) => _sizeOf(a).compareTo(_sizeOf(b)));
        break;
    }
    return list;
  }

  Future<String?> _getThumbnail(File f) {
    return _thumbnailFutures.putIfAbsent(
      f.path,
          () => VideoThumbnail.thumbnailFile(
        video: f.path,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 256,
        quality: 40,
      ),
    );
  }

  void _toggleSelection(File f) {
    setState(() => _selected.contains(f) ? _selected.remove(f) : _selected.add(f));
  }

  Future<void> _deleteSelected() async {
    if (_selected.isEmpty || _deleting) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title:  Text(AppLocalizations.of(context)!.scanDetailDeleteFiles),
        content: Text(AppLocalizations.of(context)!.scanDetailDeleteFilesPermanently(_selected.length)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child:  Text(AppLocalizations.of(context)!.cancel)),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child:  Text(AppLocalizations.of(context)!.quarantineDelete)),
        ],
      ),
    );
    if (ok != true) return;
    setState(() => _deleting = true);
    for (final f in List<File>.from(_selected)) {
      try {
        await f.delete();
        _sizeCache.remove(f.path);
        _mtimeCache.remove(f.path);
        _thumbnailFutures.remove(f.path);
      } catch (_) {}
    }
    if (mounted) {
      setState(() {
        _files.removeWhere(_selected.contains);
        _selected.clear();
        _deleting = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar( SnackBar(content: Text(AppLocalizations.of(context)!.scanDetailSelectedFilesDeleted)));
    }
  }

  Future<void> _deleteAll() async {
    if (_files.isEmpty || _deleting) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title:  Text(AppLocalizations.of(context)!.scanDetailDeleteAllFiles),
        content: Text(AppLocalizations.of(context)!.scanDetailDeleteAllFilesPermanently(_files.length)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child:  Text(AppLocalizations.of(context)!.cancel)),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child:  Text(AppLocalizations.of(context)!.scanDetailDeleteAll)),
        ],
      ),
    );
    if (ok != true) return;
    setState(() => _deleting = true);
    for (final f in List<File>.from(_files)) {
      try {
        await f.delete();
      } catch (_) {}
    }
    if (mounted) {
      setState(() {
        _files.clear();
        _sizeCache.clear();
        _mtimeCache.clear();
        _thumbnailFutures.clear();
        _selected.clear();
        _deleting = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar( SnackBar(content: Text(AppLocalizations.of(context)!.scanDetailAllFilesDeleted)));
    }
  }

  void _openPreview(File f) {
    if (_isImage(f)) {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => ImagePreviewScreen(file: f)));
    } else if (_isVideo(f)) {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => VideoPreviewScreen(file: f)));
    }
  }

  String _fmtBytes(int bytes) {
    const u = ['B', 'KB', 'MB', 'GB', 'TB'];
    var v = bytes.toDouble();
    var i = 0;
    while (v >= 1024 && i < u.length - 1) {
      v /= 1024;
      i++;
    }
    return '${v.toStringAsFixed(v >= 10 || i == 0 ? 0 : 1)} ${u[i]}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final files = _sortedFiles;
    final hasMedia =
        !_isLargeFilesCategory && files.any((f) => _isImage(f) || _isVideo(f));
    final width = MediaQuery.of(context).size.width;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final crossAxis = (isLandscape || width >= 720) ? 4 : 3;
    final inSelectMode = _selected.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(inSelectMode ? AppLocalizations.of(context)!.scanDetailSelected(_selected.length) : widget.title),
        actions: [
          if (_deleting)
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else if (inSelectMode)
            TextButton(
              onPressed: () {
                setState(() {
                  if (_selected.length == files.length) {
                    _selected.clear();
                  } else {
                    _selected
                      ..clear()
                      ..addAll(files);
                  }
                });
              },
              child: Text(
                  _selected.length == files.length ? AppLocalizations.of(context)!.scanDetailDeselectAll : AppLocalizations.of(context)!.quarantineSelectAll),
            )
          else
            PopupMenuButton<CleanerSort>(
              initialValue: _sort,
              onSelected: (v) => setState(() => _sort = v),
              itemBuilder: (_) =>  [
                PopupMenuItem(value: CleanerSort.newest, child: Text(AppLocalizations.of(context)!.scanDetailNewestFirst)),
                PopupMenuItem(value: CleanerSort.oldest, child: Text(AppLocalizations.of(context)!.scanDetailOldestFirst)),
                PopupMenuItem(value: CleanerSort.largest, child: Text(AppLocalizations.of(context)!.scanDetailLargestFirst)),
                PopupMenuItem(
                    value: CleanerSort.smallest, child: Text(AppLocalizations.of(context)!.scanDetailSmallestFirst)),
              ],
              icon: const Icon(Icons.sort_rounded),
            ),
        ],
      ),
      body: Stack(
        children: [
          files.isEmpty
              ? Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle_outline_rounded,
                    size: 56,
                    color: theme.colorScheme.onSurface.withOpacity(0.2)),
                const SizedBox(height: 12),
                Text(
                  AppLocalizations.of(context)!.scanDetailNoFilesFound,
                  style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.45)),
                ),
              ],
            ),
          )
              : hasMedia
              ? GridView.builder(
            padding:
            EdgeInsets.fromLTRB(8, 8, 8, inSelectMode ? 88 : 8),
            physics: const BouncingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxis,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
            ),
            itemCount: files.length,
            itemBuilder: (context, i) {
              final f = files[i];
              final isVid = _isVideo(f);
              final selected = _selected.contains(f);
              final size = _sizeOf(f);

              return GestureDetector(
                onTap: inSelectMode
                    ? () => _toggleSelection(f)
                    : () => _openPreview(f),
                onLongPress: () => _toggleSelection(f),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: isVid
                          ? FutureBuilder<String?>(
                        future: _getThumbnail(f),
                        builder: (context, snap) {
                          if (snap.hasData && snap.data != null) {
                            return Image.file(File(snap.data!),
                                fit: BoxFit.cover);
                          }
                          return Container(
                              color: theme.colorScheme
                                  .surfaceContainerHigh);
                        },
                      )
                          : Image.file(
                        f,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                            color: theme
                                .colorScheme.surfaceContainerHigh),
                      ),
                    ),
                    if (isVid)
                      const Positioned(
                        top: 6,
                        left: 6,
                        child: Icon(Icons.play_circle_fill_rounded,
                            color: Colors.white70, size: 22),
                      ),
                    if (size > 0)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 3),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(10)),
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.6),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: Text(
                            _fmtBytes(size),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    if (selected)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          color:
                          theme.colorScheme.primary.withOpacity(0.45),
                          child: const Center(
                            child: Icon(Icons.check_circle_rounded,
                                color: Colors.white, size: 30),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          )
              : _isLargeFilesCategory
              ? ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding:
            EdgeInsets.only(bottom: inSelectMode ? 88 : 0),
            itemCount: files.length,
            itemBuilder: (context, i) {
              final f = files[i];
              final selected = _selected.contains(f);
              return ListTile(
                onTap: inSelectMode
                    ? () => _toggleSelection(f)
                    : () => OpenFilex.open(f.path),
                onLongPress: () => _toggleSelection(f),
                leading: selected
                    ? Icon(Icons.check_circle_rounded,
                    color: theme.colorScheme.primary)
                    : Icon(Icons.insert_drive_file_rounded,
                    color: theme.colorScheme.onSurface
                        .withOpacity(0.4)),
                title: Text(p.basename(f.path)),
                subtitle: Text(_fmtBytes(_sizeOf(f))),
              );
            },
          )
              : ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding:
            EdgeInsets.only(bottom: inSelectMode ? 88 : 0),
            itemCount: files.length,
            itemBuilder: (context, i) {
              final f = files[i];
              final selected = _selected.contains(f);
              return ListTile(
                onLongPress: () => _toggleSelection(f),
                onTap: inSelectMode
                    ? () => _toggleSelection(f)
                    : null,
                leading: selected
                    ? Icon(Icons.check_circle_rounded,
                    color: theme.colorScheme.primary)
                    : Icon(Icons.insert_drive_file_rounded,
                    color: theme.colorScheme.onSurface
                        .withOpacity(0.4)),
                title: Text(p.basename(f.path)),
                subtitle:
                Text(f.path, overflow: TextOverflow.ellipsis),
              );
            },
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            bottom: inSelectMode ? 0 : -100,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                  16, 12, 16, 12 + MediaQuery.of(context).padding.bottom),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHigh,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 16,
                      offset: const Offset(0, -4)),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.scanDetailSelected(_selected.length),
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  if (_selected.isEmpty && _files.isNotEmpty)
                    FilledButton.icon(
                      onPressed: _deleting ? null : _deleteAll,
                      icon: const Icon(Icons.delete_sweep_rounded, size: 18),
                      label:  Text(AppLocalizations.of(context)!.scanDetailDeleteAll2),
                      style: FilledButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white),
                    )
                  else
                    FilledButton.icon(
                      onPressed: (_selected.isNotEmpty && !_deleting)
                          ? _deleteSelected
                          : null,
                      icon: const Icon(Icons.delete_forever_rounded, size: 18),
                      label:  Text(AppLocalizations.of(context)!.quarantineDelete),
                      style: FilledButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ImagePreviewScreen extends StatelessWidget {
  final File file;
  const ImagePreviewScreen({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          backgroundColor: Colors.black, title: Text(p.basename(file.path))),
      body: PhotoView(
        imageProvider: FileImage(file),
        backgroundDecoration: const BoxDecoration(color: Colors.black),
      ),
    );
  }
}

class VideoPreviewScreen extends StatefulWidget {
  final File file;
  const VideoPreviewScreen({super.key, required this.file});

  @override
  State<VideoPreviewScreen> createState() => _VideoPreviewScreenState();
}

class _VideoPreviewScreenState extends State<VideoPreviewScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.file)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(p.basename(widget.file.path))),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              VideoPlayer(_controller),
              VideoProgressIndicator(_controller, allowScrubbing: true),
              Positioned(
                bottom: 40,
                child: IconButton(
                  icon: Icon(
                    _controller.value.isPlaying
                        ? Icons.pause_circle_filled_rounded
                        : Icons.play_circle_fill_rounded,
                    color: Colors.white,
                    size: 64,
                  ),
                  onPressed: () {
                    setState(() {
                      _controller.value.isPlaying
                          ? _controller.pause()
                          : _controller.play();
                    });
                  },
                ),
              ),
            ],
          ),
        )
            : const CircularProgressIndicator(color: Colors.white),
      ),
    );
  }
}