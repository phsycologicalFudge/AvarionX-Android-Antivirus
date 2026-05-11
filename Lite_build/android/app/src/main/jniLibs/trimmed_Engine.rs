//this makes up about 15% of the engine. Iv placed this here for transparency purposes, hopefully people understand how the engine works a little without exposing it. (Engine v2.0.4)

use libc::{c_char, c_int};
use memchr::memmem;
use once_cell::sync::OnceCell;
use serde_json::json;
use std::collections::HashMap;
use std::ffi::{CStr, CString};
use std::fs::{self, File};
use std::io::{Cursor, Read};
use std::path::{Path, PathBuf};
use std::sync::Mutex;
use walkdir::WalkDir;
use zip::read::ZipArchive;
mod attestation;
mod ftp_server;
mod http_server;
mod ml_classifier;
mod password_vault;
pub use attestation::cs_attest_entry;
pub use ftp_server::*;
pub use http_server::*;
use ml_classifier::{load_model_a, predict_vx};
pub use password_vault::derive_password_meta;

use aes::Aes256;
use aho_corasick::{AhoCorasick, AhoCorasickBuilder, MatchKind};
// REMOVED
// REMOVED
use block_padding::Pkcs7;
use bloomfilter::Bloom;
use cbc::cipher::{BlockDecryptMut, KeyIvInit};
use cbc::Decryptor;
use md5;
use once_cell::sync::Lazy;
use regex::Regex;
use rustc_hash::FxHashSet;
// REMOVED
use sha2::{Digest, Sha256};

const MAX_FILE_BYTES: usize = 16 * 1024 * 1024;
const MAX_PATTERN_BYTES: usize = 2 * 1024 * 1024;
const ENTROPY_SAMPLE: usize = 64 * 1024;
const ENTROPY_GATE: f32 = 0.0;
const CONF_THRESHOLD: f32 = 0.0;
const MIN_CONCRETE_NONBIN: usize = 6;
const MIN_CONCRETE_BIN: usize = 4;
const MAX_ZIP_DEPTH: usize = 2;
const MAX_NESTED_READ: usize = 2 * 1024 * 1024;
const MAX_TOTAL_NESTED_BYTES: usize = 16 * 1024 * 1024;
const W_SIG: f64 = 0.0;
const W_HASH: f64 = 0.0;
const W_ML: f64 = 0.0;
const ML_THRESH: f64 = 0.0;
const VERDICT_THRESH: f64 = 0.0;

struct LayerVotes {
    sig: bool,
    hash: bool,
    signer: bool,
    ml_prob: Option<f64>,
}

#[no_mangle]
pub extern "C" fn generate_password(
    meta_ptr: *const c_char,
    label_ptr: *const c_char,
    version: u32,
    length: usize,
) -> *mut c_char {
    std::panic::catch_unwind(|| {
        let meta = unsafe { CStr::from_ptr(meta_ptr).to_str().unwrap_or("") };
        let label = unsafe { CStr::from_ptr(label_ptr).to_str().unwrap_or("") };
        let result = derive_password_meta(meta, label, version, length);
        CString::new(result).unwrap_or_default().into_raw()
    })
    .unwrap_or_else(|_| CString::new("panic").unwrap().into_raw())
}

#[no_mangle]
pub extern "C" fn free_password(ptr: *mut c_char) {
    if ptr.is_null() {
        return;
    }
    unsafe {
        drop(CString::from_raw(ptr));
    }
}

pub type ScanCallback = extern "C" fn(*const c_char);

static mut SCAN_CB: Option<ScanCallback> = None;

#[no_mangle]
pub extern "C" fn set_scan_callback(cb: ScanCallback) {
    unsafe { SCAN_CB = Some(cb) };
}

fn emit(msg: &str) {
    unsafe {
        if let Some(cb) = SCAN_CB {
            let c = match CString::new(msg) {
                Ok(v) => v,
                Err(_) => return,
            };
            let ptr = c.into_raw();
            cb(ptr);
        }
    }
}

