
_testcow3:     file format elf32-i386


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
  15:	68 d4 0a 00 00       	push   $0xad4
  1a:	6a 01                	push   $0x1
  1c:	e8 bf 06 00 00       	call   6e0 <printf>
	test();
  21:	e8 3a 00 00 00       	call   60 <test>
  26:	66 90                	xchg   %ax,%ax
  28:	66 90                	xchg   %ax,%ax
  2a:	66 90                	xchg   %ax,%ax
  2c:	66 90                	xchg   %ax,%ax
  2e:	66 90                	xchg   %ax,%ax

00000030 <processing>:
processing(int *x) {
  30:	f3 0f 1e fb          	endbr32 
  34:	55                   	push   %ebp
  35:	89 e5                	mov    %esp,%ebp
  37:	83 ec 0c             	sub    $0xc,%esp
  3a:	8b 45 08             	mov    0x8(%ebp),%eax
  3d:	c7 00 ae ad 01 00    	movl   $0x1adae,(%eax)
    printf(1, "done processing %d\n", x);
  43:	50                   	push   %eax
  44:	68 48 0a 00 00       	push   $0xa48
  49:	6a 01                	push   $0x1
  4b:	e8 90 06 00 00       	call   6e0 <printf>
}
  50:	83 c4 10             	add    $0x10,%esp
  53:	c9                   	leave  
  54:	c3                   	ret    
  55:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000060 <test>:
{
  60:	f3 0f 1e fb          	endbr32 
  64:	55                   	push   %ebp
  65:	89 e5                	mov    %esp,%ebp
  67:	57                   	push   %edi
  68:	56                   	push   %esi
  69:	53                   	push   %ebx
  6a:	83 ec 2c             	sub    $0x2c,%esp
    uint prev_free_pages = getNumFreePages();
  6d:	e8 a9 05 00 00       	call   61b <getNumFreePages>
    char *m1 = (char*)malloc(size);
  72:	83 ec 0c             	sub    $0xc,%esp
    long long size = ((prev_free_pages - 20) * 4 * 1024) / 2; // 20 pages will be used by kernel to create kstack, and process related datastructures.
  75:	8d 70 ec             	lea    -0x14(%eax),%esi
  78:	c1 e6 0c             	shl    $0xc,%esi
  7b:	d1 ee                	shr    %esi
    char *m1 = (char*)malloc(size);
  7d:	56                   	push   %esi
  7e:	e8 bd 08 00 00       	call   940 <malloc>
    if (m1 == 0) goto out_of_memory;
  83:	83 c4 10             	add    $0x10,%esp
  86:	85 c0                	test   %eax,%eax
  88:	0f 84 a8 01 00 00    	je     236 <test+0x1d6>
    printf(1, "\n*** Forking ***\n");
  8e:	83 ec 08             	sub    $0x8,%esp
  91:	89 c7                	mov    %eax,%edi
  93:	68 86 0a 00 00       	push   $0xa86
  98:	6a 01                	push   $0x1
  9a:	e8 41 06 00 00       	call   6e0 <printf>
    pid = fork();
  9f:	e8 c7 04 00 00       	call   56b <fork>
    if (pid < 0) goto fork_failed; // Fork failed
  a4:	83 c4 10             	add    $0x10,%esp
    pid = fork();
  a7:	89 c3                	mov    %eax,%ebx
    if (pid < 0) goto fork_failed; // Fork failed
  a9:	85 c0                	test   %eax,%eax
  ab:	0f 88 91 01 00 00    	js     242 <test+0x1e2>
    if (pid == 0) { // Child process
  b1:	0f 85 cb 00 00 00    	jne    182 <test+0x122>
        printf(1, "\n*** Child ***\n");
  b7:	50                   	push   %eax
  b8:	50                   	push   %eax
  b9:	68 b3 0a 00 00       	push   $0xab3
  be:	6a 01                	push   $0x1
  c0:	e8 1b 06 00 00       	call   6e0 <printf>
        prev_free_pages = getNumFreePages();
  c5:	e8 51 05 00 00       	call   61b <getNumFreePages>
        for (int i=0; i<size; i++) {
  ca:	83 c4 10             	add    $0x10,%esp
        prev_free_pages = getNumFreePages();
  cd:	89 45 d0             	mov    %eax,-0x30(%ebp)
        for (int i=0; i<size; i++) {
  d0:	85 f6                	test   %esi,%esi
  d2:	0f 84 a2 01 00 00    	je     27a <test+0x21a>
            m1[i] = (char)(65+(i%26));
  d8:	b9 4f ec c4 4e       	mov    $0x4ec4ec4f,%ecx
  dd:	8d 76 00             	lea    0x0(%esi),%esi
  e0:	89 d8                	mov    %ebx,%eax
  e2:	f7 e1                	mul    %ecx
  e4:	89 d8                	mov    %ebx,%eax
  e6:	c1 ea 03             	shr    $0x3,%edx
  e9:	6b d2 1a             	imul   $0x1a,%edx,%edx
  ec:	29 d0                	sub    %edx,%eax
  ee:	83 c0 41             	add    $0x41,%eax
  f1:	88 04 1f             	mov    %al,(%edi,%ebx,1)
        for (int i=0; i<size; i++) {
  f4:	83 c3 01             	add    $0x1,%ebx
  f7:	39 f3                	cmp    %esi,%ebx
  f9:	75 e5                	jne    e0 <test+0x80>
        curr_free_pages = getNumFreePages();
  fb:	e8 1b 05 00 00       	call   61b <getNumFreePages>
        if (curr_free_pages >= prev_free_pages) {
 100:	39 45 d0             	cmp    %eax,-0x30(%ebp)
 103:	0f 86 5b 01 00 00    	jbe    264 <test+0x204>
        processing(&x);
 109:	83 ec 0c             	sub    $0xc,%esp
 10c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
        int x = 0;
 10f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
        processing(&x);
 116:	50                   	push   %eax
 117:	e8 14 ff ff ff       	call   30 <processing>
        for(int k=0;k<size;++k){
 11c:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 11f:	83 c4 10             	add    $0x10,%esp
        processing(&x);
 122:	31 c9                	xor    %ecx,%ecx
 124:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 12b:	31 db                	xor    %ebx,%ebx
 12d:	eb 19                	jmp    148 <test+0xe8>
 12f:	90                   	nop
        for(int k=0;k<size;++k){
 130:	83 c1 01             	add    $0x1,%ecx
 133:	8b 45 d0             	mov    -0x30(%ebp),%eax
 136:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 139:	83 d3 00             	adc    $0x0,%ebx
 13c:	31 da                	xor    %ebx,%edx
 13e:	31 c8                	xor    %ecx,%eax
 140:	09 c2                	or     %eax,%edx
 142:	0f 84 52 01 00 00    	je     29a <test+0x23a>
			if(m1[k] != (char)(65+(k%26))) goto failed;
 148:	b8 4f ec c4 4e       	mov    $0x4ec4ec4f,%eax
 14d:	f7 e1                	mul    %ecx
 14f:	89 c8                	mov    %ecx,%eax
 151:	c1 ea 03             	shr    $0x3,%edx
 154:	6b d2 1a             	imul   $0x1a,%edx,%edx
 157:	29 d0                	sub    %edx,%eax
 159:	83 c0 41             	add    $0x41,%eax
 15c:	38 04 0f             	cmp    %al,(%edi,%ecx,1)
 15f:	74 cf                	je     130 <test+0xd0>
    printf(1, "Copy failed: The memory contents of the processes is inconsistent!\n");
 161:	50                   	push   %eax
 162:	50                   	push   %eax
 163:	68 94 0b 00 00       	push   $0xb94
	printf(1, "Failed to fork a process!\n");
 168:	6a 01                	push   $0x1
 16a:	e8 71 05 00 00       	call   6e0 <printf>
    printf(1, "Lab5 test failed!\n");
 16f:	58                   	pop    %eax
 170:	5a                   	pop    %edx
 171:	68 73 0a 00 00       	push   $0xa73
 176:	6a 01                	push   $0x1
 178:	e8 63 05 00 00       	call   6e0 <printf>
	exit();
 17d:	e8 f1 03 00 00       	call   573 <exit>
        printf(1, "\n*** Parent ***\n");
 182:	50                   	push   %eax
 183:	50                   	push   %eax
 184:	68 c3 0a 00 00       	push   $0xac3
 189:	6a 01                	push   $0x1
 18b:	e8 50 05 00 00       	call   6e0 <printf>
        prev_free_pages = getNumFreePages();
 190:	e8 86 04 00 00       	call   61b <getNumFreePages>
        for (int i=0; i<size; i++) {
 195:	83 c4 10             	add    $0x10,%esp
        prev_free_pages = getNumFreePages();
 198:	89 45 d0             	mov    %eax,-0x30(%ebp)
        for (int i=0; i<size; i++) {
 19b:	85 f6                	test   %esi,%esi
 19d:	0f 84 0d 01 00 00    	je     2b0 <test+0x250>
 1a3:	31 db                	xor    %ebx,%ebx
            m1[i] = (char)(97+(i%26));
 1a5:	b9 4f ec c4 4e       	mov    $0x4ec4ec4f,%ecx
 1aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1b0:	89 d8                	mov    %ebx,%eax
 1b2:	f7 e1                	mul    %ecx
 1b4:	89 d8                	mov    %ebx,%eax
 1b6:	c1 ea 03             	shr    $0x3,%edx
 1b9:	6b d2 1a             	imul   $0x1a,%edx,%edx
 1bc:	29 d0                	sub    %edx,%eax
 1be:	83 c0 61             	add    $0x61,%eax
 1c1:	88 04 1f             	mov    %al,(%edi,%ebx,1)
        for (int i=0; i<size; i++) {
 1c4:	83 c3 01             	add    $0x1,%ebx
 1c7:	39 f3                	cmp    %esi,%ebx
 1c9:	75 e5                	jne    1b0 <test+0x150>
        curr_free_pages = getNumFreePages();
 1cb:	e8 4b 04 00 00       	call   61b <getNumFreePages>
        if (curr_free_pages >= prev_free_pages) {
 1d0:	39 45 d0             	cmp    %eax,-0x30(%ebp)
 1d3:	76 79                	jbe    24e <test+0x1ee>
        processing(&x);
 1d5:	83 ec 0c             	sub    $0xc,%esp
 1d8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
        int x = 0;
 1db:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
        processing(&x);
 1e2:	50                   	push   %eax
 1e3:	89 45 cc             	mov    %eax,-0x34(%ebp)
 1e6:	e8 45 fe ff ff       	call   30 <processing>
        for(int k=0;k<size;++k){
 1eb:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 1ee:	83 c4 10             	add    $0x10,%esp
        processing(&x);
 1f1:	31 c9                	xor    %ecx,%ecx
 1f3:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 1fa:	31 db                	xor    %ebx,%ebx
 1fc:	eb 1a                	jmp    218 <test+0x1b8>
 1fe:	66 90                	xchg   %ax,%ax
        for(int k=0;k<size;++k){
 200:	83 c1 01             	add    $0x1,%ecx
 203:	8b 45 d0             	mov    -0x30(%ebp),%eax
 206:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 209:	83 d3 00             	adc    $0x0,%ebx
 20c:	31 da                	xor    %ebx,%edx
 20e:	31 c8                	xor    %ecx,%eax
 210:	09 c2                	or     %eax,%edx
 212:	0f 84 bb 00 00 00    	je     2d3 <test+0x273>
			if(m1[k] != (char)(97+(k%26))) goto failed;
 218:	b8 4f ec c4 4e       	mov    $0x4ec4ec4f,%eax
 21d:	f7 e1                	mul    %ecx
 21f:	89 c8                	mov    %ecx,%eax
 221:	c1 ea 03             	shr    $0x3,%edx
 224:	6b d2 1a             	imul   $0x1a,%edx,%edx
 227:	29 d0                	sub    %edx,%eax
 229:	83 c0 61             	add    $0x61,%eax
 22c:	38 04 0f             	cmp    %al,(%edi,%ecx,1)
 22f:	74 cf                	je     200 <test+0x1a0>
 231:	e9 2b ff ff ff       	jmp    161 <test+0x101>
	printf(1, "Exceeded the PHYSTOP!\n");
 236:	53                   	push   %ebx
 237:	53                   	push   %ebx
 238:	68 5c 0a 00 00       	push   $0xa5c
 23d:	e9 26 ff ff ff       	jmp    168 <test+0x108>
	printf(1, "Failed to fork a process!\n");
 242:	51                   	push   %ecx
 243:	51                   	push   %ecx
 244:	68 98 0a 00 00       	push   $0xa98
 249:	e9 1a ff ff ff       	jmp    168 <test+0x108>
            printf(1, "Lab5 Parent: Free pages should decrease after write\n");
 24e:	53                   	push   %ebx
 24f:	53                   	push   %ebx
 250:	68 3c 0b 00 00       	push   $0xb3c
 255:	6a 01                	push   $0x1
 257:	e8 84 04 00 00       	call   6e0 <printf>
            goto failed;
 25c:	83 c4 10             	add    $0x10,%esp
 25f:	e9 fd fe ff ff       	jmp    161 <test+0x101>
            printf(1, "Lab5 Child: Free pages should decrease after write\n");
 264:	50                   	push   %eax
 265:	50                   	push   %eax
 266:	68 e8 0a 00 00       	push   $0xae8
 26b:	6a 01                	push   $0x1
 26d:	e8 6e 04 00 00       	call   6e0 <printf>
            goto failed;
 272:	83 c4 10             	add    $0x10,%esp
 275:	e9 e7 fe ff ff       	jmp    161 <test+0x101>
        curr_free_pages = getNumFreePages();
 27a:	e8 9c 03 00 00       	call   61b <getNumFreePages>
        if (curr_free_pages >= prev_free_pages) {
 27f:	3b 45 d0             	cmp    -0x30(%ebp),%eax
 282:	73 e0                	jae    264 <test+0x204>
        processing(&x);
 284:	83 ec 0c             	sub    $0xc,%esp
 287:	8d 45 e4             	lea    -0x1c(%ebp),%eax
        int x = 0;
 28a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
        processing(&x);
 291:	50                   	push   %eax
 292:	e8 99 fd ff ff       	call   30 <processing>
 297:	83 c4 10             	add    $0x10,%esp
        printf(1, "[COW] Lab5 Child test passed!\n");
 29a:	50                   	push   %eax
 29b:	50                   	push   %eax
 29c:	68 1c 0b 00 00       	push   $0xb1c
 2a1:	6a 01                	push   $0x1
 2a3:	e8 38 04 00 00       	call   6e0 <printf>
 2a8:	83 c4 10             	add    $0x10,%esp
    exit();
 2ab:	e8 c3 02 00 00       	call   573 <exit>
        curr_free_pages = getNumFreePages();
 2b0:	e8 66 03 00 00       	call   61b <getNumFreePages>
        if (curr_free_pages >= prev_free_pages) {
 2b5:	39 45 d0             	cmp    %eax,-0x30(%ebp)
 2b8:	76 94                	jbe    24e <test+0x1ee>
        processing(&x);
 2ba:	83 ec 0c             	sub    $0xc,%esp
 2bd:	8d 45 e4             	lea    -0x1c(%ebp),%eax
        int x = 0;
 2c0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
        processing(&x);
 2c7:	50                   	push   %eax
 2c8:	89 45 cc             	mov    %eax,-0x34(%ebp)
 2cb:	e8 60 fd ff ff       	call   30 <processing>
 2d0:	83 c4 10             	add    $0x10,%esp
        wait();
 2d3:	e8 a3 02 00 00       	call   57b <wait>
        processing(&x);
 2d8:	83 ec 0c             	sub    $0xc,%esp
 2db:	ff 75 cc             	pushl  -0x34(%ebp)
 2de:	e8 4d fd ff ff       	call   30 <processing>
        printf(1, "done processing %d\n", x);
 2e3:	83 c4 0c             	add    $0xc,%esp
 2e6:	ff 75 e4             	pushl  -0x1c(%ebp)
 2e9:	68 48 0a 00 00       	push   $0xa48
 2ee:	6a 01                	push   $0x1
 2f0:	e8 eb 03 00 00       	call   6e0 <printf>
        printf(1, "[COW] Lab5 Parent test passed!\n");
 2f5:	5a                   	pop    %edx
 2f6:	59                   	pop    %ecx
 2f7:	68 74 0b 00 00       	push   $0xb74
 2fc:	6a 01                	push   $0x1
 2fe:	e8 dd 03 00 00       	call   6e0 <printf>
 303:	83 c4 10             	add    $0x10,%esp
 306:	eb a3                	jmp    2ab <test+0x24b>
 308:	66 90                	xchg   %ax,%ax
 30a:	66 90                	xchg   %ax,%ax
 30c:	66 90                	xchg   %ax,%ax
 30e:	66 90                	xchg   %ax,%ax

00000310 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 310:	f3 0f 1e fb          	endbr32 
 314:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 315:	31 c0                	xor    %eax,%eax
{
 317:	89 e5                	mov    %esp,%ebp
 319:	53                   	push   %ebx
 31a:	8b 4d 08             	mov    0x8(%ebp),%ecx
 31d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while((*s++ = *t++) != 0)
 320:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 324:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 327:	83 c0 01             	add    $0x1,%eax
 32a:	84 d2                	test   %dl,%dl
 32c:	75 f2                	jne    320 <strcpy+0x10>
    ;
  return os;
}
 32e:	89 c8                	mov    %ecx,%eax
 330:	5b                   	pop    %ebx
 331:	5d                   	pop    %ebp
 332:	c3                   	ret    
 333:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 33a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000340 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 340:	f3 0f 1e fb          	endbr32 
 344:	55                   	push   %ebp
 345:	89 e5                	mov    %esp,%ebp
 347:	53                   	push   %ebx
 348:	8b 4d 08             	mov    0x8(%ebp),%ecx
 34b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 34e:	0f b6 01             	movzbl (%ecx),%eax
 351:	0f b6 1a             	movzbl (%edx),%ebx
 354:	84 c0                	test   %al,%al
 356:	75 19                	jne    371 <strcmp+0x31>
 358:	eb 26                	jmp    380 <strcmp+0x40>
 35a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 360:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
 364:	83 c1 01             	add    $0x1,%ecx
 367:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 36a:	0f b6 1a             	movzbl (%edx),%ebx
 36d:	84 c0                	test   %al,%al
 36f:	74 0f                	je     380 <strcmp+0x40>
 371:	38 d8                	cmp    %bl,%al
 373:	74 eb                	je     360 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 375:	29 d8                	sub    %ebx,%eax
}
 377:	5b                   	pop    %ebx
 378:	5d                   	pop    %ebp
 379:	c3                   	ret    
 37a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 380:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 382:	29 d8                	sub    %ebx,%eax
}
 384:	5b                   	pop    %ebx
 385:	5d                   	pop    %ebp
 386:	c3                   	ret    
 387:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 38e:	66 90                	xchg   %ax,%ax

00000390 <strlen>:

uint
strlen(const char *s)
{
 390:	f3 0f 1e fb          	endbr32 
 394:	55                   	push   %ebp
 395:	89 e5                	mov    %esp,%ebp
 397:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 39a:	80 3a 00             	cmpb   $0x0,(%edx)
 39d:	74 21                	je     3c0 <strlen+0x30>
 39f:	31 c0                	xor    %eax,%eax
 3a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3a8:	83 c0 01             	add    $0x1,%eax
 3ab:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 3af:	89 c1                	mov    %eax,%ecx
 3b1:	75 f5                	jne    3a8 <strlen+0x18>
    ;
  return n;
}
 3b3:	89 c8                	mov    %ecx,%eax
 3b5:	5d                   	pop    %ebp
 3b6:	c3                   	ret    
 3b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3be:	66 90                	xchg   %ax,%ax
  for(n = 0; s[n]; n++)
 3c0:	31 c9                	xor    %ecx,%ecx
}
 3c2:	5d                   	pop    %ebp
 3c3:	89 c8                	mov    %ecx,%eax
 3c5:	c3                   	ret    
 3c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3cd:	8d 76 00             	lea    0x0(%esi),%esi

000003d0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 3d0:	f3 0f 1e fb          	endbr32 
 3d4:	55                   	push   %ebp
 3d5:	89 e5                	mov    %esp,%ebp
 3d7:	57                   	push   %edi
 3d8:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 3db:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3de:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e1:	89 d7                	mov    %edx,%edi
 3e3:	fc                   	cld    
 3e4:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 3e6:	89 d0                	mov    %edx,%eax
 3e8:	5f                   	pop    %edi
 3e9:	5d                   	pop    %ebp
 3ea:	c3                   	ret    
 3eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3ef:	90                   	nop

000003f0 <strchr>:

char*
strchr(const char *s, char c)
{
 3f0:	f3 0f 1e fb          	endbr32 
 3f4:	55                   	push   %ebp
 3f5:	89 e5                	mov    %esp,%ebp
 3f7:	8b 45 08             	mov    0x8(%ebp),%eax
 3fa:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 3fe:	0f b6 10             	movzbl (%eax),%edx
 401:	84 d2                	test   %dl,%dl
 403:	75 16                	jne    41b <strchr+0x2b>
 405:	eb 21                	jmp    428 <strchr+0x38>
 407:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 40e:	66 90                	xchg   %ax,%ax
 410:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 414:	83 c0 01             	add    $0x1,%eax
 417:	84 d2                	test   %dl,%dl
 419:	74 0d                	je     428 <strchr+0x38>
    if(*s == c)
 41b:	38 d1                	cmp    %dl,%cl
 41d:	75 f1                	jne    410 <strchr+0x20>
      return (char*)s;
  return 0;
}
 41f:	5d                   	pop    %ebp
 420:	c3                   	ret    
 421:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 428:	31 c0                	xor    %eax,%eax
}
 42a:	5d                   	pop    %ebp
 42b:	c3                   	ret    
 42c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000430 <gets>:

char*
gets(char *buf, int max)
{
 430:	f3 0f 1e fb          	endbr32 
 434:	55                   	push   %ebp
 435:	89 e5                	mov    %esp,%ebp
 437:	57                   	push   %edi
 438:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 439:	31 f6                	xor    %esi,%esi
{
 43b:	53                   	push   %ebx
 43c:	89 f3                	mov    %esi,%ebx
 43e:	83 ec 1c             	sub    $0x1c,%esp
 441:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 444:	eb 33                	jmp    479 <gets+0x49>
 446:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 44d:	8d 76 00             	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 450:	83 ec 04             	sub    $0x4,%esp
 453:	8d 45 e7             	lea    -0x19(%ebp),%eax
 456:	6a 01                	push   $0x1
 458:	50                   	push   %eax
 459:	6a 00                	push   $0x0
 45b:	e8 2b 01 00 00       	call   58b <read>
    if(cc < 1)
 460:	83 c4 10             	add    $0x10,%esp
 463:	85 c0                	test   %eax,%eax
 465:	7e 1c                	jle    483 <gets+0x53>
      break;
    buf[i++] = c;
 467:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 46b:	83 c7 01             	add    $0x1,%edi
 46e:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 471:	3c 0a                	cmp    $0xa,%al
 473:	74 23                	je     498 <gets+0x68>
 475:	3c 0d                	cmp    $0xd,%al
 477:	74 1f                	je     498 <gets+0x68>
  for(i=0; i+1 < max; ){
 479:	83 c3 01             	add    $0x1,%ebx
 47c:	89 fe                	mov    %edi,%esi
 47e:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 481:	7c cd                	jl     450 <gets+0x20>
 483:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 485:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 488:	c6 03 00             	movb   $0x0,(%ebx)
}
 48b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 48e:	5b                   	pop    %ebx
 48f:	5e                   	pop    %esi
 490:	5f                   	pop    %edi
 491:	5d                   	pop    %ebp
 492:	c3                   	ret    
 493:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 497:	90                   	nop
 498:	8b 75 08             	mov    0x8(%ebp),%esi
 49b:	8b 45 08             	mov    0x8(%ebp),%eax
 49e:	01 de                	add    %ebx,%esi
 4a0:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 4a2:	c6 03 00             	movb   $0x0,(%ebx)
}
 4a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4a8:	5b                   	pop    %ebx
 4a9:	5e                   	pop    %esi
 4aa:	5f                   	pop    %edi
 4ab:	5d                   	pop    %ebp
 4ac:	c3                   	ret    
 4ad:	8d 76 00             	lea    0x0(%esi),%esi

000004b0 <stat>:

int
stat(const char *n, struct stat *st)
{
 4b0:	f3 0f 1e fb          	endbr32 
 4b4:	55                   	push   %ebp
 4b5:	89 e5                	mov    %esp,%ebp
 4b7:	56                   	push   %esi
 4b8:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4b9:	83 ec 08             	sub    $0x8,%esp
 4bc:	6a 00                	push   $0x0
 4be:	ff 75 08             	pushl  0x8(%ebp)
 4c1:	e8 ed 00 00 00       	call   5b3 <open>
  if(fd < 0)
 4c6:	83 c4 10             	add    $0x10,%esp
 4c9:	85 c0                	test   %eax,%eax
 4cb:	78 2b                	js     4f8 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 4cd:	83 ec 08             	sub    $0x8,%esp
 4d0:	ff 75 0c             	pushl  0xc(%ebp)
 4d3:	89 c3                	mov    %eax,%ebx
 4d5:	50                   	push   %eax
 4d6:	e8 f0 00 00 00       	call   5cb <fstat>
  close(fd);
 4db:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 4de:	89 c6                	mov    %eax,%esi
  close(fd);
 4e0:	e8 b6 00 00 00       	call   59b <close>
  return r;
 4e5:	83 c4 10             	add    $0x10,%esp
}
 4e8:	8d 65 f8             	lea    -0x8(%ebp),%esp
 4eb:	89 f0                	mov    %esi,%eax
 4ed:	5b                   	pop    %ebx
 4ee:	5e                   	pop    %esi
 4ef:	5d                   	pop    %ebp
 4f0:	c3                   	ret    
 4f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
 4f8:	be ff ff ff ff       	mov    $0xffffffff,%esi
 4fd:	eb e9                	jmp    4e8 <stat+0x38>
 4ff:	90                   	nop

00000500 <atoi>:

int
atoi(const char *s)
{
 500:	f3 0f 1e fb          	endbr32 
 504:	55                   	push   %ebp
 505:	89 e5                	mov    %esp,%ebp
 507:	53                   	push   %ebx
 508:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 50b:	0f be 02             	movsbl (%edx),%eax
 50e:	8d 48 d0             	lea    -0x30(%eax),%ecx
 511:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 514:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 519:	77 1a                	ja     535 <atoi+0x35>
 51b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 51f:	90                   	nop
    n = n*10 + *s++ - '0';
 520:	83 c2 01             	add    $0x1,%edx
 523:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 526:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 52a:	0f be 02             	movsbl (%edx),%eax
 52d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 530:	80 fb 09             	cmp    $0x9,%bl
 533:	76 eb                	jbe    520 <atoi+0x20>
  return n;
}
 535:	89 c8                	mov    %ecx,%eax
 537:	5b                   	pop    %ebx
 538:	5d                   	pop    %ebp
 539:	c3                   	ret    
 53a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000540 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 540:	f3 0f 1e fb          	endbr32 
 544:	55                   	push   %ebp
 545:	89 e5                	mov    %esp,%ebp
 547:	57                   	push   %edi
 548:	8b 45 10             	mov    0x10(%ebp),%eax
 54b:	8b 55 08             	mov    0x8(%ebp),%edx
 54e:	56                   	push   %esi
 54f:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 552:	85 c0                	test   %eax,%eax
 554:	7e 0f                	jle    565 <memmove+0x25>
 556:	01 d0                	add    %edx,%eax
  dst = vdst;
 558:	89 d7                	mov    %edx,%edi
 55a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *dst++ = *src++;
 560:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 561:	39 f8                	cmp    %edi,%eax
 563:	75 fb                	jne    560 <memmove+0x20>
  return vdst;
}
 565:	5e                   	pop    %esi
 566:	89 d0                	mov    %edx,%eax
 568:	5f                   	pop    %edi
 569:	5d                   	pop    %ebp
 56a:	c3                   	ret    

0000056b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 56b:	b8 01 00 00 00       	mov    $0x1,%eax
 570:	cd 40                	int    $0x40
 572:	c3                   	ret    

00000573 <exit>:
SYSCALL(exit)
 573:	b8 02 00 00 00       	mov    $0x2,%eax
 578:	cd 40                	int    $0x40
 57a:	c3                   	ret    

0000057b <wait>:
SYSCALL(wait)
 57b:	b8 03 00 00 00       	mov    $0x3,%eax
 580:	cd 40                	int    $0x40
 582:	c3                   	ret    

00000583 <pipe>:
SYSCALL(pipe)
 583:	b8 04 00 00 00       	mov    $0x4,%eax
 588:	cd 40                	int    $0x40
 58a:	c3                   	ret    

0000058b <read>:
SYSCALL(read)
 58b:	b8 05 00 00 00       	mov    $0x5,%eax
 590:	cd 40                	int    $0x40
 592:	c3                   	ret    

00000593 <write>:
SYSCALL(write)
 593:	b8 10 00 00 00       	mov    $0x10,%eax
 598:	cd 40                	int    $0x40
 59a:	c3                   	ret    

0000059b <close>:
SYSCALL(close)
 59b:	b8 15 00 00 00       	mov    $0x15,%eax
 5a0:	cd 40                	int    $0x40
 5a2:	c3                   	ret    

000005a3 <kill>:
SYSCALL(kill)
 5a3:	b8 06 00 00 00       	mov    $0x6,%eax
 5a8:	cd 40                	int    $0x40
 5aa:	c3                   	ret    

000005ab <exec>:
SYSCALL(exec)
 5ab:	b8 07 00 00 00       	mov    $0x7,%eax
 5b0:	cd 40                	int    $0x40
 5b2:	c3                   	ret    

000005b3 <open>:
SYSCALL(open)
 5b3:	b8 0f 00 00 00       	mov    $0xf,%eax
 5b8:	cd 40                	int    $0x40
 5ba:	c3                   	ret    

000005bb <mknod>:
SYSCALL(mknod)
 5bb:	b8 11 00 00 00       	mov    $0x11,%eax
 5c0:	cd 40                	int    $0x40
 5c2:	c3                   	ret    

000005c3 <unlink>:
SYSCALL(unlink)
 5c3:	b8 12 00 00 00       	mov    $0x12,%eax
 5c8:	cd 40                	int    $0x40
 5ca:	c3                   	ret    

000005cb <fstat>:
SYSCALL(fstat)
 5cb:	b8 08 00 00 00       	mov    $0x8,%eax
 5d0:	cd 40                	int    $0x40
 5d2:	c3                   	ret    

000005d3 <link>:
SYSCALL(link)
 5d3:	b8 13 00 00 00       	mov    $0x13,%eax
 5d8:	cd 40                	int    $0x40
 5da:	c3                   	ret    

000005db <mkdir>:
SYSCALL(mkdir)
 5db:	b8 14 00 00 00       	mov    $0x14,%eax
 5e0:	cd 40                	int    $0x40
 5e2:	c3                   	ret    

000005e3 <chdir>:
SYSCALL(chdir)
 5e3:	b8 09 00 00 00       	mov    $0x9,%eax
 5e8:	cd 40                	int    $0x40
 5ea:	c3                   	ret    

000005eb <dup>:
SYSCALL(dup)
 5eb:	b8 0a 00 00 00       	mov    $0xa,%eax
 5f0:	cd 40                	int    $0x40
 5f2:	c3                   	ret    

000005f3 <getpid>:
SYSCALL(getpid)
 5f3:	b8 0b 00 00 00       	mov    $0xb,%eax
 5f8:	cd 40                	int    $0x40
 5fa:	c3                   	ret    

000005fb <sbrk>:
SYSCALL(sbrk)
 5fb:	b8 0c 00 00 00       	mov    $0xc,%eax
 600:	cd 40                	int    $0x40
 602:	c3                   	ret    

00000603 <sleep>:
SYSCALL(sleep)
 603:	b8 0d 00 00 00       	mov    $0xd,%eax
 608:	cd 40                	int    $0x40
 60a:	c3                   	ret    

0000060b <uptime>:
SYSCALL(uptime)
 60b:	b8 0e 00 00 00       	mov    $0xe,%eax
 610:	cd 40                	int    $0x40
 612:	c3                   	ret    

00000613 <getrss>:
SYSCALL(getrss)
 613:	b8 16 00 00 00       	mov    $0x16,%eax
 618:	cd 40                	int    $0x40
 61a:	c3                   	ret    

0000061b <getNumFreePages>:
 61b:	b8 17 00 00 00       	mov    $0x17,%eax
 620:	cd 40                	int    $0x40
 622:	c3                   	ret    
 623:	66 90                	xchg   %ax,%ax
 625:	66 90                	xchg   %ax,%ax
 627:	66 90                	xchg   %ax,%ax
 629:	66 90                	xchg   %ax,%ax
 62b:	66 90                	xchg   %ax,%ax
 62d:	66 90                	xchg   %ax,%ax
 62f:	90                   	nop

00000630 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 630:	55                   	push   %ebp
 631:	89 e5                	mov    %esp,%ebp
 633:	57                   	push   %edi
 634:	56                   	push   %esi
 635:	53                   	push   %ebx
 636:	83 ec 3c             	sub    $0x3c,%esp
 639:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 63c:	89 d1                	mov    %edx,%ecx
{
 63e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 641:	85 d2                	test   %edx,%edx
 643:	0f 89 7f 00 00 00    	jns    6c8 <printint+0x98>
 649:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 64d:	74 79                	je     6c8 <printint+0x98>
    neg = 1;
 64f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 656:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 658:	31 db                	xor    %ebx,%ebx
 65a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 65d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 660:	89 c8                	mov    %ecx,%eax
 662:	31 d2                	xor    %edx,%edx
 664:	89 cf                	mov    %ecx,%edi
 666:	f7 75 c4             	divl   -0x3c(%ebp)
 669:	0f b6 92 e0 0b 00 00 	movzbl 0xbe0(%edx),%edx
 670:	89 45 c0             	mov    %eax,-0x40(%ebp)
 673:	89 d8                	mov    %ebx,%eax
 675:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 678:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 67b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 67e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 681:	76 dd                	jbe    660 <printint+0x30>
  if(neg)
 683:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 686:	85 c9                	test   %ecx,%ecx
 688:	74 0c                	je     696 <printint+0x66>
    buf[i++] = '-';
 68a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 68f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 691:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 696:	8b 7d b8             	mov    -0x48(%ebp),%edi
 699:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 69d:	eb 07                	jmp    6a6 <printint+0x76>
 69f:	90                   	nop
 6a0:	0f b6 13             	movzbl (%ebx),%edx
 6a3:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 6a6:	83 ec 04             	sub    $0x4,%esp
 6a9:	88 55 d7             	mov    %dl,-0x29(%ebp)
 6ac:	6a 01                	push   $0x1
 6ae:	56                   	push   %esi
 6af:	57                   	push   %edi
 6b0:	e8 de fe ff ff       	call   593 <write>
  while(--i >= 0)
 6b5:	83 c4 10             	add    $0x10,%esp
 6b8:	39 de                	cmp    %ebx,%esi
 6ba:	75 e4                	jne    6a0 <printint+0x70>
    putc(fd, buf[i]);
}
 6bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6bf:	5b                   	pop    %ebx
 6c0:	5e                   	pop    %esi
 6c1:	5f                   	pop    %edi
 6c2:	5d                   	pop    %ebp
 6c3:	c3                   	ret    
 6c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 6c8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 6cf:	eb 87                	jmp    658 <printint+0x28>
 6d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6df:	90                   	nop

000006e0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 6e0:	f3 0f 1e fb          	endbr32 
 6e4:	55                   	push   %ebp
 6e5:	89 e5                	mov    %esp,%ebp
 6e7:	57                   	push   %edi
 6e8:	56                   	push   %esi
 6e9:	53                   	push   %ebx
 6ea:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6ed:	8b 75 0c             	mov    0xc(%ebp),%esi
 6f0:	0f b6 1e             	movzbl (%esi),%ebx
 6f3:	84 db                	test   %bl,%bl
 6f5:	0f 84 b4 00 00 00    	je     7af <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
 6fb:	8d 45 10             	lea    0x10(%ebp),%eax
 6fe:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 701:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 704:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 706:	89 45 d0             	mov    %eax,-0x30(%ebp)
 709:	eb 33                	jmp    73e <printf+0x5e>
 70b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 70f:	90                   	nop
 710:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 713:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 718:	83 f8 25             	cmp    $0x25,%eax
 71b:	74 17                	je     734 <printf+0x54>
  write(fd, &c, 1);
 71d:	83 ec 04             	sub    $0x4,%esp
 720:	88 5d e7             	mov    %bl,-0x19(%ebp)
 723:	6a 01                	push   $0x1
 725:	57                   	push   %edi
 726:	ff 75 08             	pushl  0x8(%ebp)
 729:	e8 65 fe ff ff       	call   593 <write>
 72e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 731:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 734:	0f b6 1e             	movzbl (%esi),%ebx
 737:	83 c6 01             	add    $0x1,%esi
 73a:	84 db                	test   %bl,%bl
 73c:	74 71                	je     7af <printf+0xcf>
    c = fmt[i] & 0xff;
 73e:	0f be cb             	movsbl %bl,%ecx
 741:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 744:	85 d2                	test   %edx,%edx
 746:	74 c8                	je     710 <printf+0x30>
      }
    } else if(state == '%'){
 748:	83 fa 25             	cmp    $0x25,%edx
 74b:	75 e7                	jne    734 <printf+0x54>
      if(c == 'd'){
 74d:	83 f8 64             	cmp    $0x64,%eax
 750:	0f 84 9a 00 00 00    	je     7f0 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 756:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 75c:	83 f9 70             	cmp    $0x70,%ecx
 75f:	74 5f                	je     7c0 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 761:	83 f8 73             	cmp    $0x73,%eax
 764:	0f 84 d6 00 00 00    	je     840 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 76a:	83 f8 63             	cmp    $0x63,%eax
 76d:	0f 84 8d 00 00 00    	je     800 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 773:	83 f8 25             	cmp    $0x25,%eax
 776:	0f 84 b4 00 00 00    	je     830 <printf+0x150>
  write(fd, &c, 1);
 77c:	83 ec 04             	sub    $0x4,%esp
 77f:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 783:	6a 01                	push   $0x1
 785:	57                   	push   %edi
 786:	ff 75 08             	pushl  0x8(%ebp)
 789:	e8 05 fe ff ff       	call   593 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 78e:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 791:	83 c4 0c             	add    $0xc,%esp
 794:	6a 01                	push   $0x1
 796:	83 c6 01             	add    $0x1,%esi
 799:	57                   	push   %edi
 79a:	ff 75 08             	pushl  0x8(%ebp)
 79d:	e8 f1 fd ff ff       	call   593 <write>
  for(i = 0; fmt[i]; i++){
 7a2:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 7a6:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 7a9:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 7ab:	84 db                	test   %bl,%bl
 7ad:	75 8f                	jne    73e <printf+0x5e>
    }
  }
}
 7af:	8d 65 f4             	lea    -0xc(%ebp),%esp
 7b2:	5b                   	pop    %ebx
 7b3:	5e                   	pop    %esi
 7b4:	5f                   	pop    %edi
 7b5:	5d                   	pop    %ebp
 7b6:	c3                   	ret    
 7b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7be:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 7c0:	83 ec 0c             	sub    $0xc,%esp
 7c3:	b9 10 00 00 00       	mov    $0x10,%ecx
 7c8:	6a 00                	push   $0x0
 7ca:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 7cd:	8b 45 08             	mov    0x8(%ebp),%eax
 7d0:	8b 13                	mov    (%ebx),%edx
 7d2:	e8 59 fe ff ff       	call   630 <printint>
        ap++;
 7d7:	89 d8                	mov    %ebx,%eax
 7d9:	83 c4 10             	add    $0x10,%esp
      state = 0;
 7dc:	31 d2                	xor    %edx,%edx
        ap++;
 7de:	83 c0 04             	add    $0x4,%eax
 7e1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 7e4:	e9 4b ff ff ff       	jmp    734 <printf+0x54>
 7e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 7f0:	83 ec 0c             	sub    $0xc,%esp
 7f3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 7f8:	6a 01                	push   $0x1
 7fa:	eb ce                	jmp    7ca <printf+0xea>
 7fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 800:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 803:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 806:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 808:	6a 01                	push   $0x1
        ap++;
 80a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 80d:	57                   	push   %edi
 80e:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 811:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 814:	e8 7a fd ff ff       	call   593 <write>
        ap++;
 819:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 81c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 81f:	31 d2                	xor    %edx,%edx
 821:	e9 0e ff ff ff       	jmp    734 <printf+0x54>
 826:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 82d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 830:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 833:	83 ec 04             	sub    $0x4,%esp
 836:	e9 59 ff ff ff       	jmp    794 <printf+0xb4>
 83b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 83f:	90                   	nop
        s = (char*)*ap;
 840:	8b 45 d0             	mov    -0x30(%ebp),%eax
 843:	8b 18                	mov    (%eax),%ebx
        ap++;
 845:	83 c0 04             	add    $0x4,%eax
 848:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 84b:	85 db                	test   %ebx,%ebx
 84d:	74 17                	je     866 <printf+0x186>
        while(*s != 0){
 84f:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 852:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 854:	84 c0                	test   %al,%al
 856:	0f 84 d8 fe ff ff    	je     734 <printf+0x54>
 85c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 85f:	89 de                	mov    %ebx,%esi
 861:	8b 5d 08             	mov    0x8(%ebp),%ebx
 864:	eb 1a                	jmp    880 <printf+0x1a0>
          s = "(null)";
 866:	bb d8 0b 00 00       	mov    $0xbd8,%ebx
        while(*s != 0){
 86b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 86e:	b8 28 00 00 00       	mov    $0x28,%eax
 873:	89 de                	mov    %ebx,%esi
 875:	8b 5d 08             	mov    0x8(%ebp),%ebx
 878:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 87f:	90                   	nop
  write(fd, &c, 1);
 880:	83 ec 04             	sub    $0x4,%esp
          s++;
 883:	83 c6 01             	add    $0x1,%esi
 886:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 889:	6a 01                	push   $0x1
 88b:	57                   	push   %edi
 88c:	53                   	push   %ebx
 88d:	e8 01 fd ff ff       	call   593 <write>
        while(*s != 0){
 892:	0f b6 06             	movzbl (%esi),%eax
 895:	83 c4 10             	add    $0x10,%esp
 898:	84 c0                	test   %al,%al
 89a:	75 e4                	jne    880 <printf+0x1a0>
 89c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 89f:	31 d2                	xor    %edx,%edx
 8a1:	e9 8e fe ff ff       	jmp    734 <printf+0x54>
 8a6:	66 90                	xchg   %ax,%ax
 8a8:	66 90                	xchg   %ax,%ax
 8aa:	66 90                	xchg   %ax,%ax
 8ac:	66 90                	xchg   %ax,%ax
 8ae:	66 90                	xchg   %ax,%ax

000008b0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8b0:	f3 0f 1e fb          	endbr32 
 8b4:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8b5:	a1 c8 0e 00 00       	mov    0xec8,%eax
{
 8ba:	89 e5                	mov    %esp,%ebp
 8bc:	57                   	push   %edi
 8bd:	56                   	push   %esi
 8be:	53                   	push   %ebx
 8bf:	8b 5d 08             	mov    0x8(%ebp),%ebx
 8c2:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 8c4:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8c7:	39 c8                	cmp    %ecx,%eax
 8c9:	73 15                	jae    8e0 <free+0x30>
 8cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 8cf:	90                   	nop
 8d0:	39 d1                	cmp    %edx,%ecx
 8d2:	72 14                	jb     8e8 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8d4:	39 d0                	cmp    %edx,%eax
 8d6:	73 10                	jae    8e8 <free+0x38>
{
 8d8:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8da:	8b 10                	mov    (%eax),%edx
 8dc:	39 c8                	cmp    %ecx,%eax
 8de:	72 f0                	jb     8d0 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8e0:	39 d0                	cmp    %edx,%eax
 8e2:	72 f4                	jb     8d8 <free+0x28>
 8e4:	39 d1                	cmp    %edx,%ecx
 8e6:	73 f0                	jae    8d8 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 8e8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 8eb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 8ee:	39 fa                	cmp    %edi,%edx
 8f0:	74 1e                	je     910 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 8f2:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 8f5:	8b 50 04             	mov    0x4(%eax),%edx
 8f8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 8fb:	39 f1                	cmp    %esi,%ecx
 8fd:	74 28                	je     927 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 8ff:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 901:	5b                   	pop    %ebx
  freep = p;
 902:	a3 c8 0e 00 00       	mov    %eax,0xec8
}
 907:	5e                   	pop    %esi
 908:	5f                   	pop    %edi
 909:	5d                   	pop    %ebp
 90a:	c3                   	ret    
 90b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 90f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 910:	03 72 04             	add    0x4(%edx),%esi
 913:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 916:	8b 10                	mov    (%eax),%edx
 918:	8b 12                	mov    (%edx),%edx
 91a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 91d:	8b 50 04             	mov    0x4(%eax),%edx
 920:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 923:	39 f1                	cmp    %esi,%ecx
 925:	75 d8                	jne    8ff <free+0x4f>
    p->s.size += bp->s.size;
 927:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 92a:	a3 c8 0e 00 00       	mov    %eax,0xec8
    p->s.size += bp->s.size;
 92f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 932:	8b 53 f8             	mov    -0x8(%ebx),%edx
 935:	89 10                	mov    %edx,(%eax)
}
 937:	5b                   	pop    %ebx
 938:	5e                   	pop    %esi
 939:	5f                   	pop    %edi
 93a:	5d                   	pop    %ebp
 93b:	c3                   	ret    
 93c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000940 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 940:	f3 0f 1e fb          	endbr32 
 944:	55                   	push   %ebp
 945:	89 e5                	mov    %esp,%ebp
 947:	57                   	push   %edi
 948:	56                   	push   %esi
 949:	53                   	push   %ebx
 94a:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 94d:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 950:	8b 3d c8 0e 00 00    	mov    0xec8,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 956:	8d 70 07             	lea    0x7(%eax),%esi
 959:	c1 ee 03             	shr    $0x3,%esi
 95c:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 95f:	85 ff                	test   %edi,%edi
 961:	0f 84 a9 00 00 00    	je     a10 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 967:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 969:	8b 48 04             	mov    0x4(%eax),%ecx
 96c:	39 f1                	cmp    %esi,%ecx
 96e:	73 6d                	jae    9dd <malloc+0x9d>
 970:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 976:	bb 00 10 00 00       	mov    $0x1000,%ebx
 97b:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 97e:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 985:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 988:	eb 17                	jmp    9a1 <malloc+0x61>
 98a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 990:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 992:	8b 4a 04             	mov    0x4(%edx),%ecx
 995:	39 f1                	cmp    %esi,%ecx
 997:	73 4f                	jae    9e8 <malloc+0xa8>
 999:	8b 3d c8 0e 00 00    	mov    0xec8,%edi
 99f:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9a1:	39 c7                	cmp    %eax,%edi
 9a3:	75 eb                	jne    990 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 9a5:	83 ec 0c             	sub    $0xc,%esp
 9a8:	ff 75 e4             	pushl  -0x1c(%ebp)
 9ab:	e8 4b fc ff ff       	call   5fb <sbrk>
  if(p == (char*)-1)
 9b0:	83 c4 10             	add    $0x10,%esp
 9b3:	83 f8 ff             	cmp    $0xffffffff,%eax
 9b6:	74 1b                	je     9d3 <malloc+0x93>
  hp->s.size = nu;
 9b8:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 9bb:	83 ec 0c             	sub    $0xc,%esp
 9be:	83 c0 08             	add    $0x8,%eax
 9c1:	50                   	push   %eax
 9c2:	e8 e9 fe ff ff       	call   8b0 <free>
  return freep;
 9c7:	a1 c8 0e 00 00       	mov    0xec8,%eax
      if((p = morecore(nunits)) == 0)
 9cc:	83 c4 10             	add    $0x10,%esp
 9cf:	85 c0                	test   %eax,%eax
 9d1:	75 bd                	jne    990 <malloc+0x50>
        return 0;
  }
}
 9d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 9d6:	31 c0                	xor    %eax,%eax
}
 9d8:	5b                   	pop    %ebx
 9d9:	5e                   	pop    %esi
 9da:	5f                   	pop    %edi
 9db:	5d                   	pop    %ebp
 9dc:	c3                   	ret    
    if(p->s.size >= nunits){
 9dd:	89 c2                	mov    %eax,%edx
 9df:	89 f8                	mov    %edi,%eax
 9e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 9e8:	39 ce                	cmp    %ecx,%esi
 9ea:	74 54                	je     a40 <malloc+0x100>
        p->s.size -= nunits;
 9ec:	29 f1                	sub    %esi,%ecx
 9ee:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 9f1:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 9f4:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 9f7:	a3 c8 0e 00 00       	mov    %eax,0xec8
}
 9fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 9ff:	8d 42 08             	lea    0x8(%edx),%eax
}
 a02:	5b                   	pop    %ebx
 a03:	5e                   	pop    %esi
 a04:	5f                   	pop    %edi
 a05:	5d                   	pop    %ebp
 a06:	c3                   	ret    
 a07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 a0e:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 a10:	c7 05 c8 0e 00 00 cc 	movl   $0xecc,0xec8
 a17:	0e 00 00 
    base.s.size = 0;
 a1a:	bf cc 0e 00 00       	mov    $0xecc,%edi
    base.s.ptr = freep = prevp = &base;
 a1f:	c7 05 cc 0e 00 00 cc 	movl   $0xecc,0xecc
 a26:	0e 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a29:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
 a2b:	c7 05 d0 0e 00 00 00 	movl   $0x0,0xed0
 a32:	00 00 00 
    if(p->s.size >= nunits){
 a35:	e9 36 ff ff ff       	jmp    970 <malloc+0x30>
 a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 a40:	8b 0a                	mov    (%edx),%ecx
 a42:	89 08                	mov    %ecx,(%eax)
 a44:	eb b1                	jmp    9f7 <malloc+0xb7>
