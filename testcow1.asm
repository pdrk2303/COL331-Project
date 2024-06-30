
_testcow1:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
	exit();
}

int
main(int argc, char *argv[])
{
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	51                   	push   %ecx
  12:	83 ec 0c             	sub    $0xc,%esp
	printf(1, "Test starting...\n");
  15:	68 70 0a 00 00       	push   $0xa70
  1a:	6a 01                	push   $0x1
  1c:	e8 9f 05 00 00       	call   5c0 <printf>
	test();
  21:	e8 0a 00 00 00       	call   30 <test>
  26:	66 90                	xchg   %ax,%ax
  28:	66 90                	xchg   %ax,%ax
  2a:	66 90                	xchg   %ax,%ax
  2c:	66 90                	xchg   %ax,%ax
  2e:	66 90                	xchg   %ax,%ax

00000030 <test>:
{
  30:	f3 0f 1e fb          	endbr32 
  34:	55                   	push   %ebp
  35:	89 e5                	mov    %esp,%ebp
  37:	57                   	push   %edi
  38:	56                   	push   %esi
  39:	53                   	push   %ebx
  3a:	83 ec 1c             	sub    $0x1c,%esp
    uint prev_free_pages = getNumFreePages();
  3d:	e8 b9 04 00 00       	call   4fb <getNumFreePages>
    long long size = ((prev_free_pages - 20) * 4096); // 20 pages will be used by kernel to create kstack, and process related datastructures.
  42:	31 d2                	xor    %edx,%edx
  44:	8d 58 ec             	lea    -0x14(%eax),%ebx
    printf(1, "Allocating %d bytes for each process\n", size);
  47:	52                   	push   %edx
    long long size = ((prev_free_pages - 20) * 4096); // 20 pages will be used by kernel to create kstack, and process related datastructures.
  48:	c1 e3 0c             	shl    $0xc,%ebx
  4b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    printf(1, "Allocating %d bytes for each process\n", size);
  4e:	53                   	push   %ebx
  4f:	68 28 09 00 00       	push   $0x928
  54:	6a 01                	push   $0x1
    long long size = ((prev_free_pages - 20) * 4096); // 20 pages will be used by kernel to create kstack, and process related datastructures.
  56:	89 5d e0             	mov    %ebx,-0x20(%ebp)
    printf(1, "Allocating %d bytes for each process\n", size);
  59:	e8 62 05 00 00       	call   5c0 <printf>
    char *m1 = (char*)malloc(size);
  5e:	89 1c 24             	mov    %ebx,(%esp)
  61:	e8 ba 07 00 00       	call   820 <malloc>
    if (m1 == 0) goto out_of_memory;
  66:	83 c4 10             	add    $0x10,%esp
  69:	85 c0                	test   %eax,%eax
  6b:	0f 84 49 01 00 00    	je     1ba <test+0x18a>
  71:	89 c7                	mov    %eax,%edi
    for(int k=0;k<size;++k){
  73:	31 c9                	xor    %ecx,%ecx
        m1[k] = (char)(65+(k%26));
  75:	be 4f ec c4 4e       	mov    $0x4ec4ec4f,%esi
    for(int k=0;k<size;++k){
  7a:	85 db                	test   %ebx,%ebx
  7c:	74 1d                	je     9b <test+0x6b>
        m1[k] = (char)(65+(k%26));
  7e:	89 c8                	mov    %ecx,%eax
  80:	f7 e6                	mul    %esi
  82:	c1 ea 03             	shr    $0x3,%edx
  85:	6b c2 1a             	imul   $0x1a,%edx,%eax
  88:	89 ca                	mov    %ecx,%edx
  8a:	29 c2                	sub    %eax,%edx
  8c:	89 d0                	mov    %edx,%eax
  8e:	83 c0 41             	add    $0x41,%eax
  91:	88 04 0f             	mov    %al,(%edi,%ecx,1)
    for(int k=0;k<size;++k){
  94:	83 c1 01             	add    $0x1,%ecx
  97:	39 d9                	cmp    %ebx,%ecx
  99:	75 e3                	jne    7e <test+0x4e>
    printf(1, "\n*** Forking ***\n");
  9b:	83 ec 08             	sub    $0x8,%esp
  9e:	68 fe 09 00 00       	push   $0x9fe
  a3:	6a 01                	push   $0x1
  a5:	e8 16 05 00 00       	call   5c0 <printf>
    pid = fork();
  aa:	e8 9c 03 00 00       	call   44b <fork>
    if (pid < 0) goto fork_failed; // Fork failed
  af:	83 c4 10             	add    $0x10,%esp
  b2:	85 c0                	test   %eax,%eax
  b4:	0f 88 0c 01 00 00    	js     1c6 <test+0x196>
    if (pid == 0) { // Child process
  ba:	75 75                	jne    131 <test+0x101>
        printf(1, "\n*** Child ***\n");
  bc:	50                   	push   %eax
  bd:	50                   	push   %eax
  be:	68 2b 0a 00 00       	push   $0xa2b
  c3:	6a 01                	push   $0x1
  c5:	e8 f6 04 00 00       	call   5c0 <printf>
        for(int k=0;k<size;++k){
  ca:	83 c4 10             	add    $0x10,%esp
  cd:	85 db                	test   %ebx,%ebx
  cf:	0f 84 fd 00 00 00    	je     1d2 <test+0x1a2>
  d5:	31 c9                	xor    %ecx,%ecx
  d7:	31 db                	xor    %ebx,%ebx
  d9:	eb 18                	jmp    f3 <test+0xc3>
  db:	83 c1 01             	add    $0x1,%ecx
  de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  e1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  e4:	83 d3 00             	adc    $0x0,%ebx
  e7:	31 da                	xor    %ebx,%edx
  e9:	31 c8                	xor    %ecx,%eax
  eb:	09 c2                	or     %eax,%edx
  ed:	0f 84 df 00 00 00    	je     1d2 <test+0x1a2>
			if(m1[k] != (char)(65+(k%26))) goto failed;
  f3:	b8 4f ec c4 4e       	mov    $0x4ec4ec4f,%eax
  f8:	f7 e1                	mul    %ecx
  fa:	89 d0                	mov    %edx,%eax
  fc:	89 ca                	mov    %ecx,%edx
  fe:	c1 e8 03             	shr    $0x3,%eax
 101:	6b c0 1a             	imul   $0x1a,%eax,%eax
 104:	29 c2                	sub    %eax,%edx
 106:	89 d0                	mov    %edx,%eax
 108:	83 c0 41             	add    $0x41,%eax
 10b:	38 04 0f             	cmp    %al,(%edi,%ecx,1)
 10e:	74 cb                	je     db <test+0xab>
    printf(1, "Copy failed: The memory contents of the processes is inconsistent!\n");
 110:	50                   	push   %eax
 111:	50                   	push   %eax
 112:	68 90 09 00 00       	push   $0x990
	printf(1, "Failed to fork a process!\n");
 117:	6a 01                	push   $0x1
 119:	e8 a2 04 00 00       	call   5c0 <printf>
    printf(1, "Lab5 test failed!\n");
 11e:	58                   	pop    %eax
 11f:	5a                   	pop    %edx
 120:	68 eb 09 00 00       	push   $0x9eb
 125:	6a 01                	push   $0x1
 127:	e8 94 04 00 00       	call   5c0 <printf>
	exit();
 12c:	e8 22 03 00 00       	call   453 <exit>
        printf(1, "\n*** Parent ***\n");
 131:	50                   	push   %eax
 132:	50                   	push   %eax
 133:	68 3b 0a 00 00       	push   $0xa3b
 138:	6a 01                	push   $0x1
 13a:	e8 81 04 00 00       	call   5c0 <printf>
        for(int k=0;k<size;++k){
 13f:	83 c4 10             	add    $0x10,%esp
 142:	85 db                	test   %ebx,%ebx
 144:	74 39                	je     17f <test+0x14f>
 146:	31 c9                	xor    %ecx,%ecx
 148:	31 db                	xor    %ebx,%ebx
 14a:	eb 14                	jmp    160 <test+0x130>
 14c:	83 c1 01             	add    $0x1,%ecx
 14f:	8b 45 e0             	mov    -0x20(%ebp),%eax
 152:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 155:	83 d3 00             	adc    $0x0,%ebx
 158:	31 da                	xor    %ebx,%edx
 15a:	31 c8                	xor    %ecx,%eax
 15c:	09 c2                	or     %eax,%edx
 15e:	74 1f                	je     17f <test+0x14f>
            if(m1[k] != (char)(65+(k%26))) goto failed;
 160:	b8 4f ec c4 4e       	mov    $0x4ec4ec4f,%eax
 165:	f7 e1                	mul    %ecx
 167:	89 d0                	mov    %edx,%eax
 169:	89 ca                	mov    %ecx,%edx
 16b:	c1 e8 03             	shr    $0x3,%eax
 16e:	6b c0 1a             	imul   $0x1a,%eax,%eax
 171:	29 c2                	sub    %eax,%edx
 173:	89 d0                	mov    %edx,%eax
 175:	83 c0 41             	add    $0x41,%eax
 178:	38 04 0f             	cmp    %al,(%edi,%ecx,1)
 17b:	74 cf                	je     14c <test+0x11c>
 17d:	eb 91                	jmp    110 <test+0xe0>
        wait();
 17f:	e8 d7 02 00 00       	call   45b <wait>
        printf(1, "done processing %d\n", x);
 184:	51                   	push   %ecx
 185:	68 ae ad 01 00       	push   $0x1adae
 18a:	68 4c 0a 00 00       	push   $0xa4c
 18f:	6a 01                	push   $0x1
 191:	e8 2a 04 00 00       	call   5c0 <printf>
        printf(1, "[COW] Lab5 Parent test passed!\n");
 196:	5b                   	pop    %ebx
 197:	5e                   	pop    %esi
 198:	68 70 09 00 00       	push   $0x970
 19d:	6a 01                	push   $0x1
 19f:	e8 1c 04 00 00       	call   5c0 <printf>
 1a4:	83 c4 10             	add    $0x10,%esp
    printf(1, "Donee if elsse\n");
 1a7:	52                   	push   %edx
 1a8:	52                   	push   %edx
 1a9:	68 60 0a 00 00       	push   $0xa60
 1ae:	6a 01                	push   $0x1
 1b0:	e8 0b 04 00 00       	call   5c0 <printf>
    exit();
 1b5:	e8 99 02 00 00       	call   453 <exit>
	printf(1, "Exceeded the PHYSTOP!\n");
 1ba:	53                   	push   %ebx
 1bb:	53                   	push   %ebx
 1bc:	68 d4 09 00 00       	push   $0x9d4
 1c1:	e9 51 ff ff ff       	jmp    117 <test+0xe7>
	printf(1, "Failed to fork a process!\n");
 1c6:	51                   	push   %ecx
 1c7:	51                   	push   %ecx
 1c8:	68 10 0a 00 00       	push   $0xa10
 1cd:	e9 45 ff ff ff       	jmp    117 <test+0xe7>
        printf(1, "[COW] Lab5 Child test passed!\n");
 1d2:	50                   	push   %eax
 1d3:	50                   	push   %eax
 1d4:	68 50 09 00 00       	push   $0x950
 1d9:	6a 01                	push   $0x1
 1db:	e8 e0 03 00 00       	call   5c0 <printf>
 1e0:	83 c4 10             	add    $0x10,%esp
 1e3:	eb c2                	jmp    1a7 <test+0x177>
 1e5:	66 90                	xchg   %ax,%ax
 1e7:	66 90                	xchg   %ax,%ax
 1e9:	66 90                	xchg   %ax,%ax
 1eb:	66 90                	xchg   %ax,%ax
 1ed:	66 90                	xchg   %ax,%ax
 1ef:	90                   	nop

000001f0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 1f0:	f3 0f 1e fb          	endbr32 
 1f4:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1f5:	31 c0                	xor    %eax,%eax
{
 1f7:	89 e5                	mov    %esp,%ebp
 1f9:	53                   	push   %ebx
 1fa:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1fd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while((*s++ = *t++) != 0)
 200:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 204:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 207:	83 c0 01             	add    $0x1,%eax
 20a:	84 d2                	test   %dl,%dl
 20c:	75 f2                	jne    200 <strcpy+0x10>
    ;
  return os;
}
 20e:	89 c8                	mov    %ecx,%eax
 210:	5b                   	pop    %ebx
 211:	5d                   	pop    %ebp
 212:	c3                   	ret    
 213:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 21a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000220 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 220:	f3 0f 1e fb          	endbr32 
 224:	55                   	push   %ebp
 225:	89 e5                	mov    %esp,%ebp
 227:	53                   	push   %ebx
 228:	8b 4d 08             	mov    0x8(%ebp),%ecx
 22b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 22e:	0f b6 01             	movzbl (%ecx),%eax
 231:	0f b6 1a             	movzbl (%edx),%ebx
 234:	84 c0                	test   %al,%al
 236:	75 19                	jne    251 <strcmp+0x31>
 238:	eb 26                	jmp    260 <strcmp+0x40>
 23a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 240:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
 244:	83 c1 01             	add    $0x1,%ecx
 247:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 24a:	0f b6 1a             	movzbl (%edx),%ebx
 24d:	84 c0                	test   %al,%al
 24f:	74 0f                	je     260 <strcmp+0x40>
 251:	38 d8                	cmp    %bl,%al
 253:	74 eb                	je     240 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 255:	29 d8                	sub    %ebx,%eax
}
 257:	5b                   	pop    %ebx
 258:	5d                   	pop    %ebp
 259:	c3                   	ret    
 25a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 260:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 262:	29 d8                	sub    %ebx,%eax
}
 264:	5b                   	pop    %ebx
 265:	5d                   	pop    %ebp
 266:	c3                   	ret    
 267:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 26e:	66 90                	xchg   %ax,%ax

00000270 <strlen>:

uint
strlen(const char *s)
{
 270:	f3 0f 1e fb          	endbr32 
 274:	55                   	push   %ebp
 275:	89 e5                	mov    %esp,%ebp
 277:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 27a:	80 3a 00             	cmpb   $0x0,(%edx)
 27d:	74 21                	je     2a0 <strlen+0x30>
 27f:	31 c0                	xor    %eax,%eax
 281:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 288:	83 c0 01             	add    $0x1,%eax
 28b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 28f:	89 c1                	mov    %eax,%ecx
 291:	75 f5                	jne    288 <strlen+0x18>
    ;
  return n;
}
 293:	89 c8                	mov    %ecx,%eax
 295:	5d                   	pop    %ebp
 296:	c3                   	ret    
 297:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 29e:	66 90                	xchg   %ax,%ax
  for(n = 0; s[n]; n++)
 2a0:	31 c9                	xor    %ecx,%ecx
}
 2a2:	5d                   	pop    %ebp
 2a3:	89 c8                	mov    %ecx,%eax
 2a5:	c3                   	ret    
 2a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2ad:	8d 76 00             	lea    0x0(%esi),%esi

000002b0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2b0:	f3 0f 1e fb          	endbr32 
 2b4:	55                   	push   %ebp
 2b5:	89 e5                	mov    %esp,%ebp
 2b7:	57                   	push   %edi
 2b8:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 2bb:	8b 4d 10             	mov    0x10(%ebp),%ecx
 2be:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c1:	89 d7                	mov    %edx,%edi
 2c3:	fc                   	cld    
 2c4:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 2c6:	89 d0                	mov    %edx,%eax
 2c8:	5f                   	pop    %edi
 2c9:	5d                   	pop    %ebp
 2ca:	c3                   	ret    
 2cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2cf:	90                   	nop

000002d0 <strchr>:

char*
strchr(const char *s, char c)
{
 2d0:	f3 0f 1e fb          	endbr32 
 2d4:	55                   	push   %ebp
 2d5:	89 e5                	mov    %esp,%ebp
 2d7:	8b 45 08             	mov    0x8(%ebp),%eax
 2da:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 2de:	0f b6 10             	movzbl (%eax),%edx
 2e1:	84 d2                	test   %dl,%dl
 2e3:	75 16                	jne    2fb <strchr+0x2b>
 2e5:	eb 21                	jmp    308 <strchr+0x38>
 2e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2ee:	66 90                	xchg   %ax,%ax
 2f0:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 2f4:	83 c0 01             	add    $0x1,%eax
 2f7:	84 d2                	test   %dl,%dl
 2f9:	74 0d                	je     308 <strchr+0x38>
    if(*s == c)
 2fb:	38 d1                	cmp    %dl,%cl
 2fd:	75 f1                	jne    2f0 <strchr+0x20>
      return (char*)s;
  return 0;
}
 2ff:	5d                   	pop    %ebp
 300:	c3                   	ret    
 301:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 308:	31 c0                	xor    %eax,%eax
}
 30a:	5d                   	pop    %ebp
 30b:	c3                   	ret    
 30c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000310 <gets>:

char*
gets(char *buf, int max)
{
 310:	f3 0f 1e fb          	endbr32 
 314:	55                   	push   %ebp
 315:	89 e5                	mov    %esp,%ebp
 317:	57                   	push   %edi
 318:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 319:	31 f6                	xor    %esi,%esi
{
 31b:	53                   	push   %ebx
 31c:	89 f3                	mov    %esi,%ebx
 31e:	83 ec 1c             	sub    $0x1c,%esp
 321:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 324:	eb 33                	jmp    359 <gets+0x49>
 326:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 32d:	8d 76 00             	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 330:	83 ec 04             	sub    $0x4,%esp
 333:	8d 45 e7             	lea    -0x19(%ebp),%eax
 336:	6a 01                	push   $0x1
 338:	50                   	push   %eax
 339:	6a 00                	push   $0x0
 33b:	e8 2b 01 00 00       	call   46b <read>
    if(cc < 1)
 340:	83 c4 10             	add    $0x10,%esp
 343:	85 c0                	test   %eax,%eax
 345:	7e 1c                	jle    363 <gets+0x53>
      break;
    buf[i++] = c;
 347:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 34b:	83 c7 01             	add    $0x1,%edi
 34e:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 351:	3c 0a                	cmp    $0xa,%al
 353:	74 23                	je     378 <gets+0x68>
 355:	3c 0d                	cmp    $0xd,%al
 357:	74 1f                	je     378 <gets+0x68>
  for(i=0; i+1 < max; ){
 359:	83 c3 01             	add    $0x1,%ebx
 35c:	89 fe                	mov    %edi,%esi
 35e:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 361:	7c cd                	jl     330 <gets+0x20>
 363:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 365:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 368:	c6 03 00             	movb   $0x0,(%ebx)
}
 36b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 36e:	5b                   	pop    %ebx
 36f:	5e                   	pop    %esi
 370:	5f                   	pop    %edi
 371:	5d                   	pop    %ebp
 372:	c3                   	ret    
 373:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 377:	90                   	nop
 378:	8b 75 08             	mov    0x8(%ebp),%esi
 37b:	8b 45 08             	mov    0x8(%ebp),%eax
 37e:	01 de                	add    %ebx,%esi
 380:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 382:	c6 03 00             	movb   $0x0,(%ebx)
}
 385:	8d 65 f4             	lea    -0xc(%ebp),%esp
 388:	5b                   	pop    %ebx
 389:	5e                   	pop    %esi
 38a:	5f                   	pop    %edi
 38b:	5d                   	pop    %ebp
 38c:	c3                   	ret    
 38d:	8d 76 00             	lea    0x0(%esi),%esi

00000390 <stat>:

int
stat(const char *n, struct stat *st)
{
 390:	f3 0f 1e fb          	endbr32 
 394:	55                   	push   %ebp
 395:	89 e5                	mov    %esp,%ebp
 397:	56                   	push   %esi
 398:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 399:	83 ec 08             	sub    $0x8,%esp
 39c:	6a 00                	push   $0x0
 39e:	ff 75 08             	pushl  0x8(%ebp)
 3a1:	e8 ed 00 00 00       	call   493 <open>
  if(fd < 0)
 3a6:	83 c4 10             	add    $0x10,%esp
 3a9:	85 c0                	test   %eax,%eax
 3ab:	78 2b                	js     3d8 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 3ad:	83 ec 08             	sub    $0x8,%esp
 3b0:	ff 75 0c             	pushl  0xc(%ebp)
 3b3:	89 c3                	mov    %eax,%ebx
 3b5:	50                   	push   %eax
 3b6:	e8 f0 00 00 00       	call   4ab <fstat>
  close(fd);
 3bb:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 3be:	89 c6                	mov    %eax,%esi
  close(fd);
 3c0:	e8 b6 00 00 00       	call   47b <close>
  return r;
 3c5:	83 c4 10             	add    $0x10,%esp
}
 3c8:	8d 65 f8             	lea    -0x8(%ebp),%esp
 3cb:	89 f0                	mov    %esi,%eax
 3cd:	5b                   	pop    %ebx
 3ce:	5e                   	pop    %esi
 3cf:	5d                   	pop    %ebp
 3d0:	c3                   	ret    
 3d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
 3d8:	be ff ff ff ff       	mov    $0xffffffff,%esi
 3dd:	eb e9                	jmp    3c8 <stat+0x38>
 3df:	90                   	nop

000003e0 <atoi>:

int
atoi(const char *s)
{
 3e0:	f3 0f 1e fb          	endbr32 
 3e4:	55                   	push   %ebp
 3e5:	89 e5                	mov    %esp,%ebp
 3e7:	53                   	push   %ebx
 3e8:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3eb:	0f be 02             	movsbl (%edx),%eax
 3ee:	8d 48 d0             	lea    -0x30(%eax),%ecx
 3f1:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 3f4:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 3f9:	77 1a                	ja     415 <atoi+0x35>
 3fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3ff:	90                   	nop
    n = n*10 + *s++ - '0';
 400:	83 c2 01             	add    $0x1,%edx
 403:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 406:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 40a:	0f be 02             	movsbl (%edx),%eax
 40d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 410:	80 fb 09             	cmp    $0x9,%bl
 413:	76 eb                	jbe    400 <atoi+0x20>
  return n;
}
 415:	89 c8                	mov    %ecx,%eax
 417:	5b                   	pop    %ebx
 418:	5d                   	pop    %ebp
 419:	c3                   	ret    
 41a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000420 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 420:	f3 0f 1e fb          	endbr32 
 424:	55                   	push   %ebp
 425:	89 e5                	mov    %esp,%ebp
 427:	57                   	push   %edi
 428:	8b 45 10             	mov    0x10(%ebp),%eax
 42b:	8b 55 08             	mov    0x8(%ebp),%edx
 42e:	56                   	push   %esi
 42f:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 432:	85 c0                	test   %eax,%eax
 434:	7e 0f                	jle    445 <memmove+0x25>
 436:	01 d0                	add    %edx,%eax
  dst = vdst;
 438:	89 d7                	mov    %edx,%edi
 43a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *dst++ = *src++;
 440:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 441:	39 f8                	cmp    %edi,%eax
 443:	75 fb                	jne    440 <memmove+0x20>
  return vdst;
}
 445:	5e                   	pop    %esi
 446:	89 d0                	mov    %edx,%eax
 448:	5f                   	pop    %edi
 449:	5d                   	pop    %ebp
 44a:	c3                   	ret    

0000044b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 44b:	b8 01 00 00 00       	mov    $0x1,%eax
 450:	cd 40                	int    $0x40
 452:	c3                   	ret    

00000453 <exit>:
SYSCALL(exit)
 453:	b8 02 00 00 00       	mov    $0x2,%eax
 458:	cd 40                	int    $0x40
 45a:	c3                   	ret    

0000045b <wait>:
SYSCALL(wait)
 45b:	b8 03 00 00 00       	mov    $0x3,%eax
 460:	cd 40                	int    $0x40
 462:	c3                   	ret    

00000463 <pipe>:
SYSCALL(pipe)
 463:	b8 04 00 00 00       	mov    $0x4,%eax
 468:	cd 40                	int    $0x40
 46a:	c3                   	ret    

0000046b <read>:
SYSCALL(read)
 46b:	b8 05 00 00 00       	mov    $0x5,%eax
 470:	cd 40                	int    $0x40
 472:	c3                   	ret    

00000473 <write>:
SYSCALL(write)
 473:	b8 10 00 00 00       	mov    $0x10,%eax
 478:	cd 40                	int    $0x40
 47a:	c3                   	ret    

0000047b <close>:
SYSCALL(close)
 47b:	b8 15 00 00 00       	mov    $0x15,%eax
 480:	cd 40                	int    $0x40
 482:	c3                   	ret    

00000483 <kill>:
SYSCALL(kill)
 483:	b8 06 00 00 00       	mov    $0x6,%eax
 488:	cd 40                	int    $0x40
 48a:	c3                   	ret    

0000048b <exec>:
SYSCALL(exec)
 48b:	b8 07 00 00 00       	mov    $0x7,%eax
 490:	cd 40                	int    $0x40
 492:	c3                   	ret    

00000493 <open>:
SYSCALL(open)
 493:	b8 0f 00 00 00       	mov    $0xf,%eax
 498:	cd 40                	int    $0x40
 49a:	c3                   	ret    

0000049b <mknod>:
SYSCALL(mknod)
 49b:	b8 11 00 00 00       	mov    $0x11,%eax
 4a0:	cd 40                	int    $0x40
 4a2:	c3                   	ret    

000004a3 <unlink>:
SYSCALL(unlink)
 4a3:	b8 12 00 00 00       	mov    $0x12,%eax
 4a8:	cd 40                	int    $0x40
 4aa:	c3                   	ret    

000004ab <fstat>:
SYSCALL(fstat)
 4ab:	b8 08 00 00 00       	mov    $0x8,%eax
 4b0:	cd 40                	int    $0x40
 4b2:	c3                   	ret    

000004b3 <link>:
SYSCALL(link)
 4b3:	b8 13 00 00 00       	mov    $0x13,%eax
 4b8:	cd 40                	int    $0x40
 4ba:	c3                   	ret    

000004bb <mkdir>:
SYSCALL(mkdir)
 4bb:	b8 14 00 00 00       	mov    $0x14,%eax
 4c0:	cd 40                	int    $0x40
 4c2:	c3                   	ret    

000004c3 <chdir>:
SYSCALL(chdir)
 4c3:	b8 09 00 00 00       	mov    $0x9,%eax
 4c8:	cd 40                	int    $0x40
 4ca:	c3                   	ret    

000004cb <dup>:
SYSCALL(dup)
 4cb:	b8 0a 00 00 00       	mov    $0xa,%eax
 4d0:	cd 40                	int    $0x40
 4d2:	c3                   	ret    

000004d3 <getpid>:
SYSCALL(getpid)
 4d3:	b8 0b 00 00 00       	mov    $0xb,%eax
 4d8:	cd 40                	int    $0x40
 4da:	c3                   	ret    

000004db <sbrk>:
SYSCALL(sbrk)
 4db:	b8 0c 00 00 00       	mov    $0xc,%eax
 4e0:	cd 40                	int    $0x40
 4e2:	c3                   	ret    

000004e3 <sleep>:
SYSCALL(sleep)
 4e3:	b8 0d 00 00 00       	mov    $0xd,%eax
 4e8:	cd 40                	int    $0x40
 4ea:	c3                   	ret    

000004eb <uptime>:
SYSCALL(uptime)
 4eb:	b8 0e 00 00 00       	mov    $0xe,%eax
 4f0:	cd 40                	int    $0x40
 4f2:	c3                   	ret    

000004f3 <getrss>:
SYSCALL(getrss)
 4f3:	b8 16 00 00 00       	mov    $0x16,%eax
 4f8:	cd 40                	int    $0x40
 4fa:	c3                   	ret    

000004fb <getNumFreePages>:
 4fb:	b8 17 00 00 00       	mov    $0x17,%eax
 500:	cd 40                	int    $0x40
 502:	c3                   	ret    
 503:	66 90                	xchg   %ax,%ax
 505:	66 90                	xchg   %ax,%ax
 507:	66 90                	xchg   %ax,%ax
 509:	66 90                	xchg   %ax,%ax
 50b:	66 90                	xchg   %ax,%ax
 50d:	66 90                	xchg   %ax,%ax
 50f:	90                   	nop

00000510 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 510:	55                   	push   %ebp
 511:	89 e5                	mov    %esp,%ebp
 513:	57                   	push   %edi
 514:	56                   	push   %esi
 515:	53                   	push   %ebx
 516:	83 ec 3c             	sub    $0x3c,%esp
 519:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 51c:	89 d1                	mov    %edx,%ecx
{
 51e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 521:	85 d2                	test   %edx,%edx
 523:	0f 89 7f 00 00 00    	jns    5a8 <printint+0x98>
 529:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 52d:	74 79                	je     5a8 <printint+0x98>
    neg = 1;
 52f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 536:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 538:	31 db                	xor    %ebx,%ebx
 53a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 53d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 540:	89 c8                	mov    %ecx,%eax
 542:	31 d2                	xor    %edx,%edx
 544:	89 cf                	mov    %ecx,%edi
 546:	f7 75 c4             	divl   -0x3c(%ebp)
 549:	0f b6 92 8c 0a 00 00 	movzbl 0xa8c(%edx),%edx
 550:	89 45 c0             	mov    %eax,-0x40(%ebp)
 553:	89 d8                	mov    %ebx,%eax
 555:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 558:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 55b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 55e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 561:	76 dd                	jbe    540 <printint+0x30>
  if(neg)
 563:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 566:	85 c9                	test   %ecx,%ecx
 568:	74 0c                	je     576 <printint+0x66>
    buf[i++] = '-';
 56a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 56f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 571:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 576:	8b 7d b8             	mov    -0x48(%ebp),%edi
 579:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 57d:	eb 07                	jmp    586 <printint+0x76>
 57f:	90                   	nop
 580:	0f b6 13             	movzbl (%ebx),%edx
 583:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 586:	83 ec 04             	sub    $0x4,%esp
 589:	88 55 d7             	mov    %dl,-0x29(%ebp)
 58c:	6a 01                	push   $0x1
 58e:	56                   	push   %esi
 58f:	57                   	push   %edi
 590:	e8 de fe ff ff       	call   473 <write>
  while(--i >= 0)
 595:	83 c4 10             	add    $0x10,%esp
 598:	39 de                	cmp    %ebx,%esi
 59a:	75 e4                	jne    580 <printint+0x70>
    putc(fd, buf[i]);
}
 59c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 59f:	5b                   	pop    %ebx
 5a0:	5e                   	pop    %esi
 5a1:	5f                   	pop    %edi
 5a2:	5d                   	pop    %ebp
 5a3:	c3                   	ret    
 5a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 5a8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 5af:	eb 87                	jmp    538 <printint+0x28>
 5b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5bf:	90                   	nop

000005c0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 5c0:	f3 0f 1e fb          	endbr32 
 5c4:	55                   	push   %ebp
 5c5:	89 e5                	mov    %esp,%ebp
 5c7:	57                   	push   %edi
 5c8:	56                   	push   %esi
 5c9:	53                   	push   %ebx
 5ca:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5cd:	8b 75 0c             	mov    0xc(%ebp),%esi
 5d0:	0f b6 1e             	movzbl (%esi),%ebx
 5d3:	84 db                	test   %bl,%bl
 5d5:	0f 84 b4 00 00 00    	je     68f <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
 5db:	8d 45 10             	lea    0x10(%ebp),%eax
 5de:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 5e1:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 5e4:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 5e6:	89 45 d0             	mov    %eax,-0x30(%ebp)
 5e9:	eb 33                	jmp    61e <printf+0x5e>
 5eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 5ef:	90                   	nop
 5f0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 5f3:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 5f8:	83 f8 25             	cmp    $0x25,%eax
 5fb:	74 17                	je     614 <printf+0x54>
  write(fd, &c, 1);
 5fd:	83 ec 04             	sub    $0x4,%esp
 600:	88 5d e7             	mov    %bl,-0x19(%ebp)
 603:	6a 01                	push   $0x1
 605:	57                   	push   %edi
 606:	ff 75 08             	pushl  0x8(%ebp)
 609:	e8 65 fe ff ff       	call   473 <write>
 60e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 611:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 614:	0f b6 1e             	movzbl (%esi),%ebx
 617:	83 c6 01             	add    $0x1,%esi
 61a:	84 db                	test   %bl,%bl
 61c:	74 71                	je     68f <printf+0xcf>
    c = fmt[i] & 0xff;
 61e:	0f be cb             	movsbl %bl,%ecx
 621:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 624:	85 d2                	test   %edx,%edx
 626:	74 c8                	je     5f0 <printf+0x30>
      }
    } else if(state == '%'){
 628:	83 fa 25             	cmp    $0x25,%edx
 62b:	75 e7                	jne    614 <printf+0x54>
      if(c == 'd'){
 62d:	83 f8 64             	cmp    $0x64,%eax
 630:	0f 84 9a 00 00 00    	je     6d0 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 636:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 63c:	83 f9 70             	cmp    $0x70,%ecx
 63f:	74 5f                	je     6a0 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 641:	83 f8 73             	cmp    $0x73,%eax
 644:	0f 84 d6 00 00 00    	je     720 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 64a:	83 f8 63             	cmp    $0x63,%eax
 64d:	0f 84 8d 00 00 00    	je     6e0 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 653:	83 f8 25             	cmp    $0x25,%eax
 656:	0f 84 b4 00 00 00    	je     710 <printf+0x150>
  write(fd, &c, 1);
 65c:	83 ec 04             	sub    $0x4,%esp
 65f:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 663:	6a 01                	push   $0x1
 665:	57                   	push   %edi
 666:	ff 75 08             	pushl  0x8(%ebp)
 669:	e8 05 fe ff ff       	call   473 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 66e:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 671:	83 c4 0c             	add    $0xc,%esp
 674:	6a 01                	push   $0x1
 676:	83 c6 01             	add    $0x1,%esi
 679:	57                   	push   %edi
 67a:	ff 75 08             	pushl  0x8(%ebp)
 67d:	e8 f1 fd ff ff       	call   473 <write>
  for(i = 0; fmt[i]; i++){
 682:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 686:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 689:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 68b:	84 db                	test   %bl,%bl
 68d:	75 8f                	jne    61e <printf+0x5e>
    }
  }
}
 68f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 692:	5b                   	pop    %ebx
 693:	5e                   	pop    %esi
 694:	5f                   	pop    %edi
 695:	5d                   	pop    %ebp
 696:	c3                   	ret    
 697:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 69e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 6a0:	83 ec 0c             	sub    $0xc,%esp
 6a3:	b9 10 00 00 00       	mov    $0x10,%ecx
 6a8:	6a 00                	push   $0x0
 6aa:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 6ad:	8b 45 08             	mov    0x8(%ebp),%eax
 6b0:	8b 13                	mov    (%ebx),%edx
 6b2:	e8 59 fe ff ff       	call   510 <printint>
        ap++;
 6b7:	89 d8                	mov    %ebx,%eax
 6b9:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6bc:	31 d2                	xor    %edx,%edx
        ap++;
 6be:	83 c0 04             	add    $0x4,%eax
 6c1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 6c4:	e9 4b ff ff ff       	jmp    614 <printf+0x54>
 6c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 6d0:	83 ec 0c             	sub    $0xc,%esp
 6d3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 6d8:	6a 01                	push   $0x1
 6da:	eb ce                	jmp    6aa <printf+0xea>
 6dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 6e0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 6e3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 6e6:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 6e8:	6a 01                	push   $0x1
        ap++;
 6ea:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 6ed:	57                   	push   %edi
 6ee:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 6f1:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 6f4:	e8 7a fd ff ff       	call   473 <write>
        ap++;
 6f9:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 6fc:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6ff:	31 d2                	xor    %edx,%edx
 701:	e9 0e ff ff ff       	jmp    614 <printf+0x54>
 706:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 70d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 710:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 713:	83 ec 04             	sub    $0x4,%esp
 716:	e9 59 ff ff ff       	jmp    674 <printf+0xb4>
 71b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 71f:	90                   	nop
        s = (char*)*ap;
 720:	8b 45 d0             	mov    -0x30(%ebp),%eax
 723:	8b 18                	mov    (%eax),%ebx
        ap++;
 725:	83 c0 04             	add    $0x4,%eax
 728:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 72b:	85 db                	test   %ebx,%ebx
 72d:	74 17                	je     746 <printf+0x186>
        while(*s != 0){
 72f:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 732:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 734:	84 c0                	test   %al,%al
 736:	0f 84 d8 fe ff ff    	je     614 <printf+0x54>
 73c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 73f:	89 de                	mov    %ebx,%esi
 741:	8b 5d 08             	mov    0x8(%ebp),%ebx
 744:	eb 1a                	jmp    760 <printf+0x1a0>
          s = "(null)";
 746:	bb 82 0a 00 00       	mov    $0xa82,%ebx
        while(*s != 0){
 74b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 74e:	b8 28 00 00 00       	mov    $0x28,%eax
 753:	89 de                	mov    %ebx,%esi
 755:	8b 5d 08             	mov    0x8(%ebp),%ebx
 758:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 75f:	90                   	nop
  write(fd, &c, 1);
 760:	83 ec 04             	sub    $0x4,%esp
          s++;
 763:	83 c6 01             	add    $0x1,%esi
 766:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 769:	6a 01                	push   $0x1
 76b:	57                   	push   %edi
 76c:	53                   	push   %ebx
 76d:	e8 01 fd ff ff       	call   473 <write>
        while(*s != 0){
 772:	0f b6 06             	movzbl (%esi),%eax
 775:	83 c4 10             	add    $0x10,%esp
 778:	84 c0                	test   %al,%al
 77a:	75 e4                	jne    760 <printf+0x1a0>
 77c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 77f:	31 d2                	xor    %edx,%edx
 781:	e9 8e fe ff ff       	jmp    614 <printf+0x54>
 786:	66 90                	xchg   %ax,%ax
 788:	66 90                	xchg   %ax,%ax
 78a:	66 90                	xchg   %ax,%ax
 78c:	66 90                	xchg   %ax,%ax
 78e:	66 90                	xchg   %ax,%ax

00000790 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 790:	f3 0f 1e fb          	endbr32 
 794:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 795:	a1 54 0d 00 00       	mov    0xd54,%eax
{
 79a:	89 e5                	mov    %esp,%ebp
 79c:	57                   	push   %edi
 79d:	56                   	push   %esi
 79e:	53                   	push   %ebx
 79f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 7a2:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 7a4:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a7:	39 c8                	cmp    %ecx,%eax
 7a9:	73 15                	jae    7c0 <free+0x30>
 7ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 7af:	90                   	nop
 7b0:	39 d1                	cmp    %edx,%ecx
 7b2:	72 14                	jb     7c8 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7b4:	39 d0                	cmp    %edx,%eax
 7b6:	73 10                	jae    7c8 <free+0x38>
{
 7b8:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ba:	8b 10                	mov    (%eax),%edx
 7bc:	39 c8                	cmp    %ecx,%eax
 7be:	72 f0                	jb     7b0 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7c0:	39 d0                	cmp    %edx,%eax
 7c2:	72 f4                	jb     7b8 <free+0x28>
 7c4:	39 d1                	cmp    %edx,%ecx
 7c6:	73 f0                	jae    7b8 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7c8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 7cb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 7ce:	39 fa                	cmp    %edi,%edx
 7d0:	74 1e                	je     7f0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 7d2:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 7d5:	8b 50 04             	mov    0x4(%eax),%edx
 7d8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 7db:	39 f1                	cmp    %esi,%ecx
 7dd:	74 28                	je     807 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 7df:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 7e1:	5b                   	pop    %ebx
  freep = p;
 7e2:	a3 54 0d 00 00       	mov    %eax,0xd54
}
 7e7:	5e                   	pop    %esi
 7e8:	5f                   	pop    %edi
 7e9:	5d                   	pop    %ebp
 7ea:	c3                   	ret    
 7eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 7ef:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 7f0:	03 72 04             	add    0x4(%edx),%esi
 7f3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 7f6:	8b 10                	mov    (%eax),%edx
 7f8:	8b 12                	mov    (%edx),%edx
 7fa:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 7fd:	8b 50 04             	mov    0x4(%eax),%edx
 800:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 803:	39 f1                	cmp    %esi,%ecx
 805:	75 d8                	jne    7df <free+0x4f>
    p->s.size += bp->s.size;
 807:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 80a:	a3 54 0d 00 00       	mov    %eax,0xd54
    p->s.size += bp->s.size;
 80f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 812:	8b 53 f8             	mov    -0x8(%ebx),%edx
 815:	89 10                	mov    %edx,(%eax)
}
 817:	5b                   	pop    %ebx
 818:	5e                   	pop    %esi
 819:	5f                   	pop    %edi
 81a:	5d                   	pop    %ebp
 81b:	c3                   	ret    
 81c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000820 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 820:	f3 0f 1e fb          	endbr32 
 824:	55                   	push   %ebp
 825:	89 e5                	mov    %esp,%ebp
 827:	57                   	push   %edi
 828:	56                   	push   %esi
 829:	53                   	push   %ebx
 82a:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 82d:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 830:	8b 3d 54 0d 00 00    	mov    0xd54,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 836:	8d 70 07             	lea    0x7(%eax),%esi
 839:	c1 ee 03             	shr    $0x3,%esi
 83c:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 83f:	85 ff                	test   %edi,%edi
 841:	0f 84 a9 00 00 00    	je     8f0 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 847:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 849:	8b 48 04             	mov    0x4(%eax),%ecx
 84c:	39 f1                	cmp    %esi,%ecx
 84e:	73 6d                	jae    8bd <malloc+0x9d>
 850:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 856:	bb 00 10 00 00       	mov    $0x1000,%ebx
 85b:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 85e:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 865:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 868:	eb 17                	jmp    881 <malloc+0x61>
 86a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 870:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 872:	8b 4a 04             	mov    0x4(%edx),%ecx
 875:	39 f1                	cmp    %esi,%ecx
 877:	73 4f                	jae    8c8 <malloc+0xa8>
 879:	8b 3d 54 0d 00 00    	mov    0xd54,%edi
 87f:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 881:	39 c7                	cmp    %eax,%edi
 883:	75 eb                	jne    870 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 885:	83 ec 0c             	sub    $0xc,%esp
 888:	ff 75 e4             	pushl  -0x1c(%ebp)
 88b:	e8 4b fc ff ff       	call   4db <sbrk>
  if(p == (char*)-1)
 890:	83 c4 10             	add    $0x10,%esp
 893:	83 f8 ff             	cmp    $0xffffffff,%eax
 896:	74 1b                	je     8b3 <malloc+0x93>
  hp->s.size = nu;
 898:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 89b:	83 ec 0c             	sub    $0xc,%esp
 89e:	83 c0 08             	add    $0x8,%eax
 8a1:	50                   	push   %eax
 8a2:	e8 e9 fe ff ff       	call   790 <free>
  return freep;
 8a7:	a1 54 0d 00 00       	mov    0xd54,%eax
      if((p = morecore(nunits)) == 0)
 8ac:	83 c4 10             	add    $0x10,%esp
 8af:	85 c0                	test   %eax,%eax
 8b1:	75 bd                	jne    870 <malloc+0x50>
        return 0;
  }
}
 8b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 8b6:	31 c0                	xor    %eax,%eax
}
 8b8:	5b                   	pop    %ebx
 8b9:	5e                   	pop    %esi
 8ba:	5f                   	pop    %edi
 8bb:	5d                   	pop    %ebp
 8bc:	c3                   	ret    
    if(p->s.size >= nunits){
 8bd:	89 c2                	mov    %eax,%edx
 8bf:	89 f8                	mov    %edi,%eax
 8c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 8c8:	39 ce                	cmp    %ecx,%esi
 8ca:	74 54                	je     920 <malloc+0x100>
        p->s.size -= nunits;
 8cc:	29 f1                	sub    %esi,%ecx
 8ce:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 8d1:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 8d4:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 8d7:	a3 54 0d 00 00       	mov    %eax,0xd54
}
 8dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 8df:	8d 42 08             	lea    0x8(%edx),%eax
}
 8e2:	5b                   	pop    %ebx
 8e3:	5e                   	pop    %esi
 8e4:	5f                   	pop    %edi
 8e5:	5d                   	pop    %ebp
 8e6:	c3                   	ret    
 8e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 8ee:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 8f0:	c7 05 54 0d 00 00 58 	movl   $0xd58,0xd54
 8f7:	0d 00 00 
    base.s.size = 0;
 8fa:	bf 58 0d 00 00       	mov    $0xd58,%edi
    base.s.ptr = freep = prevp = &base;
 8ff:	c7 05 58 0d 00 00 58 	movl   $0xd58,0xd58
 906:	0d 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 909:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
 90b:	c7 05 5c 0d 00 00 00 	movl   $0x0,0xd5c
 912:	00 00 00 
    if(p->s.size >= nunits){
 915:	e9 36 ff ff ff       	jmp    850 <malloc+0x30>
 91a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 920:	8b 0a                	mov    (%edx),%ecx
 922:	89 08                	mov    %ecx,(%eax)
 924:	eb b1                	jmp    8d7 <malloc+0xb7>