fn clean(s: &str) -> String {
    s.replace('\0', "")
}

#[no_mangle]
pub extern "C" fn free_str(ptr: *mut c_char) {
    if ptr.is_null() {
        return;
    }
    unsafe {
        drop(CString::from_raw(ptr));
    }
}

fn fast_contains(haystack: &str, needle: &str) -> bool {
    if needle.len() < 3 {
        return haystack.contains(needle);
    }
    memmem::find(haystack.as_bytes(), needle.as_bytes()).is_some()
}

fn decide_verdict(_v: &LayerVotes) -> bool {
    // REMOVED
}

#[derive(Clone)]
enum Tok {
    Byte(u8),
    Any,
    Gap(usize, usize),
}

#[derive(Clone)]
struct Sig {
    name: String,
    toks: Vec<Tok>,
}

// REMOVED
// REMOVED
// REMOVED

struct Engine {
    defs_dir: PathBuf,
    total_sig_count: usize,
    ac: Option<AhoCorasick>,
    ac_names: Vec<String>,
    ac_lens: Vec<usize>,
    complex: Vec<Sig>,
    hashes: FxHashSet<String>,
    bloom: Option<Bloom<[u8]>>,
    signer_bloom: Option<Bloom<[u8]>>,
    max_file_bytes: usize,
    // REMOVED
}

static ENGINE: OnceCell<Mutex<Option<Engine>>> = OnceCell::new();
static DEX_RE: Lazy<Regex> =
    Lazy::new(|| Regex::new(r"[A-Za-z0-9_./:$-]{6,60}").unwrap());

struct UnsafePtrWrapper(Option<*mut c_char>);
unsafe impl Send for UnsafePtrWrapper {}
unsafe impl Sync for UnsafePtrWrapper {}
static LAST_PTR: OnceCell<Mutex<UnsafePtrWrapper>> = OnceCell::new();

fn decrypt_vxpack(vx_path: &Path, key_path: &Path) -> Option<Vec<u8>> {
    let data = fs::read(vx_path).ok()?;
    if data.len() < 16 {
        return None;
    }
    let iv = &data[..16];
    let ct = &data[16..];
    let key = fs::read(key_path).ok()?;
    if key.len() < 32 {
        return None;
    }
    let mut buf = ct.to_vec();
    let dec = Decryptor::<Aes256>::new_from_slices(&key[..32], iv).ok()?;
    let pt = dec.decrypt_padded_mut::<Pkcs7>(&mut buf).ok()?;
    Some(pt.to_vec())
}

fn load_sigs_from_zip_bytes(zip_bytes: &[u8]) -> Vec<Sig> {
    // REMOVED
}

fn load_hashes_from_zip_bytes(zip_bytes: &[u8]) -> FxHashSet<String> {
    // REMOVED
}

fn bloom_from_csbf_bytes(buf: &[u8]) -> Option<Bloom<[u8]>> {
    // REMOVED
}

fn load_bloom_from_zip_bytes(zip_bytes: &[u8]) -> Option<Bloom<[u8]>> {
    // REMOVED
}

// REMOVED FN

fn load_ndb(path: &Path) -> Vec<Sig> {
    let mut out = Vec::new();
    let content = fs::read_to_string(path).unwrap_or_default();
    for line in content.lines() {
        let t = line.trim();
        if t.is_empty() || t.starts_with('#') {
            continue;
        }
        let parts: Vec<&str> = t.split(':').collect();
        if parts.len() < 4 {
            continue;
        }
        let name = parts[0].to_string();
        let hexsig = parts[3];
        if hexsig.len() > 2000 {
            continue;
        }
        if let Some(toks) = parse_hex_sig(hexsig) {
            out.push(Sig { name, toks });
        }
    }
    out
}

fn split_sigs_for_engine(_sigs: &[Sig]) -> (Vec<Vec<u8>>, Vec<String>, Vec<usize>, Vec<Sig>, usize) {
    // REMOVED
}

