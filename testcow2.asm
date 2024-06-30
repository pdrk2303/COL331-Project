
_testcow2:     file format elf32-i386


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
  15:	68 74 0a 00 00       	push   $0xa74
  1a:	6a 01                	push   $0x1
  1c:	e8 5f 06 00 00       	call   680 <printf>
	test();
  21:	e8 2a 00 00 00       	call   50 <test>
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
  37:	8b 45 08             	mov    0x8(%ebp),%eax
  3a:	c7 00 ae ad 01 00    	movl   $0x1adae,(%eax)
}
  40:	5d                   	pop    %ebp
  41:	c3                   	ret    
  42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000050 <test>:
{
  50:	f3 0f 1e fb          	endbr32 
  54:	55                   	push   %ebp
  55:	89 e5                	mov    %esp,%ebp
  57:	57                   	push   %edi
  58:	56                   	push   %esi
  59:	53                   	push   %ebx
  5a:	83 ec 1c             	sub    $0x1c,%esp
    uint prev_free_pages = getNumFreePages();
  5d:	e8 59 05 00 00       	call   5bb <getNumFreePages>
    long long size = ((prev_free_pages - 20) * 4 * 1024) / 3; // 20 pages will be used by kernel to create kstack, and process related datastructures.
  62:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
    char *m1 = (char*)malloc(size);
  67:	83 ec 0c             	sub    $0xc,%esp
    long long size = ((prev_free_pages - 20) * 4 * 1024) / 3; // 20 pages will be used by kernel to create kstack, and process related datastructures.
  6a:	8d 58 ec             	lea    -0x14(%eax),%ebx
  6d:	c1 e3 0c             	shl    $0xc,%ebx
  70:	89 d8                	mov    %ebx,%eax
  72:	f7 e2                	mul    %edx
  74:	d1 ea                	shr    %edx
    char *m1 = (char*)malloc(size);
  76:	52                   	push   %edx
    long long size = ((prev_free_pages - 20) * 4 * 1024) / 3; // 20 pages will be used by kernel to create kstack, and process related datastructures.
  77:	89 d6                	mov    %edx,%esi
    char *m1 = (char*)malloc(size);
  79:	e8 62 08 00 00       	call   8e0 <malloc>
    if (m1 == 0) goto out_of_memory;
  7e:	83 c4 10             	add    $0x10,%esp
    char *m1 = (char*)malloc(size);
  81:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if (m1 == 0) goto out_of_memory;
  84:	85 c0                	test   %eax,%eax
  86:	0f 84 c1 01 00 00    	je     24d <test+0x1fd>
    printf(1, "\n*** Forking ***\n");
  8c:	83 ec 08             	sub    $0x8,%esp
  8f:	68 12 0a 00 00       	push   $0xa12
  94:	6a 01                	push   $0x1
  96:	e8 e5 05 00 00       	call   680 <printf>
    pid = fork();
  9b:	e8 6b 04 00 00       	call   50b <fork>
    if (pid < 0) goto fork_failed; // Fork failed
  a0:	83 c4 10             	add    $0x10,%esp
    pid = fork();
  a3:	89 c7                	mov    %eax,%edi
    if (pid < 0) goto fork_failed; // Fork failed
  a5:	85 c0                	test   %eax,%eax
  a7:	0f 88 df 01 00 00    	js     28c <test+0x23c>
    if (pid == 0) { // Child process
  ad:	0f 85 c2 00 00 00    	jne    175 <test+0x125>
        printf(1, "\n*** Child ***\n");
  b3:	50                   	push   %eax
  b4:	50                   	push   %eax
  b5:	68 3f 0a 00 00       	push   $0xa3f
  ba:	6a 01                	push   $0x1
  bc:	e8 bf 05 00 00       	call   680 <printf>
        prev_free_pages = getNumFreePages();
  c1:	e8 f5 04 00 00       	call   5bb <getNumFreePages>
        for (int i=0; i<size; i++) {
  c6:	83 c4 10             	add    $0x10,%esp
        prev_free_pages = getNumFreePages();
  c9:	89 45 d8             	mov    %eax,-0x28(%ebp)
        for (int i=0; i<size; i++) {
  cc:	83 fb 02             	cmp    $0x2,%ebx
  cf:	0f 86 84 01 00 00    	jbe    259 <test+0x209>
            m1[i] = (char)(65+(i%26));
  d5:	bb 4f ec c4 4e       	mov    $0x4ec4ec4f,%ebx
  da:	89 f8                	mov    %edi,%eax
  dc:	89 f9                	mov    %edi,%ecx
  de:	f7 e3                	mul    %ebx
  e0:	89 d0                	mov    %edx,%eax
  e2:	c1 e8 03             	shr    $0x3,%eax
  e5:	6b c0 1a             	imul   $0x1a,%eax,%eax
  e8:	29 c1                	sub    %eax,%ecx
  ea:	89 c8                	mov    %ecx,%eax
  ec:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  ef:	83 c0 41             	add    $0x41,%eax
  f2:	88 04 39             	mov    %al,(%ecx,%edi,1)
        for (int i=0; i<size; i++) {
  f5:	83 c7 01             	add    $0x1,%edi
  f8:	39 f7                	cmp    %esi,%edi
  fa:	75 de                	jne    da <test+0x8a>
        curr_free_pages = getNumFreePages();
  fc:	e8 ba 04 00 00       	call   5bb <getNumFreePages>
        if (curr_free_pages >= prev_free_pages) {
 101:	39 45 d8             	cmp    %eax,-0x28(%ebp)
 104:	0f 86 8e 01 00 00    	jbe    298 <test+0x248>
 10a:	89 7d d8             	mov    %edi,-0x28(%ebp)
 10d:	31 c9                	xor    %ecx,%ecx
 10f:	31 db                	xor    %ebx,%ebx
			if(m1[k] != (char)(65+(k%26))) goto failed;
 111:	bf 4f ec c4 4e       	mov    $0x4ec4ec4f,%edi
 116:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
 11d:	eb 18                	jmp    137 <test+0xe7>
        for(int k=0;k<size;++k){
 11f:	83 c1 01             	add    $0x1,%ecx
 122:	8b 45 d8             	mov    -0x28(%ebp),%eax
 125:	8b 55 dc             	mov    -0x24(%ebp),%edx
 128:	83 d3 00             	adc    $0x0,%ebx
 12b:	31 da                	xor    %ebx,%edx
 12d:	31 c8                	xor    %ecx,%eax
 12f:	09 c2                	or     %eax,%edx
 131:	0f 84 2c 01 00 00    	je     263 <test+0x213>
			if(m1[k] != (char)(65+(k%26))) goto failed;
 137:	89 c8                	mov    %ecx,%eax
 139:	f7 e7                	mul    %edi
 13b:	89 d0                	mov    %edx,%eax
 13d:	89 ca                	mov    %ecx,%edx
 13f:	c1 e8 03             	shr    $0x3,%eax
 142:	6b c0 1a             	imul   $0x1a,%eax,%eax
 145:	29 c2                	sub    %eax,%edx
 147:	89 d0                	mov    %edx,%eax
 149:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 14c:	83 c0 41             	add    $0x41,%eax
 14f:	38 04 0a             	cmp    %al,(%edx,%ecx,1)
 152:	74 cb                	je     11f <test+0xcf>
    printf(1, "Copy failed: The memory contents of the processes is inconsistent!\n");
 154:	50                   	push   %eax
 155:	50                   	push   %eax
 156:	68 34 0b 00 00       	push   $0xb34
	printf(1, "Failed to fork a process!\n");
 15b:	6a 01                	push   $0x1
 15d:	e8 1e 05 00 00       	call   680 <printf>
    printf(1, "Lab5 test failed!\n");
 162:	58                   	pop    %eax
 163:	5a                   	pop    %edx
 164:	68 ff 09 00 00       	push   $0x9ff
 169:	6a 01                	push   $0x1
 16b:	e8 10 05 00 00       	call   680 <printf>
	exit();
 170:	e8 9e 03 00 00       	call   513 <exit>
        printf(1, "\n*** Parent ***\n");
 175:	57                   	push   %edi
 176:	57                   	push   %edi
 177:	68 4f 0a 00 00       	push   $0xa4f
 17c:	6a 01                	push   $0x1
 17e:	e8 fd 04 00 00       	call   680 <printf>
        prev_free_pages = getNumFreePages();
 183:	e8 33 04 00 00       	call   5bb <getNumFreePages>
        for (int i=0; i<size; i++) {
 188:	83 c4 10             	add    $0x10,%esp
        prev_free_pages = getNumFreePages();
 18b:	89 c7                	mov    %eax,%edi
        for (int i=0; i<size; i++) {
 18d:	83 fb 02             	cmp    $0x2,%ebx
 190:	0f 86 81 00 00 00    	jbe    217 <test+0x1c7>
 196:	31 db                	xor    %ebx,%ebx
            m1[i] = (char)(97+(i%26));
 198:	b9 4f ec c4 4e       	mov    $0x4ec4ec4f,%ecx
 19d:	89 d8                	mov    %ebx,%eax
 19f:	f7 e1                	mul    %ecx
 1a1:	89 d0                	mov    %edx,%eax
 1a3:	89 da                	mov    %ebx,%edx
 1a5:	c1 e8 03             	shr    $0x3,%eax
 1a8:	6b c0 1a             	imul   $0x1a,%eax,%eax
 1ab:	29 c2                	sub    %eax,%edx
 1ad:	89 d0                	mov    %edx,%eax
 1af:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 1b2:	83 c0 61             	add    $0x61,%eax
 1b5:	88 04 1a             	mov    %al,(%edx,%ebx,1)
        for (int i=0; i<size; i++) {
 1b8:	83 c3 01             	add    $0x1,%ebx
 1bb:	39 f3                	cmp    %esi,%ebx
 1bd:	75 de                	jne    19d <test+0x14d>
        curr_free_pages = getNumFreePages();
 1bf:	e8 f7 03 00 00       	call   5bb <getNumFreePages>
        if (curr_free_pages >= prev_free_pages) {
 1c4:	39 f8                	cmp    %edi,%eax
 1c6:	0f 83 aa 00 00 00    	jae    276 <test+0x226>
        for(int k=0;k<size;++k){
 1cc:	89 5d d8             	mov    %ebx,-0x28(%ebp)
        if (curr_free_pages >= prev_free_pages) {
 1cf:	31 c9                	xor    %ecx,%ecx
 1d1:	31 db                	xor    %ebx,%ebx
			if(m1[k] != (char)(97+(k%26))) goto failed;
 1d3:	bf 4f ec c4 4e       	mov    $0x4ec4ec4f,%edi
 1d8:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
 1df:	eb 14                	jmp    1f5 <test+0x1a5>
        for(int k=0;k<size;++k){
 1e1:	83 c1 01             	add    $0x1,%ecx
 1e4:	8b 45 d8             	mov    -0x28(%ebp),%eax
 1e7:	8b 55 dc             	mov    -0x24(%ebp),%edx
 1ea:	83 d3 00             	adc    $0x0,%ebx
 1ed:	31 da                	xor    %ebx,%edx
 1ef:	31 c8                	xor    %ecx,%eax
 1f1:	09 c2                	or     %eax,%edx
 1f3:	74 2b                	je     220 <test+0x1d0>
			if(m1[k] != (char)(97+(k%26))) goto failed;
 1f5:	89 c8                	mov    %ecx,%eax
 1f7:	f7 e7                	mul    %edi
 1f9:	89 d0                	mov    %edx,%eax
 1fb:	89 ca                	mov    %ecx,%edx
 1fd:	c1 e8 03             	shr    $0x3,%eax
 200:	6b c0 1a             	imul   $0x1a,%eax,%eax
 203:	29 c2                	sub    %eax,%edx
 205:	89 d0                	mov    %edx,%eax
 207:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 20a:	83 c0 61             	add    $0x61,%eax
 20d:	38 04 0a             	cmp    %al,(%edx,%ecx,1)
 210:	74 cf                	je     1e1 <test+0x191>
 212:	e9 3d ff ff ff       	jmp    154 <test+0x104>
        curr_free_pages = getNumFreePages();
 217:	e8 9f 03 00 00       	call   5bb <getNumFreePages>
        if (curr_free_pages >= prev_free_pages) {
 21c:	39 f8                	cmp    %edi,%eax
 21e:	73 56                	jae    276 <test+0x226>
        wait();
 220:	e8 f6 02 00 00       	call   51b <wait>
        printf(1, "done processing %d\n", x);
 225:	52                   	push   %edx
 226:	68 ae ad 01 00       	push   $0x1adae
 22b:	68 60 0a 00 00       	push   $0xa60
 230:	6a 01                	push   $0x1
 232:	e8 49 04 00 00       	call   680 <printf>
        printf(1, "[COW] Lab5 Parent test passed!\n");
 237:	59                   	pop    %ecx
 238:	5b                   	pop    %ebx
 239:	68 14 0b 00 00       	push   $0xb14
 23e:	6a 01                	push   $0x1
 240:	e8 3b 04 00 00       	call   680 <printf>
 245:	83 c4 10             	add    $0x10,%esp
    exit();
 248:	e8 c6 02 00 00       	call   513 <exit>
	printf(1, "Exceeded the PHYSTOP!\n");
 24d:	53                   	push   %ebx
 24e:	53                   	push   %ebx
 24f:	68 e8 09 00 00       	push   $0x9e8
 254:	e9 02 ff ff ff       	jmp    15b <test+0x10b>
        curr_free_pages = getNumFreePages();
 259:	e8 5d 03 00 00       	call   5bb <getNumFreePages>
        if (curr_free_pages >= prev_free_pages) {
 25e:	39 45 d8             	cmp    %eax,-0x28(%ebp)
 261:	76 35                	jbe    298 <test+0x248>
        printf(1, "[COW] Lab5 Child test passed!\n");
 263:	50                   	push   %eax
 264:	50                   	push   %eax
 265:	68 bc 0a 00 00       	push   $0xabc
 26a:	6a 01                	push   $0x1
 26c:	e8 0f 04 00 00       	call   680 <printf>
 271:	83 c4 10             	add    $0x10,%esp
 274:	eb d2                	jmp    248 <test+0x1f8>
            printf(1, "Lab5 Parent: Free pages should decrease after write\n");
 276:	56                   	push   %esi
 277:	56                   	push   %esi
 278:	68 dc 0a 00 00       	push   $0xadc
 27d:	6a 01                	push   $0x1
 27f:	e8 fc 03 00 00       	call   680 <printf>
            goto failed;
 284:	83 c4 10             	add    $0x10,%esp
 287:	e9 c8 fe ff ff       	jmp    154 <test+0x104>
	printf(1, "Failed to fork a process!\n");
 28c:	51                   	push   %ecx
 28d:	51                   	push   %ecx
 28e:	68 24 0a 00 00       	push   $0xa24
 293:	e9 c3 fe ff ff       	jmp    15b <test+0x10b>
            printf(1, "Lab5 Child: Free pages should decrease after write\n");
 298:	50                   	push   %eax
 299:	50                   	push   %eax
 29a:	68 88 0a 00 00       	push   $0xa88
 29f:	6a 01                	push   $0x1
 2a1:	e8 da 03 00 00       	call   680 <printf>
            goto failed;
 2a6:	83 c4 10             	add    $0x10,%esp
 2a9:	e9 a6 fe ff ff       	jmp    154 <test+0x104>
 2ae:	66 90                	xchg   %ax,%ax

000002b0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 2b0:	f3 0f 1e fb          	endbr32 
 2b4:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2b5:	31 c0                	xor    %eax,%eax
{
 2b7:	89 e5                	mov    %esp,%ebp
 2b9:	53                   	push   %ebx
 2ba:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2bd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while((*s++ = *t++) != 0)
 2c0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 2c4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 2c7:	83 c0 01             	add    $0x1,%eax
 2ca:	84 d2                	test   %dl,%dl
 2cc:	75 f2                	jne    2c0 <strcpy+0x10>
    ;
  return os;
}
 2ce:	89 c8                	mov    %ecx,%eax
 2d0:	5b                   	pop    %ebx
 2d1:	5d                   	pop    %ebp
 2d2:	c3                   	ret    
 2d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000002e0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2e0:	f3 0f 1e fb          	endbr32 
 2e4:	55                   	push   %ebp
 2e5:	89 e5                	mov    %esp,%ebp
 2e7:	53                   	push   %ebx
 2e8:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 2ee:	0f b6 01             	movzbl (%ecx),%eax
 2f1:	0f b6 1a             	movzbl (%edx),%ebx
 2f4:	84 c0                	test   %al,%al
 2f6:	75 19                	jne    311 <strcmp+0x31>
 2f8:	eb 26                	jmp    320 <strcmp+0x40>
 2fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 300:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
 304:	83 c1 01             	add    $0x1,%ecx
 307:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 30a:	0f b6 1a             	movzbl (%edx),%ebx
 30d:	84 c0                	test   %al,%al
 30f:	74 0f                	je     320 <strcmp+0x40>
 311:	38 d8                	cmp    %bl,%al
 313:	74 eb                	je     300 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 315:	29 d8                	sub    %ebx,%eax
}
 317:	5b                   	pop    %ebx
 318:	5d                   	pop    %ebp
 319:	c3                   	ret    
 31a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 320:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 322:	29 d8                	sub    %ebx,%eax
}
 324:	5b                   	pop    %ebx
 325:	5d                   	pop    %ebp
 326:	c3                   	ret    
 327:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 32e:	66 90                	xchg   %ax,%ax

00000330 <strlen>:

uint
strlen(const char *s)
{
 330:	f3 0f 1e fb          	endbr32 
 334:	55                   	push   %ebp
 335:	89 e5                	mov    %esp,%ebp
 337:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 33a:	80 3a 00             	cmpb   $0x0,(%edx)
 33d:	74 21                	je     360 <strlen+0x30>
 33f:	31 c0                	xor    %eax,%eax
 341:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 348:	83 c0 01             	add    $0x1,%eax
 34b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 34f:	89 c1                	mov    %eax,%ecx
 351:	75 f5                	jne    348 <strlen+0x18>
    ;
  return n;
}
 353:	89 c8                	mov    %ecx,%eax
 355:	5d                   	pop    %ebp
 356:	c3                   	ret    
 357:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 35e:	66 90                	xchg   %ax,%ax
  for(n = 0; s[n]; n++)
 360:	31 c9                	xor    %ecx,%ecx
}
 362:	5d                   	pop    %ebp
 363:	89 c8                	mov    %ecx,%eax
 365:	c3                   	ret    
 366:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 36d:	8d 76 00             	lea    0x0(%esi),%esi

00000370 <memset>:

void*
memset(void *dst, int c, uint n)
{
 370:	f3 0f 1e fb          	endbr32 
 374:	55                   	push   %ebp
 375:	89 e5                	mov    %esp,%ebp
 377:	57                   	push   %edi
 378:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 37b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 37e:	8b 45 0c             	mov    0xc(%ebp),%eax
 381:	89 d7                	mov    %edx,%edi
 383:	fc                   	cld    
 384:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 386:	89 d0                	mov    %edx,%eax
 388:	5f                   	pop    %edi
 389:	5d                   	pop    %ebp
 38a:	c3                   	ret    
 38b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 38f:	90                   	nop

00000390 <strchr>:

char*
strchr(const char *s, char c)
{
 390:	f3 0f 1e fb          	endbr32 
 394:	55                   	push   %ebp
 395:	89 e5                	mov    %esp,%ebp
 397:	8b 45 08             	mov    0x8(%ebp),%eax
 39a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 39e:	0f b6 10             	movzbl (%eax),%edx
 3a1:	84 d2                	test   %dl,%dl
 3a3:	75 16                	jne    3bb <strchr+0x2b>
 3a5:	eb 21                	jmp    3c8 <strchr+0x38>
 3a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3ae:	66 90                	xchg   %ax,%ax
 3b0:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 3b4:	83 c0 01             	add    $0x1,%eax
 3b7:	84 d2                	test   %dl,%dl
 3b9:	74 0d                	je     3c8 <strchr+0x38>
    if(*s == c)
 3bb:	38 d1                	cmp    %dl,%cl
 3bd:	75 f1                	jne    3b0 <strchr+0x20>
      return (char*)s;
  return 0;
}
 3bf:	5d                   	pop    %ebp
 3c0:	c3                   	ret    
 3c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 3c8:	31 c0                	xor    %eax,%eax
}
 3ca:	5d                   	pop    %ebp
 3cb:	c3                   	ret    
 3cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000003d0 <gets>:

char*
gets(char *buf, int max)
{
 3d0:	f3 0f 1e fb          	endbr32 
 3d4:	55                   	push   %ebp
 3d5:	89 e5                	mov    %esp,%ebp
 3d7:	57                   	push   %edi
 3d8:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3d9:	31 f6                	xor    %esi,%esi
{
 3db:	53                   	push   %ebx
 3dc:	89 f3                	mov    %esi,%ebx
 3de:	83 ec 1c             	sub    $0x1c,%esp
 3e1:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 3e4:	eb 33                	jmp    419 <gets+0x49>
 3e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3ed:	8d 76 00             	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 3f0:	83 ec 04             	sub    $0x4,%esp
 3f3:	8d 45 e7             	lea    -0x19(%ebp),%eax
 3f6:	6a 01                	push   $0x1
 3f8:	50                   	push   %eax
 3f9:	6a 00                	push   $0x0
 3fb:	e8 2b 01 00 00       	call   52b <read>
    if(cc < 1)
 400:	83 c4 10             	add    $0x10,%esp
 403:	85 c0                	test   %eax,%eax
 405:	7e 1c                	jle    423 <gets+0x53>
      break;
    buf[i++] = c;
 407:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 40b:	83 c7 01             	add    $0x1,%edi
 40e:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 411:	3c 0a                	cmp    $0xa,%al
 413:	74 23                	je     438 <gets+0x68>
 415:	3c 0d                	cmp    $0xd,%al
 417:	74 1f                	je     438 <gets+0x68>
  for(i=0; i+1 < max; ){
 419:	83 c3 01             	add    $0x1,%ebx
 41c:	89 fe                	mov    %edi,%esi
 41e:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 421:	7c cd                	jl     3f0 <gets+0x20>
 423:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 425:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 428:	c6 03 00             	movb   $0x0,(%ebx)
}
 42b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 42e:	5b                   	pop    %ebx
 42f:	5e                   	pop    %esi
 430:	5f                   	pop    %edi
 431:	5d                   	pop    %ebp
 432:	c3                   	ret    
 433:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 437:	90                   	nop
 438:	8b 75 08             	mov    0x8(%ebp),%esi
 43b:	8b 45 08             	mov    0x8(%ebp),%eax
 43e:	01 de                	add    %ebx,%esi
 440:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 442:	c6 03 00             	movb   $0x0,(%ebx)
}
 445:	8d 65 f4             	lea    -0xc(%ebp),%esp
 448:	5b                   	pop    %ebx
 449:	5e                   	pop    %esi
 44a:	5f                   	pop    %edi
 44b:	5d                   	pop    %ebp
 44c:	c3                   	ret    
 44d:	8d 76 00             	lea    0x0(%esi),%esi

00000450 <stat>:

int
stat(const char *n, struct stat *st)
{
 450:	f3 0f 1e fb          	endbr32 
 454:	55                   	push   %ebp
 455:	89 e5                	mov    %esp,%ebp
 457:	56                   	push   %esi
 458:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 459:	83 ec 08             	sub    $0x8,%esp
 45c:	6a 00                	push   $0x0
 45e:	ff 75 08             	pushl  0x8(%ebp)
 461:	e8 ed 00 00 00       	call   553 <open>
  if(fd < 0)
 466:	83 c4 10             	add    $0x10,%esp
 469:	85 c0                	test   %eax,%eax
 46b:	78 2b                	js     498 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 46d:	83 ec 08             	sub    $0x8,%esp
 470:	ff 75 0c             	pushl  0xc(%ebp)
 473:	89 c3                	mov    %eax,%ebx
 475:	50                   	push   %eax
 476:	e8 f0 00 00 00       	call   56b <fstat>
  close(fd);
 47b:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 47e:	89 c6                	mov    %eax,%esi
  close(fd);
 480:	e8 b6 00 00 00       	call   53b <close>
  return r;
 485:	83 c4 10             	add    $0x10,%esp
}
 488:	8d 65 f8             	lea    -0x8(%ebp),%esp
 48b:	89 f0                	mov    %esi,%eax
 48d:	5b                   	pop    %ebx
 48e:	5e                   	pop    %esi
 48f:	5d                   	pop    %ebp
 490:	c3                   	ret    
 491:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
 498:	be ff ff ff ff       	mov    $0xffffffff,%esi
 49d:	eb e9                	jmp    488 <stat+0x38>
 49f:	90                   	nop

000004a0 <atoi>:

int
atoi(const char *s)
{
 4a0:	f3 0f 1e fb          	endbr32 
 4a4:	55                   	push   %ebp
 4a5:	89 e5                	mov    %esp,%ebp
 4a7:	53                   	push   %ebx
 4a8:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 4ab:	0f be 02             	movsbl (%edx),%eax
 4ae:	8d 48 d0             	lea    -0x30(%eax),%ecx
 4b1:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 4b4:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 4b9:	77 1a                	ja     4d5 <atoi+0x35>
 4bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4bf:	90                   	nop
    n = n*10 + *s++ - '0';
 4c0:	83 c2 01             	add    $0x1,%edx
 4c3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 4c6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 4ca:	0f be 02             	movsbl (%edx),%eax
 4cd:	8d 58 d0             	lea    -0x30(%eax),%ebx
 4d0:	80 fb 09             	cmp    $0x9,%bl
 4d3:	76 eb                	jbe    4c0 <atoi+0x20>
  return n;
}
 4d5:	89 c8                	mov    %ecx,%eax
 4d7:	5b                   	pop    %ebx
 4d8:	5d                   	pop    %ebp
 4d9:	c3                   	ret    
 4da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000004e0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4e0:	f3 0f 1e fb          	endbr32 
 4e4:	55                   	push   %ebp
 4e5:	89 e5                	mov    %esp,%ebp
 4e7:	57                   	push   %edi
 4e8:	8b 45 10             	mov    0x10(%ebp),%eax
 4eb:	8b 55 08             	mov    0x8(%ebp),%edx
 4ee:	56                   	push   %esi
 4ef:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 4f2:	85 c0                	test   %eax,%eax
 4f4:	7e 0f                	jle    505 <memmove+0x25>
 4f6:	01 d0                	add    %edx,%eax
  dst = vdst;
 4f8:	89 d7                	mov    %edx,%edi
 4fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *dst++ = *src++;
 500:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 501:	39 f8                	cmp    %edi,%eax
 503:	75 fb                	jne    500 <memmove+0x20>
  return vdst;
}
 505:	5e                   	pop    %esi
 506:	89 d0                	mov    %edx,%eax
 508:	5f                   	pop    %edi
 509:	5d                   	pop    %ebp
 50a:	c3                   	ret    

0000050b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 50b:	b8 01 00 00 00       	mov    $0x1,%eax
 510:	cd 40                	int    $0x40
 512:	c3                   	ret    

00000513 <exit>:
SYSCALL(exit)
 513:	b8 02 00 00 00       	mov    $0x2,%eax
 518:	cd 40                	int    $0x40
 51a:	c3                   	ret    

0000051b <wait>:
SYSCALL(wait)
 51b:	b8 03 00 00 00       	mov    $0x3,%eax
 520:	cd 40                	int    $0x40
 522:	c3                   	ret    

00000523 <pipe>:
SYSCALL(pipe)
 523:	b8 04 00 00 00       	mov    $0x4,%eax
 528:	cd 40                	int    $0x40
 52a:	c3                   	ret    

0000052b <read>:
SYSCALL(read)
 52b:	b8 05 00 00 00       	mov    $0x5,%eax
 530:	cd 40                	int    $0x40
 532:	c3                   	ret    

00000533 <write>:
SYSCALL(write)
 533:	b8 10 00 00 00       	mov    $0x10,%eax
 538:	cd 40                	int    $0x40
 53a:	c3                   	ret    

0000053b <close>:
SYSCALL(close)
 53b:	b8 15 00 00 00       	mov    $0x15,%eax
 540:	cd 40                	int    $0x40
 542:	c3                   	ret    

00000543 <kill>:
SYSCALL(kill)
 543:	b8 06 00 00 00       	mov    $0x6,%eax
 548:	cd 40                	int    $0x40
 54a:	c3                   	ret    

0000054b <exec>:
SYSCALL(exec)
 54b:	b8 07 00 00 00       	mov    $0x7,%eax
 550:	cd 40                	int    $0x40
 552:	c3                   	ret    

00000553 <open>:
SYSCALL(open)
 553:	b8 0f 00 00 00       	mov    $0xf,%eax
 558:	cd 40                	int    $0x40
 55a:	c3                   	ret    

0000055b <mknod>:
SYSCALL(mknod)
 55b:	b8 11 00 00 00       	mov    $0x11,%eax
 560:	cd 40                	int    $0x40
 562:	c3                   	ret    

00000563 <unlink>:
SYSCALL(unlink)
 563:	b8 12 00 00 00       	mov    $0x12,%eax
 568:	cd 40                	int    $0x40
 56a:	c3                   	ret    

0000056b <fstat>:
SYSCALL(fstat)
 56b:	b8 08 00 00 00       	mov    $0x8,%eax
 570:	cd 40                	int    $0x40
 572:	c3                   	ret    

00000573 <link>:
SYSCALL(link)
 573:	b8 13 00 00 00       	mov    $0x13,%eax
 578:	cd 40                	int    $0x40
 57a:	c3                   	ret    

0000057b <mkdir>:
SYSCALL(mkdir)
 57b:	b8 14 00 00 00       	mov    $0x14,%eax
 580:	cd 40                	int    $0x40
 582:	c3                   	ret    

00000583 <chdir>:
SYSCALL(chdir)
 583:	b8 09 00 00 00       	mov    $0x9,%eax
 588:	cd 40                	int    $0x40
 58a:	c3                   	ret    

0000058b <dup>:
SYSCALL(dup)
 58b:	b8 0a 00 00 00       	mov    $0xa,%eax
 590:	cd 40                	int    $0x40
 592:	c3                   	ret    

00000593 <getpid>:
SYSCALL(getpid)
 593:	b8 0b 00 00 00       	mov    $0xb,%eax
 598:	cd 40                	int    $0x40
 59a:	c3                   	ret    

0000059b <sbrk>:
SYSCALL(sbrk)
 59b:	b8 0c 00 00 00       	mov    $0xc,%eax
 5a0:	cd 40                	int    $0x40
 5a2:	c3                   	ret    

000005a3 <sleep>:
SYSCALL(sleep)
 5a3:	b8 0d 00 00 00       	mov    $0xd,%eax
 5a8:	cd 40                	int    $0x40
 5aa:	c3                   	ret    

000005ab <uptime>:
SYSCALL(uptime)
 5ab:	b8 0e 00 00 00       	mov    $0xe,%eax
 5b0:	cd 40                	int    $0x40
 5b2:	c3                   	ret    

000005b3 <getrss>:
SYSCALL(getrss)
 5b3:	b8 16 00 00 00       	mov    $0x16,%eax
 5b8:	cd 40                	int    $0x40
 5ba:	c3                   	ret    

000005bb <getNumFreePages>:
 5bb:	b8 17 00 00 00       	mov    $0x17,%eax
 5c0:	cd 40                	int    $0x40
 5c2:	c3                   	ret    
 5c3:	66 90                	xchg   %ax,%ax
 5c5:	66 90                	xchg   %ax,%ax
 5c7:	66 90                	xchg   %ax,%ax
 5c9:	66 90                	xchg   %ax,%ax
 5cb:	66 90                	xchg   %ax,%ax
 5cd:	66 90                	xchg   %ax,%ax
 5cf:	90                   	nop

000005d0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 5d0:	55                   	push   %ebp
 5d1:	89 e5                	mov    %esp,%ebp
 5d3:	57                   	push   %edi
 5d4:	56                   	push   %esi
 5d5:	53                   	push   %ebx
 5d6:	83 ec 3c             	sub    $0x3c,%esp
 5d9:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 5dc:	89 d1                	mov    %edx,%ecx
{
 5de:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 5e1:	85 d2                	test   %edx,%edx
 5e3:	0f 89 7f 00 00 00    	jns    668 <printint+0x98>
 5e9:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 5ed:	74 79                	je     668 <printint+0x98>
    neg = 1;
 5ef:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 5f6:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 5f8:	31 db                	xor    %ebx,%ebx
 5fa:	8d 75 d7             	lea    -0x29(%ebp),%esi
 5fd:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 600:	89 c8                	mov    %ecx,%eax
 602:	31 d2                	xor    %edx,%edx
 604:	89 cf                	mov    %ecx,%edi
 606:	f7 75 c4             	divl   -0x3c(%ebp)
 609:	0f b6 92 80 0b 00 00 	movzbl 0xb80(%edx),%edx
 610:	89 45 c0             	mov    %eax,-0x40(%ebp)
 613:	89 d8                	mov    %ebx,%eax
 615:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 618:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 61b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 61e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 621:	76 dd                	jbe    600 <printint+0x30>
  if(neg)
 623:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 626:	85 c9                	test   %ecx,%ecx
 628:	74 0c                	je     636 <printint+0x66>
    buf[i++] = '-';
 62a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 62f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 631:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 636:	8b 7d b8             	mov    -0x48(%ebp),%edi
 639:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 63d:	eb 07                	jmp    646 <printint+0x76>
 63f:	90                   	nop
 640:	0f b6 13             	movzbl (%ebx),%edx
 643:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 646:	83 ec 04             	sub    $0x4,%esp
 649:	88 55 d7             	mov    %dl,-0x29(%ebp)
 64c:	6a 01                	push   $0x1
 64e:	56                   	push   %esi
 64f:	57                   	push   %edi
 650:	e8 de fe ff ff       	call   533 <write>
  while(--i >= 0)
 655:	83 c4 10             	add    $0x10,%esp
 658:	39 de                	cmp    %ebx,%esi
 65a:	75 e4                	jne    640 <printint+0x70>
    putc(fd, buf[i]);
}
 65c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 65f:	5b                   	pop    %ebx
 660:	5e                   	pop    %esi
 661:	5f                   	pop    %edi
 662:	5d                   	pop    %ebp
 663:	c3                   	ret    
 664:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 668:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 66f:	eb 87                	jmp    5f8 <printint+0x28>
 671:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 678:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 67f:	90                   	nop

00000680 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 680:	f3 0f 1e fb          	endbr32 
 684:	55                   	push   %ebp
 685:	89 e5                	mov    %esp,%ebp
 687:	57                   	push   %edi
 688:	56                   	push   %esi
 689:	53                   	push   %ebx
 68a:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 68d:	8b 75 0c             	mov    0xc(%ebp),%esi
 690:	0f b6 1e             	movzbl (%esi),%ebx
 693:	84 db                	test   %bl,%bl
 695:	0f 84 b4 00 00 00    	je     74f <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
 69b:	8d 45 10             	lea    0x10(%ebp),%eax
 69e:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 6a1:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 6a4:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 6a6:	89 45 d0             	mov    %eax,-0x30(%ebp)
 6a9:	eb 33                	jmp    6de <printf+0x5e>
 6ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6af:	90                   	nop
 6b0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 6b3:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 6b8:	83 f8 25             	cmp    $0x25,%eax
 6bb:	74 17                	je     6d4 <printf+0x54>
  write(fd, &c, 1);
 6bd:	83 ec 04             	sub    $0x4,%esp
 6c0:	88 5d e7             	mov    %bl,-0x19(%ebp)
 6c3:	6a 01                	push   $0x1
 6c5:	57                   	push   %edi
 6c6:	ff 75 08             	pushl  0x8(%ebp)
 6c9:	e8 65 fe ff ff       	call   533 <write>
 6ce:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 6d1:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 6d4:	0f b6 1e             	movzbl (%esi),%ebx
 6d7:	83 c6 01             	add    $0x1,%esi
 6da:	84 db                	test   %bl,%bl
 6dc:	74 71                	je     74f <printf+0xcf>
    c = fmt[i] & 0xff;
 6de:	0f be cb             	movsbl %bl,%ecx
 6e1:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 6e4:	85 d2                	test   %edx,%edx
 6e6:	74 c8                	je     6b0 <printf+0x30>
      }
    } else if(state == '%'){
 6e8:	83 fa 25             	cmp    $0x25,%edx
 6eb:	75 e7                	jne    6d4 <printf+0x54>
      if(c == 'd'){
 6ed:	83 f8 64             	cmp    $0x64,%eax
 6f0:	0f 84 9a 00 00 00    	je     790 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 6f6:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 6fc:	83 f9 70             	cmp    $0x70,%ecx
 6ff:	74 5f                	je     760 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 701:	83 f8 73             	cmp    $0x73,%eax
 704:	0f 84 d6 00 00 00    	je     7e0 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 70a:	83 f8 63             	cmp    $0x63,%eax
 70d:	0f 84 8d 00 00 00    	je     7a0 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 713:	83 f8 25             	cmp    $0x25,%eax
 716:	0f 84 b4 00 00 00    	je     7d0 <printf+0x150>
  write(fd, &c, 1);
 71c:	83 ec 04             	sub    $0x4,%esp
 71f:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 723:	6a 01                	push   $0x1
 725:	57                   	push   %edi
 726:	ff 75 08             	pushl  0x8(%ebp)
 729:	e8 05 fe ff ff       	call   533 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 72e:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 731:	83 c4 0c             	add    $0xc,%esp
 734:	6a 01                	push   $0x1
 736:	83 c6 01             	add    $0x1,%esi
 739:	57                   	push   %edi
 73a:	ff 75 08             	pushl  0x8(%ebp)
 73d:	e8 f1 fd ff ff       	call   533 <write>
  for(i = 0; fmt[i]; i++){
 742:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 746:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 749:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 74b:	84 db                	test   %bl,%bl
 74d:	75 8f                	jne    6de <printf+0x5e>
    }
  }
}
 74f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 752:	5b                   	pop    %ebx
 753:	5e                   	pop    %esi
 754:	5f                   	pop    %edi
 755:	5d                   	pop    %ebp
 756:	c3                   	ret    
 757:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 75e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 760:	83 ec 0c             	sub    $0xc,%esp
 763:	b9 10 00 00 00       	mov    $0x10,%ecx
 768:	6a 00                	push   $0x0
 76a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 76d:	8b 45 08             	mov    0x8(%ebp),%eax
 770:	8b 13                	mov    (%ebx),%edx
 772:	e8 59 fe ff ff       	call   5d0 <printint>
        ap++;
 777:	89 d8                	mov    %ebx,%eax
 779:	83 c4 10             	add    $0x10,%esp
      state = 0;
 77c:	31 d2                	xor    %edx,%edx
        ap++;
 77e:	83 c0 04             	add    $0x4,%eax
 781:	89 45 d0             	mov    %eax,-0x30(%ebp)
 784:	e9 4b ff ff ff       	jmp    6d4 <printf+0x54>
 789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 790:	83 ec 0c             	sub    $0xc,%esp
 793:	b9 0a 00 00 00       	mov    $0xa,%ecx
 798:	6a 01                	push   $0x1
 79a:	eb ce                	jmp    76a <printf+0xea>
 79c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 7a0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 7a3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 7a6:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 7a8:	6a 01                	push   $0x1
        ap++;
 7aa:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 7ad:	57                   	push   %edi
 7ae:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 7b1:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 7b4:	e8 7a fd ff ff       	call   533 <write>
        ap++;
 7b9:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 7bc:	83 c4 10             	add    $0x10,%esp
      state = 0;
 7bf:	31 d2                	xor    %edx,%edx
 7c1:	e9 0e ff ff ff       	jmp    6d4 <printf+0x54>
 7c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7cd:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 7d0:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 7d3:	83 ec 04             	sub    $0x4,%esp
 7d6:	e9 59 ff ff ff       	jmp    734 <printf+0xb4>
 7db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 7df:	90                   	nop
        s = (char*)*ap;
 7e0:	8b 45 d0             	mov    -0x30(%ebp),%eax
 7e3:	8b 18                	mov    (%eax),%ebx
        ap++;
 7e5:	83 c0 04             	add    $0x4,%eax
 7e8:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 7eb:	85 db                	test   %ebx,%ebx
 7ed:	74 17                	je     806 <printf+0x186>
        while(*s != 0){
 7ef:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 7f2:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 7f4:	84 c0                	test   %al,%al
 7f6:	0f 84 d8 fe ff ff    	je     6d4 <printf+0x54>
 7fc:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 7ff:	89 de                	mov    %ebx,%esi
 801:	8b 5d 08             	mov    0x8(%ebp),%ebx
 804:	eb 1a                	jmp    820 <printf+0x1a0>
          s = "(null)";
 806:	bb 78 0b 00 00       	mov    $0xb78,%ebx
        while(*s != 0){
 80b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 80e:	b8 28 00 00 00       	mov    $0x28,%eax
 813:	89 de                	mov    %ebx,%esi
 815:	8b 5d 08             	mov    0x8(%ebp),%ebx
 818:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 81f:	90                   	nop
  write(fd, &c, 1);
 820:	83 ec 04             	sub    $0x4,%esp
          s++;
 823:	83 c6 01             	add    $0x1,%esi
 826:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 829:	6a 01                	push   $0x1
 82b:	57                   	push   %edi
 82c:	53                   	push   %ebx
 82d:	e8 01 fd ff ff       	call   533 <write>
        while(*s != 0){
 832:	0f b6 06             	movzbl (%esi),%eax
 835:	83 c4 10             	add    $0x10,%esp
 838:	84 c0                	test   %al,%al
 83a:	75 e4                	jne    820 <printf+0x1a0>
 83c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 83f:	31 d2                	xor    %edx,%edx
 841:	e9 8e fe ff ff       	jmp    6d4 <printf+0x54>
 846:	66 90                	xchg   %ax,%ax
 848:	66 90                	xchg   %ax,%ax
 84a:	66 90                	xchg   %ax,%ax
 84c:	66 90                	xchg   %ax,%ax
 84e:	66 90                	xchg   %ax,%ax

00000850 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 850:	f3 0f 1e fb          	endbr32 
 854:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 855:	a1 68 0e 00 00       	mov    0xe68,%eax
{
 85a:	89 e5                	mov    %esp,%ebp
 85c:	57                   	push   %edi
 85d:	56                   	push   %esi
 85e:	53                   	push   %ebx
 85f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 862:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 864:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 867:	39 c8                	cmp    %ecx,%eax
 869:	73 15                	jae    880 <free+0x30>
 86b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 86f:	90                   	nop
 870:	39 d1                	cmp    %edx,%ecx
 872:	72 14                	jb     888 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 874:	39 d0                	cmp    %edx,%eax
 876:	73 10                	jae    888 <free+0x38>
{
 878:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 87a:	8b 10                	mov    (%eax),%edx
 87c:	39 c8                	cmp    %ecx,%eax
 87e:	72 f0                	jb     870 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 880:	39 d0                	cmp    %edx,%eax
 882:	72 f4                	jb     878 <free+0x28>
 884:	39 d1                	cmp    %edx,%ecx
 886:	73 f0                	jae    878 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 888:	8b 73 fc             	mov    -0x4(%ebx),%esi
 88b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 88e:	39 fa                	cmp    %edi,%edx
 890:	74 1e                	je     8b0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 892:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 895:	8b 50 04             	mov    0x4(%eax),%edx
 898:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 89b:	39 f1                	cmp    %esi,%ecx
 89d:	74 28                	je     8c7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 89f:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 8a1:	5b                   	pop    %ebx
  freep = p;
 8a2:	a3 68 0e 00 00       	mov    %eax,0xe68
}
 8a7:	5e                   	pop    %esi
 8a8:	5f                   	pop    %edi
 8a9:	5d                   	pop    %ebp
 8aa:	c3                   	ret    
 8ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 8af:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 8b0:	03 72 04             	add    0x4(%edx),%esi
 8b3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 8b6:	8b 10                	mov    (%eax),%edx
 8b8:	8b 12                	mov    (%edx),%edx
 8ba:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 8bd:	8b 50 04             	mov    0x4(%eax),%edx
 8c0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 8c3:	39 f1                	cmp    %esi,%ecx
 8c5:	75 d8                	jne    89f <free+0x4f>
    p->s.size += bp->s.size;
 8c7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 8ca:	a3 68 0e 00 00       	mov    %eax,0xe68
    p->s.size += bp->s.size;
 8cf:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 8d2:	8b 53 f8             	mov    -0x8(%ebx),%edx
 8d5:	89 10                	mov    %edx,(%eax)
}
 8d7:	5b                   	pop    %ebx
 8d8:	5e                   	pop    %esi
 8d9:	5f                   	pop    %edi
 8da:	5d                   	pop    %ebp
 8db:	c3                   	ret    
 8dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000008e0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8e0:	f3 0f 1e fb          	endbr32 
 8e4:	55                   	push   %ebp
 8e5:	89 e5                	mov    %esp,%ebp
 8e7:	57                   	push   %edi
 8e8:	56                   	push   %esi
 8e9:	53                   	push   %ebx
 8ea:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8ed:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 8f0:	8b 3d 68 0e 00 00    	mov    0xe68,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8f6:	8d 70 07             	lea    0x7(%eax),%esi
 8f9:	c1 ee 03             	shr    $0x3,%esi
 8fc:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 8ff:	85 ff                	test   %edi,%edi
 901:	0f 84 a9 00 00 00    	je     9b0 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 907:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 909:	8b 48 04             	mov    0x4(%eax),%ecx
 90c:	39 f1                	cmp    %esi,%ecx
 90e:	73 6d                	jae    97d <malloc+0x9d>
 910:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 916:	bb 00 10 00 00       	mov    $0x1000,%ebx
 91b:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 91e:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 925:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 928:	eb 17                	jmp    941 <malloc+0x61>
 92a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 930:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 932:	8b 4a 04             	mov    0x4(%edx),%ecx
 935:	39 f1                	cmp    %esi,%ecx
 937:	73 4f                	jae    988 <malloc+0xa8>
 939:	8b 3d 68 0e 00 00    	mov    0xe68,%edi
 93f:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 941:	39 c7                	cmp    %eax,%edi
 943:	75 eb                	jne    930 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 945:	83 ec 0c             	sub    $0xc,%esp
 948:	ff 75 e4             	pushl  -0x1c(%ebp)
 94b:	e8 4b fc ff ff       	call   59b <sbrk>
  if(p == (char*)-1)
 950:	83 c4 10             	add    $0x10,%esp
 953:	83 f8 ff             	cmp    $0xffffffff,%eax
 956:	74 1b                	je     973 <malloc+0x93>
  hp->s.size = nu;
 958:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 95b:	83 ec 0c             	sub    $0xc,%esp
 95e:	83 c0 08             	add    $0x8,%eax
 961:	50                   	push   %eax
 962:	e8 e9 fe ff ff       	call   850 <free>
  return freep;
 967:	a1 68 0e 00 00       	mov    0xe68,%eax
      if((p = morecore(nunits)) == 0)
 96c:	83 c4 10             	add    $0x10,%esp
 96f:	85 c0                	test   %eax,%eax
 971:	75 bd                	jne    930 <malloc+0x50>
        return 0;
  }
}
 973:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 976:	31 c0                	xor    %eax,%eax
}
 978:	5b                   	pop    %ebx
 979:	5e                   	pop    %esi
 97a:	5f                   	pop    %edi
 97b:	5d                   	pop    %ebp
 97c:	c3                   	ret    
    if(p->s.size >= nunits){
 97d:	89 c2                	mov    %eax,%edx
 97f:	89 f8                	mov    %edi,%eax
 981:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 988:	39 ce                	cmp    %ecx,%esi
 98a:	74 54                	je     9e0 <malloc+0x100>
        p->s.size -= nunits;
 98c:	29 f1                	sub    %esi,%ecx
 98e:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 991:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 994:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 997:	a3 68 0e 00 00       	mov    %eax,0xe68
}
 99c:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 99f:	8d 42 08             	lea    0x8(%edx),%eax
}
 9a2:	5b                   	pop    %ebx
 9a3:	5e                   	pop    %esi
 9a4:	5f                   	pop    %edi
 9a5:	5d                   	pop    %ebp
 9a6:	c3                   	ret    
 9a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 9ae:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 9b0:	c7 05 68 0e 00 00 6c 	movl   $0xe6c,0xe68
 9b7:	0e 00 00 
    base.s.size = 0;
 9ba:	bf 6c 0e 00 00       	mov    $0xe6c,%edi
    base.s.ptr = freep = prevp = &base;
 9bf:	c7 05 6c 0e 00 00 6c 	movl   $0xe6c,0xe6c
 9c6:	0e 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9c9:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
 9cb:	c7 05 70 0e 00 00 00 	movl   $0x0,0xe70
 9d2:	00 00 00 
    if(p->s.size >= nunits){
 9d5:	e9 36 ff ff ff       	jmp    910 <malloc+0x30>
 9da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 9e0:	8b 0a                	mov    (%edx),%ecx
 9e2:	89 08                	mov    %ecx,(%eax)
 9e4:	eb b1                	jmp    997 <malloc+0xb7>
