abstract class AppException implements Exception {
  final String message;

  const AppException([this.message = 'Terjadi kesalahan yang tidak diketahui']);

  @override
  String toString() => message;
}

/// Error umum dari server (500, response tak terduga, dll)
class ServerException extends AppException {
  const ServerException([super.message = 'Terjadi kesalahan pada server']);
}

/// Kredensial salah / tidak terautentikasi (401)
class AuthenticationException extends AppException {
  const AuthenticationException([super.message = 'Autentikasi gagal']);
}

/// Resource tidak ditemukan (404)
class NotFoundException extends AppException {
  const NotFoundException([super.message = 'Data tidak ditemukan']);
}

/// Validasi input gagal di sisi server (422)
class RequestValidationException extends AppException {
  const RequestValidationException([super.message = 'Validasi gagal']);
}

/// Tidak ada koneksi internet
class NetworkException extends AppException {
  const NetworkException([super.message = 'Tidak ada koneksi internet']);
}

/// Request timeout
class TimeoutException extends AppException {
  const TimeoutException([super.message = 'Permintaan melebihi batas waktu']);
}

/// Error saat membaca/menulis local storage (cache, shared preferences, dll)
class CacheException extends AppException {
  const CacheException([super.message = 'Gagal mengakses data lokal']);
}

/// Error saat parsing/decoding response
class ParsingException extends AppException {
  const ParsingException([super.message = 'Gagal memproses data']);
}

class BadRequestException extends AppException {
  const BadRequestException([super.message = 'Gagal memproses data']);
}

class ImagePickerException extends AppException {
  const ImagePickerException([super.message = 'Gagal ambil gambar']);
}