fn sha256_hex_lower(data: &[u8]) -> String {
    let mut hasher = Sha256::new();
    hasher.update(data);
    let out = hasher.finalize();
    let mut s = String::with_capacity(64);
    for b in out {
        use std::fmt::Write;
        let _ = write!(s, "{:02x}", b);
    }
    s
}

fn extract_cert_fingerprint_v1(_buf: &[u8]) -> Option<String> {
    // REMOVED
}

// REMOVED
// REMOVED
// REMOVED

fn md5_hex_lower(data: &[u8]) -> String {
    format!("{:x}", md5::compute(data))
}

fn check_hash_match(_buf: &[u8], _eng: &Engine) -> bool {
    // REMOVED
}

fn classify_filetype(path: &Path) -> &'static str {
    let ext = path
        .extension()
        .and_then(|e| e.to_str())
        .unwrap_or("")
        .to_ascii_lowercase();
    match ext.as_str() {
        "jpg" | "jpeg" | "png" | "gif" | "bmp" | "webp" | "tiff" => "image",
        "mp4" | "mkv" | "avi" | "mov" | "flv" | "wmv" | "webm" | "3gp" | "m4v" => "video",
        "pdf" | "doc" | "docx" | "txt" | "rtf" | "csv" | "tsv" | "log" | "ini" | "cfg" | "conf"
        | "json" | "xml" | "html" | "htm" | "md" | "yml" | "yaml" | "tex" | "odt" | "ods"
        | "odp" | "bat" | "ps1" | "vbs" | "js" | "css" => "document",
        "apk" | "exe" | "dll" | "so" | "elf" | "dex" | "com" | "jar" | "bin" | "msi" => "binary",
        "zip" => "archive",
        _ => "generic",
    }
}

fn shannon_entropy(_sample: &[u8]) -> f32 {
    // REMOVED
}

// REMOVED

fn concrete_len(sig: &Sig) -> usize {
    sig.toks
        .iter()
        .fold(0, |acc, t| acc + if let Tok::Byte(_) = t { 1 } else { 0 })
}

// REMOVED
// REMOVED
// REMOVED
// REMOVED
// REMOVED

fn scan_buffer(
    _data: &[u8],
    _ac: &Option<AhoCorasick>,
    _ac_names: &[String],
    _ac_lens: &[usize],
    _complex: &[Sig],
    _filetype: &str,
    _entropy: f32,
    _eng: &Engine,
    _file_sha_hit: bool,
) -> Vec<String> {
    // REMOVED
}

fn ml_prob_from_features(features: &[(String, f64)]) -> Option<f64> {
    std::panic::catch_unwind(|| predict_vx(features))
        .ok()
        .flatten()
}

fn is_likely_text(_buf: &[u8]) -> bool {
    // REMOVED
}

fn should_scan_entry(_name: &str, _size: usize, _sample: &[u8]) -> bool {
    // REMOVED
}

struct PermFeatures {
    sms_full: f64,
    sms_with_boot: f64,
    calllog_spy: f64,
    contacts_upload: f64,
    audio_record_net: f64,
    camera_net: f64,
    location_bg: f64,
    storage_all: f64,
    manage_external_storage: f64,
    installer_like: f64,
    overlay_risk: f64,
    usage_stats: f64,
    device_admin: f64,
    boot_persist: f64,
    phone_id_leak: f64,
}

// REMOVED

fn scan_zip_bytes_inmemory(
    _parent_path_display: &str,
    _bytes: &[u8],
    _eng: &Engine,
    _depth: usize,
    _results: &Mutex<HashMap<String, Vec<String>>>,
    _total_nested_read: &std::sync::atomic::AtomicUsize,
) {
    // REMOVED
}

fn scan_zip(_path: &Path, _eng: &Engine) -> HashMap<String, Vec<String>> {
    // REMOVED
}

fn scan_zip_generic(_path: &Path, _eng: &Engine) -> HashMap<String, Vec<String>> {
    // REMOVED
}

fn scan_file(_path: &Path, _eng: &Engine) -> Vec<String> {
    // REMOVED
}

