#include <sys/stat.h>
#include <errno.h>

int _write(int file, char *ptr, int len) {
  (void)file; (void)ptr; (void)len;
  return len;
}
void *_sbrk(ptrdiff_t incr) { errno = ENOMEM; return (void *)-1; }
void _exit(int status) { while (1) {} }
int _close(int file) { return -1; }
int _fstat(int file, struct stat *st) { return 0; }
int _isatty(int file) { return 1; }
int _lseek(int file, int ptr, int dir) { return 0; }
int _read(int file, char *ptr, int len) { return 0; }