// REMOVED FN

fn init_engine_any(defs_path: &Path, key_path: Option<&Path>) -> Result<(), String> {
    let cell = ENGINE.get_or_init(|| Mutex::new(None));
    {
        let guard = cell.lock().unwrap();
        if guard.is_some() {
            return Ok(());
        }
    }

    let mut raw_sigs: Vec<Sig> = Vec::new();
    let mut hashes: FxHashSet<String> = FxHashSet::default();
    let mut bloom: Option<Bloom<[u8]>> = None;
    let mut signer_bloom: Option<Bloom<[u8]>> = None;

    if defs_path.is_file() {
        let is_vx = defs_path
            .extension()
            .and_then(|e| e.to_str())
            .map(|e| e.eq_ignore_ascii_case("vxpack"))
            .unwrap_or(false);
        if is_vx {
            let kp = key_path.ok_or_else(|| "key path required for vxpack".to_string())?;
            if let Some(zip_bytes) = decrypt_vxpack(defs_path, kp) {
                raw_sigs.extend(load_sigs_from_zip_bytes(&zip_bytes));
                hashes.extend(load_hashes_from_zip_bytes(&zip_bytes));
                bloom = load_bloom_from_zip_bytes(&zip_bytes);
            }
        } else if defs_path
            .file_name()
            .and_then(|n| n.to_str())
            .map(|n| n.to_ascii_lowercase().ends_with(".ndb"))
            .unwrap_or(false)
        {
            raw_sigs.extend(load_ndb(defs_path));
        }
    } else {
        let ndb = defs_path.join("main.ndb");
        if ndb.exists() {
            raw_sigs.extend(load_ndb(&ndb));
        }

        let ndb2 = defs_path.join("vx_bytes.ndb");
        let mut vx_bytes_loaded = false;

        if ndb2.exists() {
            let count_before = raw_sigs.len();
            raw_sigs.extend(load_ndb(&ndb2));
            let count_after = raw_sigs.len();
            let added = count_after.saturating_sub(count_before);

            if added > 0 {
                vx_bytes_loaded = true;
                android_log(&format!("Loaded {} vx_bytes signatures", added));
            }
        }

        let bloom_path = defs_path.join("database_hashes.bloom");

        if bloom_path.exists() {
            let buf = fs::read(&bloom_path).unwrap_or_default();
            bloom = bloom_from_csbf_bytes(&buf);
        }

        let signer_bloom_path = defs_path.join("database_signers.bloom");

        if signer_bloom_path.exists() {
            let buf = fs::read(&signer_bloom_path).unwrap_or_default();
            signer_bloom = bloom_from_csbf_bytes(&buf);
        }

        let hashes_txt = defs_path.join("hashes.txt");
        if hashes_txt.exists() {
            let text = fs::read_to_string(&hashes_txt).unwrap_or_default();
            for line in text.lines() {
                let t = line.trim();
                if (t.len() == 32 || t.len() == 64) && t.chars().all(|c| c.is_ascii_hexdigit()) {
                    hashes.insert(t.to_ascii_lowercase());
                }
            }
        }

        let _ = vx_bytes_loaded;
    }

    let (simple_patterns, simple_names, simple_lens, complex, total_sig_count) =
        split_sigs_for_engine(&raw_sigs);
    let ac = if !simple_patterns.is_empty() {
        Some(
            AhoCorasickBuilder::new()
                .match_kind(MatchKind::LeftmostLongest)
                .ascii_case_insensitive(false)
                .build(&simple_patterns)
                .map_err(|_| "AC build failed")?,
        )
    } else {
        None
    };

    // REMOVED

    let eng = Engine {
        defs_dir: defs_path.to_path_buf(),
        total_sig_count,
        ac,
        ac_names: simple_names,
        ac_lens: simple_lens,
        complex,
        hashes,
        bloom,
        signer_bloom,
        max_file_bytes: MAX_FILE_BYTES,
        // REMOVED
    };
    let mut guard = cell.lock().unwrap();
    *guard = Some(eng);
    Ok(())
}

fn cstr_to_path(p: *const c_char) -> Result<PathBuf, String> {
    if p.is_null() {
        return Err("null".into());
    }
    let s = unsafe { CStr::from_ptr(p) }
        .to_str()
        .map_err(|_| "utf8".to_string())?;
    Ok(PathBuf::from(s))
}

#[cfg(target_os = "android")]
use log::info;

#[cfg(target_os = "android")]
#[ctor::ctor]
fn init_android_logger() {
    android_logger::init_once(
        android_logger::Config::default()
            .with_max_level(log::LevelFilter::Info)
            .with_tag("ColourSwiftAV"),
    );
}

#[cfg(target_os = "android")]
fn android_log(msg: &str) {
    info!("{}", msg);
}

#[cfg(not(target_os = "android"))]
fn android_log(msg: &str) {
    println!("{}", msg);
}

#[no_mangle]
pub extern "C" fn av_init(defs_dir: *const c_char, key_path: *const c_char) -> c_int {
    let dd = match cstr_to_path(defs_dir) {
        Ok(v) => v,
        Err(_) => return -1,
    };
    let kp = if key_path.is_null() {
        None
    } else {
        cstr_to_path(key_path).ok()
    };
    match init_engine_any(&dd, kp.as_deref()) {
        Ok(_) => {
            if let Some(cell) = ENGINE.get() {
                let guard = cell.lock().unwrap();
                if let Some(engine) = &*guard {
                    android_log(&format!(
                        "ColourSwiftAV: Loaded {} sigs (+{} hashes) from {}",
                        engine.total_sig_count,
                        engine.hashes.len(),
                        dd.display()
                    ));
                }
                let a_result = load_model_a();
                match &a_result {
                    Ok(_) => android_log("ML: Model A loaded successfully"),
                    Err(e) => android_log(&format!("ML: Failed to load Model A -> {}", e)),
                }
            }
            0
        }
        Err(_) => {
            android_log("Engine initialization failed");
            -1
        }
    }
}

fn set_last_ptr(ptr: *mut c_char) {
    let cell = LAST_PTR.get_or_init(|| Mutex::new(UnsafePtrWrapper(None)));
    let mut g = cell.lock().unwrap();
    if let Some(prev) = g.0.take() {
        unsafe {
            let _ = CString::from_raw(prev);
        }
    }
    g.0 = Some(ptr);
}

#[cfg(target_os = "android")]
unsafe fn purge_allocator() {
    const M_PURGE: i32 = -101;
    const M_PURGE_ALL: i32 = -104;
    extern "C" {
        fn mallopt(param: i32, value: i32) -> i32;
    }
    let r_all = mallopt(M_PURGE_ALL, 0);
    if r_all == 0 {
        let _ = mallopt(M_PURGE, 0);
    }
}

fn av_scan_inner(path: *const c_char) -> String {
    let p = match cstr_to_path(path) {
        Ok(v) => v,
        Err(_) => {
            return "{}".to_string();
        }
    };

    let cell = ENGINE.get_or_init(|| Mutex::new(None));
    let guard = cell.lock().unwrap();
    let eng = match &*guard {
        Some(e) => e,
        None => {
            return "{}".to_string();
        }
    };

    let mut detections: HashMap<String, Vec<String>> = HashMap::new();

    if p.is_file() {
        let ext = p
            .extension()
            .and_then(|s| s.to_str())
            .unwrap_or("")
            .to_ascii_lowercase();

        if ext == "rar" {
        } else if ext == "apk" {
            // REMOVED
            let hits = std::panic::catch_unwind(|| scan_zip(&p, eng)).unwrap_or_else(|_| {
                android_log("scan_zip panicked, skipping this APK");
                HashMap::new()
            });

            for (k, v) in hits {
                detections.insert(k, v);
            }
        } else if ext == "zip" {
            let hits =
                std::panic::catch_unwind(|| scan_zip_generic(&p, eng)).unwrap_or_else(|_| {
                    android_log("scan_zip_generic panicked, skipping this ZIP");
                    HashMap::new()
                });

            for (k, v) in hits {
                detections.insert(k, v);
            }
        } else {
            let hits = std::panic::catch_unwind(|| scan_file(&p, eng)).unwrap_or_else(|_| {
                android_log("scan_file panicked, skipping this file");
                Vec::new()
            });

            if !hits.is_empty() {
                detections.insert(p.display().to_string(), hits);
            }
        }
    } else if p.is_dir() {
        let mut files: Vec<PathBuf> = Vec::new();

        for entry in WalkDir::new(&p)
            .follow_links(false)
            .into_iter()
            .filter_map(|e| e.ok())
        {
            let pb = entry.path().to_path_buf();
            if pb.is_file() {
                let ext = pb
                    .extension()
                    .and_then(|e| e.to_str())
                    .unwrap_or("")
                    .to_ascii_lowercase();
                if ext != "rar" {
                    files.push(pb);
                }
            }
        }

        use rayon::prelude::*;
        let map: Mutex<HashMap<String, Vec<String>>> = Mutex::new(HashMap::new());

        files.par_iter().for_each(|pb| {
            let ext = pb
                .extension()
                .and_then(|s| s.to_str())
                .unwrap_or("")
                .to_ascii_lowercase();

            if ext == "apk" {
                let hits = std::panic::catch_unwind(|| scan_zip(pb, eng)).unwrap_or_else(|_| {
                    android_log("scan_zip panicked in directory scan, skipping APK");
                    HashMap::new()
                });

                if !hits.is_empty() {
                    let mut g = map.lock().unwrap();
                    for (k, v) in hits {
                        g.insert(k, v);
                    }
                }
            } else if ext == "zip" {
                let hits =
                    std::panic::catch_unwind(|| scan_zip_generic(pb, eng)).unwrap_or_else(|_| {
                        android_log("scan_zip_generic panicked in directory scan, skipping ZIP");
                        HashMap::new()
                    });

                if !hits.is_empty() {
                    let mut g = map.lock().unwrap();
                    for (k, v) in hits {
                        g.insert(k, v);
                    }
                }
            } else {
                let hits = std::panic::catch_unwind(|| scan_file(pb, eng)).unwrap_or_else(|_| {
                    android_log("scan_file panicked in directory scan, skipping file");
                    Vec::new()
                });

                if !hits.is_empty() {
                    let mut g = map.lock().unwrap();
                    g.insert(pb.display().to_string(), hits);
                }
            }
        });

        detections = map.into_inner().unwrap();
    }

    let mut det_clean = HashMap::new();
    for (k, vlist) in detections.into_iter() {
        let key = clean(&k);
        let mut cleaned_list = Vec::new();
        for v in vlist {
            cleaned_list.push(clean(&v));
        }
        det_clean.insert(key, cleaned_list);
    }

    let out = json!({
        "scanned": clean(&p.display().to_string()),
        "hits": det_clean
    })
    .to_string();

    out.replace('\0', "")
}

#[no_mangle]
pub extern "C" fn av_scan(path: *const c_char) -> *mut c_char {
    let out = std::panic::catch_unwind(|| av_scan_inner(path)).unwrap_or_else(|_| {
        android_log("av_scan panicked, returning empty result");
        "{}".to_string()
    });

    let c = CString::new(out).unwrap_or_else(|_| CString::new("{}").unwrap());
    let ptr = c.into_raw();

    #[cfg(target_os = "android")]
    unsafe {
        purge_allocator();
        android_log("allocator purged");
    }

    ptr
}

#[no_mangle]
pub extern "C" fn av_free() -> c_int {
    let cell = LAST_PTR.get_or_init(|| Mutex::new(UnsafePtrWrapper(None)));
    let mut g = cell.lock().unwrap();
    if let Some(ptr) = g.0.take() {
        unsafe {
            let _ = CString::from_raw(ptr);
        }
        return 0;
    }
    -1
}
