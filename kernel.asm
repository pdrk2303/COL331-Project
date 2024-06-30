
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 c5 10 80       	mov    $0x8010c5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 a0 30 10 80       	mov    $0x801030a0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	f3 0f 1e fb          	endbr32 
80100044:	55                   	push   %ebp
80100045:	89 e5                	mov    %esp,%ebp
80100047:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100048:	bb f4 c5 10 80       	mov    $0x8010c5f4,%ebx
{
8010004d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
80100050:	68 40 77 10 80       	push   $0x80107740
80100055:	68 c0 c5 10 80       	push   $0x8010c5c0
8010005a:	e8 51 45 00 00       	call   801045b0 <initlock>
  bcache.head.next = &bcache.head;
8010005f:	83 c4 10             	add    $0x10,%esp
80100062:	b8 bc 0c 11 80       	mov    $0x80110cbc,%eax
  bcache.head.prev = &bcache.head;
80100067:	c7 05 0c 0d 11 80 bc 	movl   $0x80110cbc,0x80110d0c
8010006e:	0c 11 80 
  bcache.head.next = &bcache.head;
80100071:	c7 05 10 0d 11 80 bc 	movl   $0x80110cbc,0x80110d10
80100078:	0c 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010007b:	eb 05                	jmp    80100082 <binit+0x42>
8010007d:	8d 76 00             	lea    0x0(%esi),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 47 77 10 80       	push   $0x80107747
80100097:	50                   	push   %eax
80100098:	e8 d3 43 00 00       	call   80104470 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 0d 11 80       	mov    0x80110d10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb 60 0a 11 80    	cmp    $0x80110a60,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	f3 0f 1e fb          	endbr32 
801000d4:	55                   	push   %ebp
801000d5:	89 e5                	mov    %esp,%ebp
801000d7:	57                   	push   %edi
801000d8:	56                   	push   %esi
801000d9:	53                   	push   %ebx
801000da:	83 ec 18             	sub    $0x18,%esp
801000dd:	8b 7d 08             	mov    0x8(%ebp),%edi
801000e0:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&bcache.lock);
801000e3:	68 c0 c5 10 80       	push   $0x8010c5c0
801000e8:	e8 43 46 00 00       	call   80104730 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ed:	8b 1d 10 0d 11 80    	mov    0x80110d10,%ebx
801000f3:	83 c4 10             	add    $0x10,%esp
801000f6:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
801000fc:	75 0d                	jne    8010010b <bread+0x3b>
801000fe:	eb 20                	jmp    80100120 <bread+0x50>
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 7b 04             	cmp    0x4(%ebx),%edi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 73 08             	cmp    0x8(%ebx),%esi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c 0d 11 80    	mov    0x80110d0c,%ebx
80100126:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
80100139:	74 65                	je     801001a0 <bread+0xd0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 7b 04             	mov    %edi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 73 08             	mov    %esi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 c5 10 80       	push   $0x8010c5c0
80100162:	e8 89 46 00 00       	call   801047f0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 3e 43 00 00       	call   801044b0 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 ef 20 00 00       	call   80102280 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
8010019e:	66 90                	xchg   %ax,%ax
  panic("bget: no buffers");
801001a0:	83 ec 0c             	sub    $0xc,%esp
801001a3:	68 4e 77 10 80       	push   $0x8010774e
801001a8:	e8 e3 01 00 00       	call   80100390 <panic>
801001ad:	8d 76 00             	lea    0x0(%esi),%esi

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	f3 0f 1e fb          	endbr32 
801001b4:	55                   	push   %ebp
801001b5:	89 e5                	mov    %esp,%ebp
801001b7:	53                   	push   %ebx
801001b8:	83 ec 10             	sub    $0x10,%esp
801001bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001be:	8d 43 0c             	lea    0xc(%ebx),%eax
801001c1:	50                   	push   %eax
801001c2:	e8 89 43 00 00       	call   80104550 <holdingsleep>
801001c7:	83 c4 10             	add    $0x10,%esp
801001ca:	85 c0                	test   %eax,%eax
801001cc:	74 0f                	je     801001dd <bwrite+0x2d>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ce:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001d1:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d7:	c9                   	leave  
  iderw(b);
801001d8:	e9 a3 20 00 00       	jmp    80102280 <iderw>
    panic("bwrite");
801001dd:	83 ec 0c             	sub    $0xc,%esp
801001e0:	68 5f 77 10 80       	push   $0x8010775f
801001e5:	e8 a6 01 00 00       	call   80100390 <panic>
801001ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	f3 0f 1e fb          	endbr32 
801001f4:	55                   	push   %ebp
801001f5:	89 e5                	mov    %esp,%ebp
801001f7:	56                   	push   %esi
801001f8:	53                   	push   %ebx
801001f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001fc:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ff:	83 ec 0c             	sub    $0xc,%esp
80100202:	56                   	push   %esi
80100203:	e8 48 43 00 00       	call   80104550 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 f8 42 00 00       	call   80104510 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010021f:	e8 0c 45 00 00       	call   80104730 <acquire>
  b->refcnt--;
80100224:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100227:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
8010022a:	83 e8 01             	sub    $0x1,%eax
8010022d:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
80100230:	85 c0                	test   %eax,%eax
80100232:	75 2f                	jne    80100263 <brelse+0x73>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100234:	8b 43 54             	mov    0x54(%ebx),%eax
80100237:	8b 53 50             	mov    0x50(%ebx),%edx
8010023a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010023d:	8b 43 50             	mov    0x50(%ebx),%eax
80100240:	8b 53 54             	mov    0x54(%ebx),%edx
80100243:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100246:	a1 10 0d 11 80       	mov    0x80110d10,%eax
    b->prev = &bcache.head;
8010024b:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    b->next = bcache.head.next;
80100252:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100255:	a1 10 0d 11 80       	mov    0x80110d10,%eax
8010025a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010025d:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
  }
  
  release(&bcache.lock);
80100263:	c7 45 08 c0 c5 10 80 	movl   $0x8010c5c0,0x8(%ebp)
}
8010026a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010026d:	5b                   	pop    %ebx
8010026e:	5e                   	pop    %esi
8010026f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100270:	e9 7b 45 00 00       	jmp    801047f0 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 66 77 10 80       	push   $0x80107766
8010027d:	e8 0e 01 00 00       	call   80100390 <panic>
80100282:	66 90                	xchg   %ax,%ax
80100284:	66 90                	xchg   %ax,%ax
80100286:	66 90                	xchg   %ax,%ax
80100288:	66 90                	xchg   %ax,%ax
8010028a:	66 90                	xchg   %ax,%ax
8010028c:	66 90                	xchg   %ax,%ax
8010028e:	66 90                	xchg   %ax,%ax

80100290 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100290:	f3 0f 1e fb          	endbr32 
80100294:	55                   	push   %ebp
80100295:	89 e5                	mov    %esp,%ebp
80100297:	57                   	push   %edi
80100298:	56                   	push   %esi
80100299:	53                   	push   %ebx
8010029a:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
8010029d:	ff 75 08             	pushl  0x8(%ebp)
{
801002a0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  target = n;
801002a3:	89 de                	mov    %ebx,%esi
  iunlock(ip);
801002a5:	e8 96 15 00 00       	call   80101840 <iunlock>
  acquire(&cons.lock);
801002aa:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
801002b1:	e8 7a 44 00 00       	call   80104730 <acquire>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002b6:	8b 7d 0c             	mov    0xc(%ebp),%edi
  while(n > 0){
801002b9:	83 c4 10             	add    $0x10,%esp
    *dst++ = c;
801002bc:	01 df                	add    %ebx,%edi
  while(n > 0){
801002be:	85 db                	test   %ebx,%ebx
801002c0:	0f 8e 97 00 00 00    	jle    8010035d <consoleread+0xcd>
    while(input.r == input.w){
801002c6:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801002cb:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801002d1:	74 27                	je     801002fa <consoleread+0x6a>
801002d3:	eb 5b                	jmp    80100330 <consoleread+0xa0>
801002d5:	8d 76 00             	lea    0x0(%esi),%esi
      sleep(&input.r, &cons.lock);
801002d8:	83 ec 08             	sub    $0x8,%esp
801002db:	68 20 b5 10 80       	push   $0x8010b520
801002e0:	68 a0 0f 11 80       	push   $0x80110fa0
801002e5:	e8 f6 3d 00 00       	call   801040e0 <sleep>
    while(input.r == input.w){
801002ea:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 b1 36 00 00       	call   801039b0 <myproc>
801002ff:	8b 48 28             	mov    0x28(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 20 b5 10 80       	push   $0x8010b520
8010030e:	e8 dd 44 00 00       	call   801047f0 <release>
        ilock(ip);
80100313:	5a                   	pop    %edx
80100314:	ff 75 08             	pushl  0x8(%ebp)
80100317:	e8 44 14 00 00       	call   80101760 <ilock>
        return -1;
8010031c:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
8010031f:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100322:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100327:	5b                   	pop    %ebx
80100328:	5e                   	pop    %esi
80100329:	5f                   	pop    %edi
8010032a:	5d                   	pop    %ebp
8010032b:	c3                   	ret    
8010032c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100330:	8d 50 01             	lea    0x1(%eax),%edx
80100333:	89 15 a0 0f 11 80    	mov    %edx,0x80110fa0
80100339:	89 c2                	mov    %eax,%edx
8010033b:	83 e2 7f             	and    $0x7f,%edx
8010033e:	0f be 8a 20 0f 11 80 	movsbl -0x7feef0e0(%edx),%ecx
    if(c == C('D')){  // EOF
80100345:	80 f9 04             	cmp    $0x4,%cl
80100348:	74 38                	je     80100382 <consoleread+0xf2>
    *dst++ = c;
8010034a:	89 d8                	mov    %ebx,%eax
    --n;
8010034c:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
8010034f:	f7 d8                	neg    %eax
80100351:	88 0c 07             	mov    %cl,(%edi,%eax,1)
    if(c == '\n')
80100354:	83 f9 0a             	cmp    $0xa,%ecx
80100357:	0f 85 61 ff ff ff    	jne    801002be <consoleread+0x2e>
  release(&cons.lock);
8010035d:	83 ec 0c             	sub    $0xc,%esp
80100360:	68 20 b5 10 80       	push   $0x8010b520
80100365:	e8 86 44 00 00       	call   801047f0 <release>
  ilock(ip);
8010036a:	58                   	pop    %eax
8010036b:	ff 75 08             	pushl  0x8(%ebp)
8010036e:	e8 ed 13 00 00       	call   80101760 <ilock>
  return target - n;
80100373:	89 f0                	mov    %esi,%eax
80100375:	83 c4 10             	add    $0x10,%esp
}
80100378:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
8010037b:	29 d8                	sub    %ebx,%eax
}
8010037d:	5b                   	pop    %ebx
8010037e:	5e                   	pop    %esi
8010037f:	5f                   	pop    %edi
80100380:	5d                   	pop    %ebp
80100381:	c3                   	ret    
      if(n < target){
80100382:	39 f3                	cmp    %esi,%ebx
80100384:	73 d7                	jae    8010035d <consoleread+0xcd>
        input.r--;
80100386:	a3 a0 0f 11 80       	mov    %eax,0x80110fa0
8010038b:	eb d0                	jmp    8010035d <consoleread+0xcd>
8010038d:	8d 76 00             	lea    0x0(%esi),%esi

80100390 <panic>:
{
80100390:	f3 0f 1e fb          	endbr32 
80100394:	55                   	push   %ebp
80100395:	89 e5                	mov    %esp,%ebp
80100397:	56                   	push   %esi
80100398:	53                   	push   %ebx
80100399:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
8010039c:	fa                   	cli    
  cons.locking = 0;
8010039d:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
801003a4:	00 00 00 
  getcallerpcs(&s, pcs);
801003a7:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003aa:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003ad:	e8 4e 25 00 00       	call   80102900 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 6d 77 10 80       	push   $0x8010776d
801003bb:	e8 f0 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 e7 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 bf 81 10 80 	movl   $0x801081bf,(%esp)
801003d0:	e8 db 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 ef 41 00 00       	call   801045d0 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 81 77 10 80       	push   $0x80107781
801003f1:	e8 ba 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003f6:	83 c4 10             	add    $0x10,%esp
801003f9:	39 f3                	cmp    %esi,%ebx
801003fb:	75 e7                	jne    801003e4 <panic+0x54>
  panicked = 1; // freeze other CPU
801003fd:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
80100404:	00 00 00 
  for(;;)
80100407:	eb fe                	jmp    80100407 <panic+0x77>
80100409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100410 <consputc.part.0>:
consputc(int c)
80100410:	55                   	push   %ebp
80100411:	89 e5                	mov    %esp,%ebp
80100413:	57                   	push   %edi
80100414:	56                   	push   %esi
80100415:	53                   	push   %ebx
80100416:	89 c3                	mov    %eax,%ebx
80100418:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010041b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100420:	0f 84 ea 00 00 00    	je     80100510 <consputc.part.0+0x100>
    uartputc(c);
80100426:	83 ec 0c             	sub    $0xc,%esp
80100429:	50                   	push   %eax
8010042a:	e8 d1 5a 00 00       	call   80105f00 <uartputc>
8010042f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100432:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100437:	b8 0e 00 00 00       	mov    $0xe,%eax
8010043c:	89 fa                	mov    %edi,%edx
8010043e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010043f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100444:	89 ca                	mov    %ecx,%edx
80100446:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100447:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010044a:	89 fa                	mov    %edi,%edx
8010044c:	c1 e0 08             	shl    $0x8,%eax
8010044f:	89 c6                	mov    %eax,%esi
80100451:	b8 0f 00 00 00       	mov    $0xf,%eax
80100456:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100457:	89 ca                	mov    %ecx,%edx
80100459:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
8010045a:	0f b6 c0             	movzbl %al,%eax
8010045d:	09 f0                	or     %esi,%eax
  if(c == '\n')
8010045f:	83 fb 0a             	cmp    $0xa,%ebx
80100462:	0f 84 90 00 00 00    	je     801004f8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100468:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010046e:	74 70                	je     801004e0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100470:	0f b6 db             	movzbl %bl,%ebx
80100473:	8d 70 01             	lea    0x1(%eax),%esi
80100476:	80 cf 07             	or     $0x7,%bh
80100479:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
80100480:	80 
  if(pos < 0 || pos > 25*80)
80100481:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100487:	0f 8f f9 00 00 00    	jg     80100586 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010048d:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100493:	0f 8f a7 00 00 00    	jg     80100540 <consputc.part.0+0x130>
80100499:	89 f0                	mov    %esi,%eax
8010049b:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
801004a2:	88 45 e7             	mov    %al,-0x19(%ebp)
801004a5:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004a8:	bb d4 03 00 00       	mov    $0x3d4,%ebx
801004ad:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004ba:	89 f8                	mov    %edi,%eax
801004bc:	89 ca                	mov    %ecx,%edx
801004be:	ee                   	out    %al,(%dx)
801004bf:	b8 0f 00 00 00       	mov    $0xf,%eax
801004c4:	89 da                	mov    %ebx,%edx
801004c6:	ee                   	out    %al,(%dx)
801004c7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004cb:	89 ca                	mov    %ecx,%edx
801004cd:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004ce:	b8 20 07 00 00       	mov    $0x720,%eax
801004d3:	66 89 06             	mov    %ax,(%esi)
}
801004d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004d9:	5b                   	pop    %ebx
801004da:	5e                   	pop    %esi
801004db:	5f                   	pop    %edi
801004dc:	5d                   	pop    %ebp
801004dd:	c3                   	ret    
801004de:	66 90                	xchg   %ax,%ax
    if(pos > 0) --pos;
801004e0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004e3:	85 c0                	test   %eax,%eax
801004e5:	75 9a                	jne    80100481 <consputc.part.0+0x71>
801004e7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004eb:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004f0:	31 ff                	xor    %edi,%edi
801004f2:	eb b4                	jmp    801004a8 <consputc.part.0+0x98>
801004f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004f8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004fd:	f7 e2                	mul    %edx
801004ff:	c1 ea 06             	shr    $0x6,%edx
80100502:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100505:	c1 e0 04             	shl    $0x4,%eax
80100508:	8d 70 50             	lea    0x50(%eax),%esi
8010050b:	e9 71 ff ff ff       	jmp    80100481 <consputc.part.0+0x71>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100510:	83 ec 0c             	sub    $0xc,%esp
80100513:	6a 08                	push   $0x8
80100515:	e8 e6 59 00 00       	call   80105f00 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 da 59 00 00       	call   80105f00 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 ce 59 00 00       	call   80105f00 <uartputc>
80100532:	83 c4 10             	add    $0x10,%esp
80100535:	e9 f8 fe ff ff       	jmp    80100432 <consputc.part.0+0x22>
8010053a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100540:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100543:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100546:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
8010054d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100552:	68 60 0e 00 00       	push   $0xe60
80100557:	68 a0 80 0b 80       	push   $0x800b80a0
8010055c:	68 00 80 0b 80       	push   $0x800b8000
80100561:	e8 7a 43 00 00       	call   801048e0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 c5 42 00 00       	call   80104840 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 85 77 10 80       	push   $0x80107785
8010058e:	e8 fd fd ff ff       	call   80100390 <panic>
80100593:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010059a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801005a0 <printint>:
{
801005a0:	55                   	push   %ebp
801005a1:	89 e5                	mov    %esp,%ebp
801005a3:	57                   	push   %edi
801005a4:	56                   	push   %esi
801005a5:	53                   	push   %ebx
801005a6:	83 ec 2c             	sub    $0x2c,%esp
801005a9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
801005ac:	85 c9                	test   %ecx,%ecx
801005ae:	74 04                	je     801005b4 <printint+0x14>
801005b0:	85 c0                	test   %eax,%eax
801005b2:	78 6d                	js     80100621 <printint+0x81>
    x = xx;
801005b4:	89 c1                	mov    %eax,%ecx
801005b6:	31 f6                	xor    %esi,%esi
  i = 0;
801005b8:	89 75 cc             	mov    %esi,-0x34(%ebp)
801005bb:	31 db                	xor    %ebx,%ebx
801005bd:	8d 7d d7             	lea    -0x29(%ebp),%edi
    buf[i++] = digits[x % base];
801005c0:	89 c8                	mov    %ecx,%eax
801005c2:	31 d2                	xor    %edx,%edx
801005c4:	89 ce                	mov    %ecx,%esi
801005c6:	f7 75 d4             	divl   -0x2c(%ebp)
801005c9:	0f b6 92 b0 77 10 80 	movzbl -0x7fef8850(%edx),%edx
801005d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
801005d3:	89 d8                	mov    %ebx,%eax
801005d5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
801005d8:	8b 4d d0             	mov    -0x30(%ebp),%ecx
801005db:	89 75 d0             	mov    %esi,-0x30(%ebp)
    buf[i++] = digits[x % base];
801005de:	88 14 1f             	mov    %dl,(%edi,%ebx,1)
  }while((x /= base) != 0);
801005e1:	8b 75 d4             	mov    -0x2c(%ebp),%esi
801005e4:	39 75 d0             	cmp    %esi,-0x30(%ebp)
801005e7:	73 d7                	jae    801005c0 <printint+0x20>
801005e9:	8b 75 cc             	mov    -0x34(%ebp),%esi
  if(sign)
801005ec:	85 f6                	test   %esi,%esi
801005ee:	74 0c                	je     801005fc <printint+0x5c>
    buf[i++] = '-';
801005f0:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
801005f5:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
801005f7:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
801005fc:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
80100600:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100603:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
80100609:	85 d2                	test   %edx,%edx
8010060b:	74 03                	je     80100610 <printint+0x70>
  asm volatile("cli");
8010060d:	fa                   	cli    
    for(;;)
8010060e:	eb fe                	jmp    8010060e <printint+0x6e>
80100610:	e8 fb fd ff ff       	call   80100410 <consputc.part.0>
  while(--i >= 0)
80100615:	39 fb                	cmp    %edi,%ebx
80100617:	74 10                	je     80100629 <printint+0x89>
80100619:	0f be 03             	movsbl (%ebx),%eax
8010061c:	83 eb 01             	sub    $0x1,%ebx
8010061f:	eb e2                	jmp    80100603 <printint+0x63>
    x = -xx;
80100621:	f7 d8                	neg    %eax
80100623:	89 ce                	mov    %ecx,%esi
80100625:	89 c1                	mov    %eax,%ecx
80100627:	eb 8f                	jmp    801005b8 <printint+0x18>
}
80100629:	83 c4 2c             	add    $0x2c,%esp
8010062c:	5b                   	pop    %ebx
8010062d:	5e                   	pop    %esi
8010062e:	5f                   	pop    %edi
8010062f:	5d                   	pop    %ebp
80100630:	c3                   	ret    
80100631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100638:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010063f:	90                   	nop

80100640 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100640:	f3 0f 1e fb          	endbr32 
80100644:	55                   	push   %ebp
80100645:	89 e5                	mov    %esp,%ebp
80100647:	57                   	push   %edi
80100648:	56                   	push   %esi
80100649:	53                   	push   %ebx
8010064a:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
8010064d:	ff 75 08             	pushl  0x8(%ebp)
{
80100650:	8b 5d 10             	mov    0x10(%ebp),%ebx
  iunlock(ip);
80100653:	e8 e8 11 00 00       	call   80101840 <iunlock>
  acquire(&cons.lock);
80100658:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010065f:	e8 cc 40 00 00       	call   80104730 <acquire>
  for(i = 0; i < n; i++)
80100664:	83 c4 10             	add    $0x10,%esp
80100667:	85 db                	test   %ebx,%ebx
80100669:	7e 24                	jle    8010068f <consolewrite+0x4f>
8010066b:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010066e:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
  if(panicked){
80100671:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
80100677:	85 d2                	test   %edx,%edx
80100679:	74 05                	je     80100680 <consolewrite+0x40>
8010067b:	fa                   	cli    
    for(;;)
8010067c:	eb fe                	jmp    8010067c <consolewrite+0x3c>
8010067e:	66 90                	xchg   %ax,%ax
    consputc(buf[i] & 0xff);
80100680:	0f b6 07             	movzbl (%edi),%eax
80100683:	83 c7 01             	add    $0x1,%edi
80100686:	e8 85 fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; i < n; i++)
8010068b:	39 fe                	cmp    %edi,%esi
8010068d:	75 e2                	jne    80100671 <consolewrite+0x31>
  release(&cons.lock);
8010068f:	83 ec 0c             	sub    $0xc,%esp
80100692:	68 20 b5 10 80       	push   $0x8010b520
80100697:	e8 54 41 00 00       	call   801047f0 <release>
  ilock(ip);
8010069c:	58                   	pop    %eax
8010069d:	ff 75 08             	pushl  0x8(%ebp)
801006a0:	e8 bb 10 00 00       	call   80101760 <ilock>

  return n;
}
801006a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801006a8:	89 d8                	mov    %ebx,%eax
801006aa:	5b                   	pop    %ebx
801006ab:	5e                   	pop    %esi
801006ac:	5f                   	pop    %edi
801006ad:	5d                   	pop    %ebp
801006ae:	c3                   	ret    
801006af:	90                   	nop

801006b0 <cprintf>:
{
801006b0:	f3 0f 1e fb          	endbr32 
801006b4:	55                   	push   %ebp
801006b5:	89 e5                	mov    %esp,%ebp
801006b7:	57                   	push   %edi
801006b8:	56                   	push   %esi
801006b9:	53                   	push   %ebx
801006ba:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006bd:	a1 54 b5 10 80       	mov    0x8010b554,%eax
801006c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
801006c5:	85 c0                	test   %eax,%eax
801006c7:	0f 85 e8 00 00 00    	jne    801007b5 <cprintf+0x105>
  if (fmt == 0)
801006cd:	8b 45 08             	mov    0x8(%ebp),%eax
801006d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006d3:	85 c0                	test   %eax,%eax
801006d5:	0f 84 5a 01 00 00    	je     80100835 <cprintf+0x185>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006db:	0f b6 00             	movzbl (%eax),%eax
801006de:	85 c0                	test   %eax,%eax
801006e0:	74 36                	je     80100718 <cprintf+0x68>
  argp = (uint*)(void*)(&fmt + 1);
801006e2:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e5:	31 f6                	xor    %esi,%esi
    if(c != '%'){
801006e7:	83 f8 25             	cmp    $0x25,%eax
801006ea:	74 44                	je     80100730 <cprintf+0x80>
  if(panicked){
801006ec:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
801006f2:	85 c9                	test   %ecx,%ecx
801006f4:	74 0f                	je     80100705 <cprintf+0x55>
801006f6:	fa                   	cli    
    for(;;)
801006f7:	eb fe                	jmp    801006f7 <cprintf+0x47>
801006f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100700:	b8 25 00 00 00       	mov    $0x25,%eax
80100705:	e8 06 fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010070a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010070d:	83 c6 01             	add    $0x1,%esi
80100710:	0f b6 04 30          	movzbl (%eax,%esi,1),%eax
80100714:	85 c0                	test   %eax,%eax
80100716:	75 cf                	jne    801006e7 <cprintf+0x37>
  if(locking)
80100718:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010071b:	85 c0                	test   %eax,%eax
8010071d:	0f 85 fd 00 00 00    	jne    80100820 <cprintf+0x170>
}
80100723:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100726:	5b                   	pop    %ebx
80100727:	5e                   	pop    %esi
80100728:	5f                   	pop    %edi
80100729:	5d                   	pop    %ebp
8010072a:	c3                   	ret    
8010072b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010072f:	90                   	nop
    c = fmt[++i] & 0xff;
80100730:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100733:	83 c6 01             	add    $0x1,%esi
80100736:	0f b6 3c 30          	movzbl (%eax,%esi,1),%edi
    if(c == 0)
8010073a:	85 ff                	test   %edi,%edi
8010073c:	74 da                	je     80100718 <cprintf+0x68>
    switch(c){
8010073e:	83 ff 70             	cmp    $0x70,%edi
80100741:	74 5a                	je     8010079d <cprintf+0xed>
80100743:	7f 2a                	jg     8010076f <cprintf+0xbf>
80100745:	83 ff 25             	cmp    $0x25,%edi
80100748:	0f 84 92 00 00 00    	je     801007e0 <cprintf+0x130>
8010074e:	83 ff 64             	cmp    $0x64,%edi
80100751:	0f 85 a1 00 00 00    	jne    801007f8 <cprintf+0x148>
      printint(*argp++, 10, 1);
80100757:	8b 03                	mov    (%ebx),%eax
80100759:	8d 7b 04             	lea    0x4(%ebx),%edi
8010075c:	b9 01 00 00 00       	mov    $0x1,%ecx
80100761:	ba 0a 00 00 00       	mov    $0xa,%edx
80100766:	89 fb                	mov    %edi,%ebx
80100768:	e8 33 fe ff ff       	call   801005a0 <printint>
      break;
8010076d:	eb 9b                	jmp    8010070a <cprintf+0x5a>
    switch(c){
8010076f:	83 ff 73             	cmp    $0x73,%edi
80100772:	75 24                	jne    80100798 <cprintf+0xe8>
      if((s = (char*)*argp++) == 0)
80100774:	8d 7b 04             	lea    0x4(%ebx),%edi
80100777:	8b 1b                	mov    (%ebx),%ebx
80100779:	85 db                	test   %ebx,%ebx
8010077b:	75 55                	jne    801007d2 <cprintf+0x122>
        s = "(null)";
8010077d:	bb 98 77 10 80       	mov    $0x80107798,%ebx
      for(; *s; s++)
80100782:	b8 28 00 00 00       	mov    $0x28,%eax
  if(panicked){
80100787:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
8010078d:	85 d2                	test   %edx,%edx
8010078f:	74 39                	je     801007ca <cprintf+0x11a>
80100791:	fa                   	cli    
    for(;;)
80100792:	eb fe                	jmp    80100792 <cprintf+0xe2>
80100794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100798:	83 ff 78             	cmp    $0x78,%edi
8010079b:	75 5b                	jne    801007f8 <cprintf+0x148>
      printint(*argp++, 16, 0);
8010079d:	8b 03                	mov    (%ebx),%eax
8010079f:	8d 7b 04             	lea    0x4(%ebx),%edi
801007a2:	31 c9                	xor    %ecx,%ecx
801007a4:	ba 10 00 00 00       	mov    $0x10,%edx
801007a9:	89 fb                	mov    %edi,%ebx
801007ab:	e8 f0 fd ff ff       	call   801005a0 <printint>
      break;
801007b0:	e9 55 ff ff ff       	jmp    8010070a <cprintf+0x5a>
    acquire(&cons.lock);
801007b5:	83 ec 0c             	sub    $0xc,%esp
801007b8:	68 20 b5 10 80       	push   $0x8010b520
801007bd:	e8 6e 3f 00 00       	call   80104730 <acquire>
801007c2:	83 c4 10             	add    $0x10,%esp
801007c5:	e9 03 ff ff ff       	jmp    801006cd <cprintf+0x1d>
801007ca:	e8 41 fc ff ff       	call   80100410 <consputc.part.0>
      for(; *s; s++)
801007cf:	83 c3 01             	add    $0x1,%ebx
801007d2:	0f be 03             	movsbl (%ebx),%eax
801007d5:	84 c0                	test   %al,%al
801007d7:	75 ae                	jne    80100787 <cprintf+0xd7>
      if((s = (char*)*argp++) == 0)
801007d9:	89 fb                	mov    %edi,%ebx
801007db:	e9 2a ff ff ff       	jmp    8010070a <cprintf+0x5a>
  if(panicked){
801007e0:	8b 3d 58 b5 10 80    	mov    0x8010b558,%edi
801007e6:	85 ff                	test   %edi,%edi
801007e8:	0f 84 12 ff ff ff    	je     80100700 <cprintf+0x50>
801007ee:	fa                   	cli    
    for(;;)
801007ef:	eb fe                	jmp    801007ef <cprintf+0x13f>
801007f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
801007f8:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
801007fe:	85 c9                	test   %ecx,%ecx
80100800:	74 06                	je     80100808 <cprintf+0x158>
80100802:	fa                   	cli    
    for(;;)
80100803:	eb fe                	jmp    80100803 <cprintf+0x153>
80100805:	8d 76 00             	lea    0x0(%esi),%esi
80100808:	b8 25 00 00 00       	mov    $0x25,%eax
8010080d:	e8 fe fb ff ff       	call   80100410 <consputc.part.0>
  if(panicked){
80100812:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
80100818:	85 d2                	test   %edx,%edx
8010081a:	74 2c                	je     80100848 <cprintf+0x198>
8010081c:	fa                   	cli    
    for(;;)
8010081d:	eb fe                	jmp    8010081d <cprintf+0x16d>
8010081f:	90                   	nop
    release(&cons.lock);
80100820:	83 ec 0c             	sub    $0xc,%esp
80100823:	68 20 b5 10 80       	push   $0x8010b520
80100828:	e8 c3 3f 00 00       	call   801047f0 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 ee fe ff ff       	jmp    80100723 <cprintf+0x73>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 9f 77 10 80       	push   $0x8010779f
8010083d:	e8 4e fb ff ff       	call   80100390 <panic>
80100842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100848:	89 f8                	mov    %edi,%eax
8010084a:	e8 c1 fb ff ff       	call   80100410 <consputc.part.0>
8010084f:	e9 b6 fe ff ff       	jmp    8010070a <cprintf+0x5a>
80100854:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010085b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010085f:	90                   	nop

80100860 <consoleintr>:
{
80100860:	f3 0f 1e fb          	endbr32 
80100864:	55                   	push   %ebp
80100865:	89 e5                	mov    %esp,%ebp
80100867:	57                   	push   %edi
80100868:	56                   	push   %esi
  int c, doprocdump = 0;
80100869:	31 f6                	xor    %esi,%esi
{
8010086b:	53                   	push   %ebx
8010086c:	83 ec 18             	sub    $0x18,%esp
8010086f:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
80100872:	68 20 b5 10 80       	push   $0x8010b520
80100877:	e8 b4 3e 00 00       	call   80104730 <acquire>
  while((c = getc()) >= 0){
8010087c:	83 c4 10             	add    $0x10,%esp
8010087f:	eb 17                	jmp    80100898 <consoleintr+0x38>
    switch(c){
80100881:	83 fb 08             	cmp    $0x8,%ebx
80100884:	0f 84 f6 00 00 00    	je     80100980 <consoleintr+0x120>
8010088a:	83 fb 10             	cmp    $0x10,%ebx
8010088d:	0f 85 15 01 00 00    	jne    801009a8 <consoleintr+0x148>
80100893:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
80100898:	ff d7                	call   *%edi
8010089a:	89 c3                	mov    %eax,%ebx
8010089c:	85 c0                	test   %eax,%eax
8010089e:	0f 88 23 01 00 00    	js     801009c7 <consoleintr+0x167>
    switch(c){
801008a4:	83 fb 15             	cmp    $0x15,%ebx
801008a7:	74 77                	je     80100920 <consoleintr+0xc0>
801008a9:	7e d6                	jle    80100881 <consoleintr+0x21>
801008ab:	83 fb 7f             	cmp    $0x7f,%ebx
801008ae:	0f 84 cc 00 00 00    	je     80100980 <consoleintr+0x120>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008b4:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
801008b9:	89 c2                	mov    %eax,%edx
801008bb:	2b 15 a0 0f 11 80    	sub    0x80110fa0,%edx
801008c1:	83 fa 7f             	cmp    $0x7f,%edx
801008c4:	77 d2                	ja     80100898 <consoleintr+0x38>
        c = (c == '\r') ? '\n' : c;
801008c6:	8d 48 01             	lea    0x1(%eax),%ecx
801008c9:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
801008cf:	83 e0 7f             	and    $0x7f,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
801008d2:	89 0d a8 0f 11 80    	mov    %ecx,0x80110fa8
        c = (c == '\r') ? '\n' : c;
801008d8:	83 fb 0d             	cmp    $0xd,%ebx
801008db:	0f 84 02 01 00 00    	je     801009e3 <consoleintr+0x183>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e1:	88 98 20 0f 11 80    	mov    %bl,-0x7feef0e0(%eax)
  if(panicked){
801008e7:	85 d2                	test   %edx,%edx
801008e9:	0f 85 ff 00 00 00    	jne    801009ee <consoleintr+0x18e>
801008ef:	89 d8                	mov    %ebx,%eax
801008f1:	e8 1a fb ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008f6:	83 fb 0a             	cmp    $0xa,%ebx
801008f9:	0f 84 0f 01 00 00    	je     80100a0e <consoleintr+0x1ae>
801008ff:	83 fb 04             	cmp    $0x4,%ebx
80100902:	0f 84 06 01 00 00    	je     80100a0e <consoleintr+0x1ae>
80100908:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
8010090d:	83 e8 80             	sub    $0xffffff80,%eax
80100910:	39 05 a8 0f 11 80    	cmp    %eax,0x80110fa8
80100916:	75 80                	jne    80100898 <consoleintr+0x38>
80100918:	e9 f6 00 00 00       	jmp    80100a13 <consoleintr+0x1b3>
8010091d:	8d 76 00             	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100920:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100925:	39 05 a4 0f 11 80    	cmp    %eax,0x80110fa4
8010092b:	0f 84 67 ff ff ff    	je     80100898 <consoleintr+0x38>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100931:	83 e8 01             	sub    $0x1,%eax
80100934:	89 c2                	mov    %eax,%edx
80100936:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100939:	80 ba 20 0f 11 80 0a 	cmpb   $0xa,-0x7feef0e0(%edx)
80100940:	0f 84 52 ff ff ff    	je     80100898 <consoleintr+0x38>
  if(panicked){
80100946:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
        input.e--;
8010094c:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
  if(panicked){
80100951:	85 d2                	test   %edx,%edx
80100953:	74 0b                	je     80100960 <consoleintr+0x100>
80100955:	fa                   	cli    
    for(;;)
80100956:	eb fe                	jmp    80100956 <consoleintr+0xf6>
80100958:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010095f:	90                   	nop
80100960:	b8 00 01 00 00       	mov    $0x100,%eax
80100965:	e8 a6 fa ff ff       	call   80100410 <consputc.part.0>
      while(input.e != input.w &&
8010096a:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
8010096f:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
80100975:	75 ba                	jne    80100931 <consoleintr+0xd1>
80100977:	e9 1c ff ff ff       	jmp    80100898 <consoleintr+0x38>
8010097c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(input.e != input.w){
80100980:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100985:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
8010098b:	0f 84 07 ff ff ff    	je     80100898 <consoleintr+0x38>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
  if(panicked){
80100999:	a1 58 b5 10 80       	mov    0x8010b558,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 16                	je     801009b8 <consoleintr+0x158>
801009a2:	fa                   	cli    
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x143>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009a8:	85 db                	test   %ebx,%ebx
801009aa:	0f 84 e8 fe ff ff    	je     80100898 <consoleintr+0x38>
801009b0:	e9 ff fe ff ff       	jmp    801008b4 <consoleintr+0x54>
801009b5:	8d 76 00             	lea    0x0(%esi),%esi
801009b8:	b8 00 01 00 00       	mov    $0x100,%eax
801009bd:	e8 4e fa ff ff       	call   80100410 <consputc.part.0>
801009c2:	e9 d1 fe ff ff       	jmp    80100898 <consoleintr+0x38>
  release(&cons.lock);
801009c7:	83 ec 0c             	sub    $0xc,%esp
801009ca:	68 20 b5 10 80       	push   $0x8010b520
801009cf:	e8 1c 3e 00 00       	call   801047f0 <release>
  if(doprocdump) {
801009d4:	83 c4 10             	add    $0x10,%esp
801009d7:	85 f6                	test   %esi,%esi
801009d9:	75 1d                	jne    801009f8 <consoleintr+0x198>
}
801009db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009de:	5b                   	pop    %ebx
801009df:	5e                   	pop    %esi
801009e0:	5f                   	pop    %edi
801009e1:	5d                   	pop    %ebp
801009e2:	c3                   	ret    
        input.buf[input.e++ % INPUT_BUF] = c;
801009e3:	c6 80 20 0f 11 80 0a 	movb   $0xa,-0x7feef0e0(%eax)
  if(panicked){
801009ea:	85 d2                	test   %edx,%edx
801009ec:	74 16                	je     80100a04 <consoleintr+0x1a4>
801009ee:	fa                   	cli    
    for(;;)
801009ef:	eb fe                	jmp    801009ef <consoleintr+0x18f>
801009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
801009f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009fb:	5b                   	pop    %ebx
801009fc:	5e                   	pop    %esi
801009fd:	5f                   	pop    %edi
801009fe:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
801009ff:	e9 9c 39 00 00       	jmp    801043a0 <procdump>
80100a04:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a09:	e8 02 fa ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100a0e:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
          wakeup(&input.r);
80100a13:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a16:	a3 a4 0f 11 80       	mov    %eax,0x80110fa4
          wakeup(&input.r);
80100a1b:	68 a0 0f 11 80       	push   $0x80110fa0
80100a20:	e8 8b 38 00 00       	call   801042b0 <wakeup>
80100a25:	83 c4 10             	add    $0x10,%esp
80100a28:	e9 6b fe ff ff       	jmp    80100898 <consoleintr+0x38>
80100a2d:	8d 76 00             	lea    0x0(%esi),%esi

80100a30 <consoleinit>:

void
consoleinit(void)
{
80100a30:	f3 0f 1e fb          	endbr32 
80100a34:	55                   	push   %ebp
80100a35:	89 e5                	mov    %esp,%ebp
80100a37:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a3a:	68 a8 77 10 80       	push   $0x801077a8
80100a3f:	68 20 b5 10 80       	push   $0x8010b520
80100a44:	e8 67 3b 00 00       	call   801045b0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a49:	58                   	pop    %eax
80100a4a:	5a                   	pop    %edx
80100a4b:	6a 00                	push   $0x0
80100a4d:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a4f:	c7 05 6c 19 11 80 40 	movl   $0x80100640,0x8011196c
80100a56:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100a59:	c7 05 68 19 11 80 90 	movl   $0x80100290,0x80111968
80100a60:	02 10 80 
  cons.locking = 1;
80100a63:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
80100a6a:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a6d:	e8 be 19 00 00       	call   80102430 <ioapicenable>
}
80100a72:	83 c4 10             	add    $0x10,%esp
80100a75:	c9                   	leave  
80100a76:	c3                   	ret    
80100a77:	66 90                	xchg   %ax,%ax
80100a79:	66 90                	xchg   %ax,%ax
80100a7b:	66 90                	xchg   %ax,%ax
80100a7d:	66 90                	xchg   %ax,%ax
80100a7f:	90                   	nop

80100a80 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a80:	f3 0f 1e fb          	endbr32 
80100a84:	55                   	push   %ebp
80100a85:	89 e5                	mov    %esp,%ebp
80100a87:	57                   	push   %edi
80100a88:	56                   	push   %esi
80100a89:	53                   	push   %ebx
80100a8a:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a90:	e8 1b 2f 00 00       	call   801039b0 <myproc>
80100a95:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100a9b:	e8 f0 22 00 00       	call   80102d90 <begin_op>

  if((ip = namei(path)) == 0){
80100aa0:	83 ec 0c             	sub    $0xc,%esp
80100aa3:	ff 75 08             	pushl  0x8(%ebp)
80100aa6:	e8 85 15 00 00       	call   80102030 <namei>
80100aab:	83 c4 10             	add    $0x10,%esp
80100aae:	85 c0                	test   %eax,%eax
80100ab0:	0f 84 fe 02 00 00    	je     80100db4 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ab6:	83 ec 0c             	sub    $0xc,%esp
80100ab9:	89 c3                	mov    %eax,%ebx
80100abb:	50                   	push   %eax
80100abc:	e8 9f 0c 00 00       	call   80101760 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100ac1:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100ac7:	6a 34                	push   $0x34
80100ac9:	6a 00                	push   $0x0
80100acb:	50                   	push   %eax
80100acc:	53                   	push   %ebx
80100acd:	e8 8e 0f 00 00       	call   80101a60 <readi>
80100ad2:	83 c4 20             	add    $0x20,%esp
80100ad5:	83 f8 34             	cmp    $0x34,%eax
80100ad8:	74 26                	je     80100b00 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100ada:	83 ec 0c             	sub    $0xc,%esp
80100add:	53                   	push   %ebx
80100ade:	e8 1d 0f 00 00       	call   80101a00 <iunlockput>
    end_op();
80100ae3:	e8 18 23 00 00       	call   80102e00 <end_op>
80100ae8:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100aeb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100af0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100af3:	5b                   	pop    %ebx
80100af4:	5e                   	pop    %esi
80100af5:	5f                   	pop    %edi
80100af6:	5d                   	pop    %ebp
80100af7:	c3                   	ret    
80100af8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100aff:	90                   	nop
  if(elf.magic != ELF_MAGIC)
80100b00:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b07:	45 4c 46 
80100b0a:	75 ce                	jne    80100ada <exec+0x5a>
  if((pgdir = setupkvm()) == 0)
80100b0c:	e8 2f 66 00 00       	call   80107140 <setupkvm>
80100b11:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b17:	85 c0                	test   %eax,%eax
80100b19:	74 bf                	je     80100ada <exec+0x5a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b1b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b22:	00 
80100b23:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b29:	0f 84 a4 02 00 00    	je     80100dd3 <exec+0x353>
  sz = 0;
80100b2f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b36:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b39:	31 ff                	xor    %edi,%edi
80100b3b:	e9 86 00 00 00       	jmp    80100bc6 <exec+0x146>
    if(ph.type != ELF_PROG_LOAD)
80100b40:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b47:	75 6c                	jne    80100bb5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100b49:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b4f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b55:	0f 82 87 00 00 00    	jb     80100be2 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b5b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b61:	72 7f                	jb     80100be2 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b63:	83 ec 04             	sub    $0x4,%esp
80100b66:	50                   	push   %eax
80100b67:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b6d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b73:	e8 98 63 00 00       	call   80106f10 <allocuvm>
80100b78:	83 c4 10             	add    $0x10,%esp
80100b7b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b81:	85 c0                	test   %eax,%eax
80100b83:	74 5d                	je     80100be2 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100b85:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b8b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b90:	75 50                	jne    80100be2 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b92:	83 ec 0c             	sub    $0xc,%esp
80100b95:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b9b:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100ba1:	53                   	push   %ebx
80100ba2:	50                   	push   %eax
80100ba3:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ba9:	e8 92 62 00 00       	call   80106e40 <loaduvm>
80100bae:	83 c4 20             	add    $0x20,%esp
80100bb1:	85 c0                	test   %eax,%eax
80100bb3:	78 2d                	js     80100be2 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bb5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bbc:	83 c7 01             	add    $0x1,%edi
80100bbf:	83 c6 20             	add    $0x20,%esi
80100bc2:	39 f8                	cmp    %edi,%eax
80100bc4:	7e 3a                	jle    80100c00 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bc6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bcc:	6a 20                	push   $0x20
80100bce:	56                   	push   %esi
80100bcf:	50                   	push   %eax
80100bd0:	53                   	push   %ebx
80100bd1:	e8 8a 0e 00 00       	call   80101a60 <readi>
80100bd6:	83 c4 10             	add    $0x10,%esp
80100bd9:	83 f8 20             	cmp    $0x20,%eax
80100bdc:	0f 84 5e ff ff ff    	je     80100b40 <exec+0xc0>
    freevm(pgdir);
80100be2:	83 ec 0c             	sub    $0xc,%esp
80100be5:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100beb:	e8 d0 64 00 00       	call   801070c0 <freevm>
  if(ip){
80100bf0:	83 c4 10             	add    $0x10,%esp
80100bf3:	e9 e2 fe ff ff       	jmp    80100ada <exec+0x5a>
80100bf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100bff:	90                   	nop
80100c00:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c06:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c0c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100c12:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c18:	83 ec 0c             	sub    $0xc,%esp
80100c1b:	53                   	push   %ebx
80100c1c:	e8 df 0d 00 00       	call   80101a00 <iunlockput>
  end_op();
80100c21:	e8 da 21 00 00       	call   80102e00 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c26:	83 c4 0c             	add    $0xc,%esp
80100c29:	56                   	push   %esi
80100c2a:	57                   	push   %edi
80100c2b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c31:	57                   	push   %edi
80100c32:	e8 d9 62 00 00       	call   80106f10 <allocuvm>
80100c37:	83 c4 10             	add    $0x10,%esp
80100c3a:	89 c6                	mov    %eax,%esi
80100c3c:	85 c0                	test   %eax,%eax
80100c3e:	0f 84 94 00 00 00    	je     80100cd8 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c44:	83 ec 08             	sub    $0x8,%esp
80100c47:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c4d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c4f:	50                   	push   %eax
80100c50:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c51:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c53:	e8 88 65 00 00       	call   801071e0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c58:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c5b:	83 c4 10             	add    $0x10,%esp
80100c5e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c64:	8b 00                	mov    (%eax),%eax
80100c66:	85 c0                	test   %eax,%eax
80100c68:	0f 84 8b 00 00 00    	je     80100cf9 <exec+0x279>
80100c6e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100c74:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c7a:	eb 23                	jmp    80100c9f <exec+0x21f>
80100c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100c80:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c83:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c8a:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c8d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c93:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c96:	85 c0                	test   %eax,%eax
80100c98:	74 59                	je     80100cf3 <exec+0x273>
    if(argc >= MAXARG)
80100c9a:	83 ff 20             	cmp    $0x20,%edi
80100c9d:	74 39                	je     80100cd8 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c9f:	83 ec 0c             	sub    $0xc,%esp
80100ca2:	50                   	push   %eax
80100ca3:	e8 98 3d 00 00       	call   80104a40 <strlen>
80100ca8:	f7 d0                	not    %eax
80100caa:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cac:	58                   	pop    %eax
80100cad:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cb0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cb3:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cb6:	e8 85 3d 00 00       	call   80104a40 <strlen>
80100cbb:	83 c0 01             	add    $0x1,%eax
80100cbe:	50                   	push   %eax
80100cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cc2:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cc5:	53                   	push   %ebx
80100cc6:	56                   	push   %esi
80100cc7:	e8 94 66 00 00       	call   80107360 <copyout>
80100ccc:	83 c4 20             	add    $0x20,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	79 ad                	jns    80100c80 <exec+0x200>
80100cd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cd7:	90                   	nop
    freevm(pgdir);
80100cd8:	83 ec 0c             	sub    $0xc,%esp
80100cdb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ce1:	e8 da 63 00 00       	call   801070c0 <freevm>
80100ce6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100ce9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100cee:	e9 fd fd ff ff       	jmp    80100af0 <exec+0x70>
80100cf3:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cf9:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d00:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d02:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d09:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d0d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d0f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d12:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d18:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d1a:	50                   	push   %eax
80100d1b:	52                   	push   %edx
80100d1c:	53                   	push   %ebx
80100d1d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d23:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d2a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d2d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d33:	e8 28 66 00 00       	call   80107360 <copyout>
80100d38:	83 c4 10             	add    $0x10,%esp
80100d3b:	85 c0                	test   %eax,%eax
80100d3d:	78 99                	js     80100cd8 <exec+0x258>
  for(last=s=path; *s; s++)
80100d3f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d42:	8b 55 08             	mov    0x8(%ebp),%edx
80100d45:	0f b6 00             	movzbl (%eax),%eax
80100d48:	84 c0                	test   %al,%al
80100d4a:	74 13                	je     80100d5f <exec+0x2df>
80100d4c:	89 d1                	mov    %edx,%ecx
80100d4e:	66 90                	xchg   %ax,%ax
    if(*s == '/')
80100d50:	83 c1 01             	add    $0x1,%ecx
80100d53:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d55:	0f b6 01             	movzbl (%ecx),%eax
    if(*s == '/')
80100d58:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d5b:	84 c0                	test   %al,%al
80100d5d:	75 f1                	jne    80100d50 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d5f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d65:	83 ec 04             	sub    $0x4,%esp
80100d68:	6a 10                	push   $0x10
80100d6a:	89 f8                	mov    %edi,%eax
80100d6c:	52                   	push   %edx
80100d6d:	83 c0 70             	add    $0x70,%eax
80100d70:	50                   	push   %eax
80100d71:	e8 8a 3c 00 00       	call   80104a00 <safestrcpy>
  curproc->pgdir = pgdir;
80100d76:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100d7c:	89 f8                	mov    %edi,%eax
80100d7e:	8b 7f 08             	mov    0x8(%edi),%edi
  curproc->sz = sz;
80100d81:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100d83:	89 48 08             	mov    %ecx,0x8(%eax)
  curproc->tf->eip = elf.entry;  // main
80100d86:	89 c1                	mov    %eax,%ecx
80100d88:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d8e:	8b 40 1c             	mov    0x1c(%eax),%eax
80100d91:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d94:	8b 41 1c             	mov    0x1c(%ecx),%eax
80100d97:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d9a:	89 0c 24             	mov    %ecx,(%esp)
80100d9d:	e8 ce 5e 00 00       	call   80106c70 <switchuvm>
  freevm(oldpgdir);
80100da2:	89 3c 24             	mov    %edi,(%esp)
80100da5:	e8 16 63 00 00       	call   801070c0 <freevm>
  return 0;
80100daa:	83 c4 10             	add    $0x10,%esp
80100dad:	31 c0                	xor    %eax,%eax
80100daf:	e9 3c fd ff ff       	jmp    80100af0 <exec+0x70>
    end_op();
80100db4:	e8 47 20 00 00       	call   80102e00 <end_op>
    cprintf("exec: fail\n");
80100db9:	83 ec 0c             	sub    $0xc,%esp
80100dbc:	68 c1 77 10 80       	push   $0x801077c1
80100dc1:	e8 ea f8 ff ff       	call   801006b0 <cprintf>
    return -1;
80100dc6:	83 c4 10             	add    $0x10,%esp
80100dc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dce:	e9 1d fd ff ff       	jmp    80100af0 <exec+0x70>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100dd3:	31 ff                	xor    %edi,%edi
80100dd5:	be 00 20 00 00       	mov    $0x2000,%esi
80100dda:	e9 39 fe ff ff       	jmp    80100c18 <exec+0x198>
80100ddf:	90                   	nop

80100de0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100de0:	f3 0f 1e fb          	endbr32 
80100de4:	55                   	push   %ebp
80100de5:	89 e5                	mov    %esp,%ebp
80100de7:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100dea:	68 cd 77 10 80       	push   $0x801077cd
80100def:	68 c0 0f 11 80       	push   $0x80110fc0
80100df4:	e8 b7 37 00 00       	call   801045b0 <initlock>
}
80100df9:	83 c4 10             	add    $0x10,%esp
80100dfc:	c9                   	leave  
80100dfd:	c3                   	ret    
80100dfe:	66 90                	xchg   %ax,%ax

80100e00 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e00:	f3 0f 1e fb          	endbr32 
80100e04:	55                   	push   %ebp
80100e05:	89 e5                	mov    %esp,%ebp
80100e07:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e08:	bb f4 0f 11 80       	mov    $0x80110ff4,%ebx
{
80100e0d:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e10:	68 c0 0f 11 80       	push   $0x80110fc0
80100e15:	e8 16 39 00 00       	call   80104730 <acquire>
80100e1a:	83 c4 10             	add    $0x10,%esp
80100e1d:	eb 0c                	jmp    80100e2b <filealloc+0x2b>
80100e1f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e20:	83 c3 18             	add    $0x18,%ebx
80100e23:	81 fb 54 19 11 80    	cmp    $0x80111954,%ebx
80100e29:	74 25                	je     80100e50 <filealloc+0x50>
    if(f->ref == 0){
80100e2b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e2e:	85 c0                	test   %eax,%eax
80100e30:	75 ee                	jne    80100e20 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e32:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e35:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e3c:	68 c0 0f 11 80       	push   $0x80110fc0
80100e41:	e8 aa 39 00 00       	call   801047f0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e46:	89 d8                	mov    %ebx,%eax
      return f;
80100e48:	83 c4 10             	add    $0x10,%esp
}
80100e4b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e4e:	c9                   	leave  
80100e4f:	c3                   	ret    
  release(&ftable.lock);
80100e50:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e53:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e55:	68 c0 0f 11 80       	push   $0x80110fc0
80100e5a:	e8 91 39 00 00       	call   801047f0 <release>
}
80100e5f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e61:	83 c4 10             	add    $0x10,%esp
}
80100e64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e67:	c9                   	leave  
80100e68:	c3                   	ret    
80100e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e70 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e70:	f3 0f 1e fb          	endbr32 
80100e74:	55                   	push   %ebp
80100e75:	89 e5                	mov    %esp,%ebp
80100e77:	53                   	push   %ebx
80100e78:	83 ec 10             	sub    $0x10,%esp
80100e7b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e7e:	68 c0 0f 11 80       	push   $0x80110fc0
80100e83:	e8 a8 38 00 00       	call   80104730 <acquire>
  if(f->ref < 1)
80100e88:	8b 43 04             	mov    0x4(%ebx),%eax
80100e8b:	83 c4 10             	add    $0x10,%esp
80100e8e:	85 c0                	test   %eax,%eax
80100e90:	7e 1a                	jle    80100eac <filedup+0x3c>
    panic("filedup");
  f->ref++;
80100e92:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e95:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e98:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e9b:	68 c0 0f 11 80       	push   $0x80110fc0
80100ea0:	e8 4b 39 00 00       	call   801047f0 <release>
  return f;
}
80100ea5:	89 d8                	mov    %ebx,%eax
80100ea7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eaa:	c9                   	leave  
80100eab:	c3                   	ret    
    panic("filedup");
80100eac:	83 ec 0c             	sub    $0xc,%esp
80100eaf:	68 d4 77 10 80       	push   $0x801077d4
80100eb4:	e8 d7 f4 ff ff       	call   80100390 <panic>
80100eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ec0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ec0:	f3 0f 1e fb          	endbr32 
80100ec4:	55                   	push   %ebp
80100ec5:	89 e5                	mov    %esp,%ebp
80100ec7:	57                   	push   %edi
80100ec8:	56                   	push   %esi
80100ec9:	53                   	push   %ebx
80100eca:	83 ec 28             	sub    $0x28,%esp
80100ecd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100ed0:	68 c0 0f 11 80       	push   $0x80110fc0
80100ed5:	e8 56 38 00 00       	call   80104730 <acquire>
  if(f->ref < 1)
80100eda:	8b 53 04             	mov    0x4(%ebx),%edx
80100edd:	83 c4 10             	add    $0x10,%esp
80100ee0:	85 d2                	test   %edx,%edx
80100ee2:	0f 8e a1 00 00 00    	jle    80100f89 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100ee8:	83 ea 01             	sub    $0x1,%edx
80100eeb:	89 53 04             	mov    %edx,0x4(%ebx)
80100eee:	75 40                	jne    80100f30 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100ef0:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100ef4:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100ef7:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100ef9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100eff:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f02:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f05:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f08:	68 c0 0f 11 80       	push   $0x80110fc0
  ff = *f;
80100f0d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f10:	e8 db 38 00 00       	call   801047f0 <release>

  if(ff.type == FD_PIPE)
80100f15:	83 c4 10             	add    $0x10,%esp
80100f18:	83 ff 01             	cmp    $0x1,%edi
80100f1b:	74 53                	je     80100f70 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f1d:	83 ff 02             	cmp    $0x2,%edi
80100f20:	74 26                	je     80100f48 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f22:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f25:	5b                   	pop    %ebx
80100f26:	5e                   	pop    %esi
80100f27:	5f                   	pop    %edi
80100f28:	5d                   	pop    %ebp
80100f29:	c3                   	ret    
80100f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f30:	c7 45 08 c0 0f 11 80 	movl   $0x80110fc0,0x8(%ebp)
}
80100f37:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f3a:	5b                   	pop    %ebx
80100f3b:	5e                   	pop    %esi
80100f3c:	5f                   	pop    %edi
80100f3d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f3e:	e9 ad 38 00 00       	jmp    801047f0 <release>
80100f43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f47:	90                   	nop
    begin_op();
80100f48:	e8 43 1e 00 00       	call   80102d90 <begin_op>
    iput(ff.ip);
80100f4d:	83 ec 0c             	sub    $0xc,%esp
80100f50:	ff 75 e0             	pushl  -0x20(%ebp)
80100f53:	e8 38 09 00 00       	call   80101890 <iput>
    end_op();
80100f58:	83 c4 10             	add    $0x10,%esp
}
80100f5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f5e:	5b                   	pop    %ebx
80100f5f:	5e                   	pop    %esi
80100f60:	5f                   	pop    %edi
80100f61:	5d                   	pop    %ebp
    end_op();
80100f62:	e9 99 1e 00 00       	jmp    80102e00 <end_op>
80100f67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f6e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100f70:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f74:	83 ec 08             	sub    $0x8,%esp
80100f77:	53                   	push   %ebx
80100f78:	56                   	push   %esi
80100f79:	e8 e2 25 00 00       	call   80103560 <pipeclose>
80100f7e:	83 c4 10             	add    $0x10,%esp
}
80100f81:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f84:	5b                   	pop    %ebx
80100f85:	5e                   	pop    %esi
80100f86:	5f                   	pop    %edi
80100f87:	5d                   	pop    %ebp
80100f88:	c3                   	ret    
    panic("fileclose");
80100f89:	83 ec 0c             	sub    $0xc,%esp
80100f8c:	68 dc 77 10 80       	push   $0x801077dc
80100f91:	e8 fa f3 ff ff       	call   80100390 <panic>
80100f96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f9d:	8d 76 00             	lea    0x0(%esi),%esi

80100fa0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fa0:	f3 0f 1e fb          	endbr32 
80100fa4:	55                   	push   %ebp
80100fa5:	89 e5                	mov    %esp,%ebp
80100fa7:	53                   	push   %ebx
80100fa8:	83 ec 04             	sub    $0x4,%esp
80100fab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fae:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fb1:	75 2d                	jne    80100fe0 <filestat+0x40>
    ilock(f->ip);
80100fb3:	83 ec 0c             	sub    $0xc,%esp
80100fb6:	ff 73 10             	pushl  0x10(%ebx)
80100fb9:	e8 a2 07 00 00       	call   80101760 <ilock>
    stati(f->ip, st);
80100fbe:	58                   	pop    %eax
80100fbf:	5a                   	pop    %edx
80100fc0:	ff 75 0c             	pushl  0xc(%ebp)
80100fc3:	ff 73 10             	pushl  0x10(%ebx)
80100fc6:	e8 65 0a 00 00       	call   80101a30 <stati>
    iunlock(f->ip);
80100fcb:	59                   	pop    %ecx
80100fcc:	ff 73 10             	pushl  0x10(%ebx)
80100fcf:	e8 6c 08 00 00       	call   80101840 <iunlock>
    return 0;
  }
  return -1;
}
80100fd4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80100fd7:	83 c4 10             	add    $0x10,%esp
80100fda:	31 c0                	xor    %eax,%eax
}
80100fdc:	c9                   	leave  
80100fdd:	c3                   	ret    
80100fde:	66 90                	xchg   %ax,%ax
80100fe0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80100fe3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100fe8:	c9                   	leave  
80100fe9:	c3                   	ret    
80100fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100ff0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100ff0:	f3 0f 1e fb          	endbr32 
80100ff4:	55                   	push   %ebp
80100ff5:	89 e5                	mov    %esp,%ebp
80100ff7:	57                   	push   %edi
80100ff8:	56                   	push   %esi
80100ff9:	53                   	push   %ebx
80100ffa:	83 ec 0c             	sub    $0xc,%esp
80100ffd:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101000:	8b 75 0c             	mov    0xc(%ebp),%esi
80101003:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101006:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
8010100a:	74 64                	je     80101070 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
8010100c:	8b 03                	mov    (%ebx),%eax
8010100e:	83 f8 01             	cmp    $0x1,%eax
80101011:	74 45                	je     80101058 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101013:	83 f8 02             	cmp    $0x2,%eax
80101016:	75 5f                	jne    80101077 <fileread+0x87>
    ilock(f->ip);
80101018:	83 ec 0c             	sub    $0xc,%esp
8010101b:	ff 73 10             	pushl  0x10(%ebx)
8010101e:	e8 3d 07 00 00       	call   80101760 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101023:	57                   	push   %edi
80101024:	ff 73 14             	pushl  0x14(%ebx)
80101027:	56                   	push   %esi
80101028:	ff 73 10             	pushl  0x10(%ebx)
8010102b:	e8 30 0a 00 00       	call   80101a60 <readi>
80101030:	83 c4 20             	add    $0x20,%esp
80101033:	89 c6                	mov    %eax,%esi
80101035:	85 c0                	test   %eax,%eax
80101037:	7e 03                	jle    8010103c <fileread+0x4c>
      f->off += r;
80101039:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
8010103c:	83 ec 0c             	sub    $0xc,%esp
8010103f:	ff 73 10             	pushl  0x10(%ebx)
80101042:	e8 f9 07 00 00       	call   80101840 <iunlock>
    return r;
80101047:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
8010104a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010104d:	89 f0                	mov    %esi,%eax
8010104f:	5b                   	pop    %ebx
80101050:	5e                   	pop    %esi
80101051:	5f                   	pop    %edi
80101052:	5d                   	pop    %ebp
80101053:	c3                   	ret    
80101054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return piperead(f->pipe, addr, n);
80101058:	8b 43 0c             	mov    0xc(%ebx),%eax
8010105b:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010105e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101061:	5b                   	pop    %ebx
80101062:	5e                   	pop    %esi
80101063:	5f                   	pop    %edi
80101064:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80101065:	e9 96 26 00 00       	jmp    80103700 <piperead>
8010106a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101070:	be ff ff ff ff       	mov    $0xffffffff,%esi
80101075:	eb d3                	jmp    8010104a <fileread+0x5a>
  panic("fileread");
80101077:	83 ec 0c             	sub    $0xc,%esp
8010107a:	68 e6 77 10 80       	push   $0x801077e6
8010107f:	e8 0c f3 ff ff       	call   80100390 <panic>
80101084:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010108b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010108f:	90                   	nop

80101090 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101090:	f3 0f 1e fb          	endbr32 
80101094:	55                   	push   %ebp
80101095:	89 e5                	mov    %esp,%ebp
80101097:	57                   	push   %edi
80101098:	56                   	push   %esi
80101099:	53                   	push   %ebx
8010109a:	83 ec 1c             	sub    $0x1c,%esp
8010109d:	8b 45 0c             	mov    0xc(%ebp),%eax
801010a0:	8b 75 08             	mov    0x8(%ebp),%esi
801010a3:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010a6:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010a9:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
801010ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010b0:	0f 84 c1 00 00 00    	je     80101177 <filewrite+0xe7>
    return -1;
  if(f->type == FD_PIPE)
801010b6:	8b 06                	mov    (%esi),%eax
801010b8:	83 f8 01             	cmp    $0x1,%eax
801010bb:	0f 84 c3 00 00 00    	je     80101184 <filewrite+0xf4>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010c1:	83 f8 02             	cmp    $0x2,%eax
801010c4:	0f 85 cc 00 00 00    	jne    80101196 <filewrite+0x106>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010cd:	31 ff                	xor    %edi,%edi
    while(i < n){
801010cf:	85 c0                	test   %eax,%eax
801010d1:	7f 34                	jg     80101107 <filewrite+0x77>
801010d3:	e9 98 00 00 00       	jmp    80101170 <filewrite+0xe0>
801010d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010df:	90                   	nop
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010e0:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
801010e3:	83 ec 0c             	sub    $0xc,%esp
801010e6:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
801010e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801010ec:	e8 4f 07 00 00       	call   80101840 <iunlock>
      end_op();
801010f1:	e8 0a 1d 00 00       	call   80102e00 <end_op>

      if(r < 0)
        break;
      if(r != n1)
801010f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010f9:	83 c4 10             	add    $0x10,%esp
801010fc:	39 c3                	cmp    %eax,%ebx
801010fe:	75 60                	jne    80101160 <filewrite+0xd0>
        panic("short filewrite");
      i += r;
80101100:	01 df                	add    %ebx,%edi
    while(i < n){
80101102:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101105:	7e 69                	jle    80101170 <filewrite+0xe0>
      int n1 = n - i;
80101107:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010110a:	b8 00 06 00 00       	mov    $0x600,%eax
8010110f:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
80101111:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101117:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
8010111a:	e8 71 1c 00 00       	call   80102d90 <begin_op>
      ilock(f->ip);
8010111f:	83 ec 0c             	sub    $0xc,%esp
80101122:	ff 76 10             	pushl  0x10(%esi)
80101125:	e8 36 06 00 00       	call   80101760 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010112a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010112d:	53                   	push   %ebx
8010112e:	ff 76 14             	pushl  0x14(%esi)
80101131:	01 f8                	add    %edi,%eax
80101133:	50                   	push   %eax
80101134:	ff 76 10             	pushl  0x10(%esi)
80101137:	e8 24 0a 00 00       	call   80101b60 <writei>
8010113c:	83 c4 20             	add    $0x20,%esp
8010113f:	85 c0                	test   %eax,%eax
80101141:	7f 9d                	jg     801010e0 <filewrite+0x50>
      iunlock(f->ip);
80101143:	83 ec 0c             	sub    $0xc,%esp
80101146:	ff 76 10             	pushl  0x10(%esi)
80101149:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010114c:	e8 ef 06 00 00       	call   80101840 <iunlock>
      end_op();
80101151:	e8 aa 1c 00 00       	call   80102e00 <end_op>
      if(r < 0)
80101156:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101159:	83 c4 10             	add    $0x10,%esp
8010115c:	85 c0                	test   %eax,%eax
8010115e:	75 17                	jne    80101177 <filewrite+0xe7>
        panic("short filewrite");
80101160:	83 ec 0c             	sub    $0xc,%esp
80101163:	68 ef 77 10 80       	push   $0x801077ef
80101168:	e8 23 f2 ff ff       	call   80100390 <panic>
8010116d:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
80101170:	89 f8                	mov    %edi,%eax
80101172:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80101175:	74 05                	je     8010117c <filewrite+0xec>
80101177:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
8010117c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010117f:	5b                   	pop    %ebx
80101180:	5e                   	pop    %esi
80101181:	5f                   	pop    %edi
80101182:	5d                   	pop    %ebp
80101183:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
80101184:	8b 46 0c             	mov    0xc(%esi),%eax
80101187:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010118a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010118d:	5b                   	pop    %ebx
8010118e:	5e                   	pop    %esi
8010118f:	5f                   	pop    %edi
80101190:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101191:	e9 6a 24 00 00       	jmp    80103600 <pipewrite>
  panic("filewrite");
80101196:	83 ec 0c             	sub    $0xc,%esp
80101199:	68 f5 77 10 80       	push   $0x801077f5
8010119e:	e8 ed f1 ff ff       	call   80100390 <panic>
801011a3:	66 90                	xchg   %ax,%ax
801011a5:	66 90                	xchg   %ax,%ax
801011a7:	66 90                	xchg   %ax,%ax
801011a9:	66 90                	xchg   %ax,%ax
801011ab:	66 90                	xchg   %ax,%ax
801011ad:	66 90                	xchg   %ax,%ax
801011af:	90                   	nop

801011b0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801011b0:	55                   	push   %ebp
801011b1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801011b3:	89 d0                	mov    %edx,%eax
801011b5:	c1 e8 0c             	shr    $0xc,%eax
801011b8:	03 05 d8 19 11 80    	add    0x801119d8,%eax
{
801011be:	89 e5                	mov    %esp,%ebp
801011c0:	56                   	push   %esi
801011c1:	53                   	push   %ebx
801011c2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801011c4:	83 ec 08             	sub    $0x8,%esp
801011c7:	50                   	push   %eax
801011c8:	51                   	push   %ecx
801011c9:	e8 02 ef ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801011ce:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801011d0:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801011d3:	ba 01 00 00 00       	mov    $0x1,%edx
801011d8:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801011db:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801011e1:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
801011e4:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
801011e6:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
801011eb:	85 d1                	test   %edx,%ecx
801011ed:	74 25                	je     80101214 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801011ef:	f7 d2                	not    %edx
  log_write(bp);
801011f1:	83 ec 0c             	sub    $0xc,%esp
801011f4:	89 c6                	mov    %eax,%esi
  bp->data[bi/8] &= ~m;
801011f6:	21 ca                	and    %ecx,%edx
801011f8:	88 54 18 5c          	mov    %dl,0x5c(%eax,%ebx,1)
  log_write(bp);
801011fc:	50                   	push   %eax
801011fd:	e8 6e 1d 00 00       	call   80102f70 <log_write>
  brelse(bp);
80101202:	89 34 24             	mov    %esi,(%esp)
80101205:	e8 e6 ef ff ff       	call   801001f0 <brelse>
}
8010120a:	83 c4 10             	add    $0x10,%esp
8010120d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101210:	5b                   	pop    %ebx
80101211:	5e                   	pop    %esi
80101212:	5d                   	pop    %ebp
80101213:	c3                   	ret    
    panic("freeing free block");
80101214:	83 ec 0c             	sub    $0xc,%esp
80101217:	68 ff 77 10 80       	push   $0x801077ff
8010121c:	e8 6f f1 ff ff       	call   80100390 <panic>
80101221:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101228:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010122f:	90                   	nop

80101230 <balloc>:
{
80101230:	55                   	push   %ebp
80101231:	89 e5                	mov    %esp,%ebp
80101233:	57                   	push   %edi
80101234:	56                   	push   %esi
80101235:	53                   	push   %ebx
80101236:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101239:	8b 0d c0 19 11 80    	mov    0x801119c0,%ecx
{
8010123f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101242:	85 c9                	test   %ecx,%ecx
80101244:	0f 84 87 00 00 00    	je     801012d1 <balloc+0xa1>
8010124a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101251:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101254:	83 ec 08             	sub    $0x8,%esp
80101257:	89 f0                	mov    %esi,%eax
80101259:	c1 f8 0c             	sar    $0xc,%eax
8010125c:	03 05 d8 19 11 80    	add    0x801119d8,%eax
80101262:	50                   	push   %eax
80101263:	ff 75 d8             	pushl  -0x28(%ebp)
80101266:	e8 65 ee ff ff       	call   801000d0 <bread>
8010126b:	83 c4 10             	add    $0x10,%esp
8010126e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101271:	a1 c0 19 11 80       	mov    0x801119c0,%eax
80101276:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101279:	31 c0                	xor    %eax,%eax
8010127b:	eb 2f                	jmp    801012ac <balloc+0x7c>
8010127d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101280:	89 c1                	mov    %eax,%ecx
80101282:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101287:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010128a:	83 e1 07             	and    $0x7,%ecx
8010128d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010128f:	89 c1                	mov    %eax,%ecx
80101291:	c1 f9 03             	sar    $0x3,%ecx
80101294:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101299:	89 fa                	mov    %edi,%edx
8010129b:	85 df                	test   %ebx,%edi
8010129d:	74 41                	je     801012e0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010129f:	83 c0 01             	add    $0x1,%eax
801012a2:	83 c6 01             	add    $0x1,%esi
801012a5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012aa:	74 05                	je     801012b1 <balloc+0x81>
801012ac:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012af:	77 cf                	ja     80101280 <balloc+0x50>
    brelse(bp);
801012b1:	83 ec 0c             	sub    $0xc,%esp
801012b4:	ff 75 e4             	pushl  -0x1c(%ebp)
801012b7:	e8 34 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012bc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012c3:	83 c4 10             	add    $0x10,%esp
801012c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012c9:	39 05 c0 19 11 80    	cmp    %eax,0x801119c0
801012cf:	77 80                	ja     80101251 <balloc+0x21>
  panic("balloc: out of blocks");
801012d1:	83 ec 0c             	sub    $0xc,%esp
801012d4:	68 12 78 10 80       	push   $0x80107812
801012d9:	e8 b2 f0 ff ff       	call   80100390 <panic>
801012de:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801012e0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801012e3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801012e6:	09 da                	or     %ebx,%edx
801012e8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012ec:	57                   	push   %edi
801012ed:	e8 7e 1c 00 00       	call   80102f70 <log_write>
        brelse(bp);
801012f2:	89 3c 24             	mov    %edi,(%esp)
801012f5:	e8 f6 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
801012fa:	58                   	pop    %eax
801012fb:	5a                   	pop    %edx
801012fc:	56                   	push   %esi
801012fd:	ff 75 d8             	pushl  -0x28(%ebp)
80101300:	e8 cb ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101305:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101308:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010130a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010130d:	68 00 02 00 00       	push   $0x200
80101312:	6a 00                	push   $0x0
80101314:	50                   	push   %eax
80101315:	e8 26 35 00 00       	call   80104840 <memset>
  log_write(bp);
8010131a:	89 1c 24             	mov    %ebx,(%esp)
8010131d:	e8 4e 1c 00 00       	call   80102f70 <log_write>
  brelse(bp);
80101322:	89 1c 24             	mov    %ebx,(%esp)
80101325:	e8 c6 ee ff ff       	call   801001f0 <brelse>
}
8010132a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010132d:	89 f0                	mov    %esi,%eax
8010132f:	5b                   	pop    %ebx
80101330:	5e                   	pop    %esi
80101331:	5f                   	pop    %edi
80101332:	5d                   	pop    %ebp
80101333:	c3                   	ret    
80101334:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010133b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010133f:	90                   	nop

80101340 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101340:	55                   	push   %ebp
80101341:	89 e5                	mov    %esp,%ebp
80101343:	57                   	push   %edi
80101344:	89 c7                	mov    %eax,%edi
80101346:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101347:	31 f6                	xor    %esi,%esi
{
80101349:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010134a:	bb 14 1a 11 80       	mov    $0x80111a14,%ebx
{
8010134f:	83 ec 28             	sub    $0x28,%esp
80101352:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101355:	68 e0 19 11 80       	push   $0x801119e0
8010135a:	e8 d1 33 00 00       	call   80104730 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010135f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101362:	83 c4 10             	add    $0x10,%esp
80101365:	eb 1b                	jmp    80101382 <iget+0x42>
80101367:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010136e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101370:	39 3b                	cmp    %edi,(%ebx)
80101372:	74 6c                	je     801013e0 <iget+0xa0>
80101374:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010137a:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
80101380:	73 26                	jae    801013a8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101382:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101385:	85 c9                	test   %ecx,%ecx
80101387:	7f e7                	jg     80101370 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101389:	85 f6                	test   %esi,%esi
8010138b:	75 e7                	jne    80101374 <iget+0x34>
8010138d:	89 d8                	mov    %ebx,%eax
8010138f:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101395:	85 c9                	test   %ecx,%ecx
80101397:	75 6e                	jne    80101407 <iget+0xc7>
80101399:	89 c6                	mov    %eax,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010139b:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
801013a1:	72 df                	jb     80101382 <iget+0x42>
801013a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013a7:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013a8:	85 f6                	test   %esi,%esi
801013aa:	74 73                	je     8010141f <iget+0xdf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013ac:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013af:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013b1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013b4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013bb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013c2:	68 e0 19 11 80       	push   $0x801119e0
801013c7:	e8 24 34 00 00       	call   801047f0 <release>

  return ip;
801013cc:	83 c4 10             	add    $0x10,%esp
}
801013cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013d2:	89 f0                	mov    %esi,%eax
801013d4:	5b                   	pop    %ebx
801013d5:	5e                   	pop    %esi
801013d6:	5f                   	pop    %edi
801013d7:	5d                   	pop    %ebp
801013d8:	c3                   	ret    
801013d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013e0:	39 53 04             	cmp    %edx,0x4(%ebx)
801013e3:	75 8f                	jne    80101374 <iget+0x34>
      release(&icache.lock);
801013e5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801013e8:	83 c1 01             	add    $0x1,%ecx
      return ip;
801013eb:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801013ed:	68 e0 19 11 80       	push   $0x801119e0
      ip->ref++;
801013f2:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801013f5:	e8 f6 33 00 00       	call   801047f0 <release>
      return ip;
801013fa:	83 c4 10             	add    $0x10,%esp
}
801013fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101400:	89 f0                	mov    %esi,%eax
80101402:	5b                   	pop    %ebx
80101403:	5e                   	pop    %esi
80101404:	5f                   	pop    %edi
80101405:	5d                   	pop    %ebp
80101406:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101407:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
8010140d:	73 10                	jae    8010141f <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010140f:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101412:	85 c9                	test   %ecx,%ecx
80101414:	0f 8f 56 ff ff ff    	jg     80101370 <iget+0x30>
8010141a:	e9 6e ff ff ff       	jmp    8010138d <iget+0x4d>
    panic("iget: no inodes");
8010141f:	83 ec 0c             	sub    $0xc,%esp
80101422:	68 28 78 10 80       	push   $0x80107828
80101427:	e8 64 ef ff ff       	call   80100390 <panic>
8010142c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101430 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101430:	55                   	push   %ebp
80101431:	89 e5                	mov    %esp,%ebp
80101433:	57                   	push   %edi
80101434:	56                   	push   %esi
80101435:	89 c6                	mov    %eax,%esi
80101437:	53                   	push   %ebx
80101438:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010143b:	83 fa 0b             	cmp    $0xb,%edx
8010143e:	0f 86 84 00 00 00    	jbe    801014c8 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101444:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101447:	83 fb 7f             	cmp    $0x7f,%ebx
8010144a:	0f 87 98 00 00 00    	ja     801014e8 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101450:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101456:	8b 16                	mov    (%esi),%edx
80101458:	85 c0                	test   %eax,%eax
8010145a:	74 54                	je     801014b0 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010145c:	83 ec 08             	sub    $0x8,%esp
8010145f:	50                   	push   %eax
80101460:	52                   	push   %edx
80101461:	e8 6a ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101466:	83 c4 10             	add    $0x10,%esp
80101469:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
8010146d:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
8010146f:	8b 1a                	mov    (%edx),%ebx
80101471:	85 db                	test   %ebx,%ebx
80101473:	74 1b                	je     80101490 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101475:	83 ec 0c             	sub    $0xc,%esp
80101478:	57                   	push   %edi
80101479:	e8 72 ed ff ff       	call   801001f0 <brelse>
    return addr;
8010147e:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
80101481:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101484:	89 d8                	mov    %ebx,%eax
80101486:	5b                   	pop    %ebx
80101487:	5e                   	pop    %esi
80101488:	5f                   	pop    %edi
80101489:	5d                   	pop    %ebp
8010148a:	c3                   	ret    
8010148b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010148f:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
80101490:	8b 06                	mov    (%esi),%eax
80101492:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101495:	e8 96 fd ff ff       	call   80101230 <balloc>
8010149a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
8010149d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014a0:	89 c3                	mov    %eax,%ebx
801014a2:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801014a4:	57                   	push   %edi
801014a5:	e8 c6 1a 00 00       	call   80102f70 <log_write>
801014aa:	83 c4 10             	add    $0x10,%esp
801014ad:	eb c6                	jmp    80101475 <bmap+0x45>
801014af:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014b0:	89 d0                	mov    %edx,%eax
801014b2:	e8 79 fd ff ff       	call   80101230 <balloc>
801014b7:	8b 16                	mov    (%esi),%edx
801014b9:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014bf:	eb 9b                	jmp    8010145c <bmap+0x2c>
801014c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
801014c8:	8d 3c 90             	lea    (%eax,%edx,4),%edi
801014cb:	8b 5f 5c             	mov    0x5c(%edi),%ebx
801014ce:	85 db                	test   %ebx,%ebx
801014d0:	75 af                	jne    80101481 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
801014d2:	8b 00                	mov    (%eax),%eax
801014d4:	e8 57 fd ff ff       	call   80101230 <balloc>
801014d9:	89 47 5c             	mov    %eax,0x5c(%edi)
801014dc:	89 c3                	mov    %eax,%ebx
}
801014de:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014e1:	89 d8                	mov    %ebx,%eax
801014e3:	5b                   	pop    %ebx
801014e4:	5e                   	pop    %esi
801014e5:	5f                   	pop    %edi
801014e6:	5d                   	pop    %ebp
801014e7:	c3                   	ret    
  panic("bmap: out of range");
801014e8:	83 ec 0c             	sub    $0xc,%esp
801014eb:	68 38 78 10 80       	push   $0x80107838
801014f0:	e8 9b ee ff ff       	call   80100390 <panic>
801014f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101500 <readsb>:
{
80101500:	f3 0f 1e fb          	endbr32 
80101504:	55                   	push   %ebp
80101505:	89 e5                	mov    %esp,%ebp
80101507:	56                   	push   %esi
80101508:	53                   	push   %ebx
80101509:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
8010150c:	83 ec 08             	sub    $0x8,%esp
8010150f:	6a 01                	push   $0x1
80101511:	ff 75 08             	pushl  0x8(%ebp)
80101514:	e8 b7 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101519:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010151c:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010151e:	8d 40 5c             	lea    0x5c(%eax),%eax
80101521:	6a 1c                	push   $0x1c
80101523:	50                   	push   %eax
80101524:	56                   	push   %esi
80101525:	e8 b6 33 00 00       	call   801048e0 <memmove>
  brelse(bp);
8010152a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010152d:	83 c4 10             	add    $0x10,%esp
}
80101530:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101533:	5b                   	pop    %ebx
80101534:	5e                   	pop    %esi
80101535:	5d                   	pop    %ebp
  brelse(bp);
80101536:	e9 b5 ec ff ff       	jmp    801001f0 <brelse>
8010153b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010153f:	90                   	nop

80101540 <iinit>:
{
80101540:	f3 0f 1e fb          	endbr32 
80101544:	55                   	push   %ebp
80101545:	89 e5                	mov    %esp,%ebp
80101547:	53                   	push   %ebx
80101548:	bb 20 1a 11 80       	mov    $0x80111a20,%ebx
8010154d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101550:	68 4b 78 10 80       	push   $0x8010784b
80101555:	68 e0 19 11 80       	push   $0x801119e0
8010155a:	e8 51 30 00 00       	call   801045b0 <initlock>
  for(i = 0; i < NINODE; i++) {
8010155f:	83 c4 10             	add    $0x10,%esp
80101562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101568:	83 ec 08             	sub    $0x8,%esp
8010156b:	68 52 78 10 80       	push   $0x80107852
80101570:	53                   	push   %ebx
80101571:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101577:	e8 f4 2e 00 00       	call   80104470 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
8010157c:	83 c4 10             	add    $0x10,%esp
8010157f:	81 fb 40 36 11 80    	cmp    $0x80113640,%ebx
80101585:	75 e1                	jne    80101568 <iinit+0x28>
  readsb(dev, &sb);
80101587:	83 ec 08             	sub    $0x8,%esp
8010158a:	68 c0 19 11 80       	push   $0x801119c0
8010158f:	ff 75 08             	pushl  0x8(%ebp)
80101592:	e8 69 ff ff ff       	call   80101500 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101597:	ff 35 d8 19 11 80    	pushl  0x801119d8
8010159d:	ff 35 d4 19 11 80    	pushl  0x801119d4
801015a3:	ff 35 d0 19 11 80    	pushl  0x801119d0
801015a9:	ff 35 cc 19 11 80    	pushl  0x801119cc
801015af:	ff 35 c8 19 11 80    	pushl  0x801119c8
801015b5:	ff 35 c4 19 11 80    	pushl  0x801119c4
801015bb:	ff 35 c0 19 11 80    	pushl  0x801119c0
801015c1:	68 b8 78 10 80       	push   $0x801078b8
801015c6:	e8 e5 f0 ff ff       	call   801006b0 <cprintf>
}
801015cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801015ce:	83 c4 30             	add    $0x30,%esp
801015d1:	c9                   	leave  
801015d2:	c3                   	ret    
801015d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801015e0 <ialloc>:
{
801015e0:	f3 0f 1e fb          	endbr32 
801015e4:	55                   	push   %ebp
801015e5:	89 e5                	mov    %esp,%ebp
801015e7:	57                   	push   %edi
801015e8:	56                   	push   %esi
801015e9:	53                   	push   %ebx
801015ea:	83 ec 1c             	sub    $0x1c,%esp
801015ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
801015f0:	83 3d c8 19 11 80 01 	cmpl   $0x1,0x801119c8
{
801015f7:	8b 75 08             	mov    0x8(%ebp),%esi
801015fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801015fd:	0f 86 8d 00 00 00    	jbe    80101690 <ialloc+0xb0>
80101603:	bf 01 00 00 00       	mov    $0x1,%edi
80101608:	eb 1d                	jmp    80101627 <ialloc+0x47>
8010160a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    brelse(bp);
80101610:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101613:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101616:	53                   	push   %ebx
80101617:	e8 d4 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010161c:	83 c4 10             	add    $0x10,%esp
8010161f:	3b 3d c8 19 11 80    	cmp    0x801119c8,%edi
80101625:	73 69                	jae    80101690 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101627:	89 f8                	mov    %edi,%eax
80101629:	83 ec 08             	sub    $0x8,%esp
8010162c:	c1 e8 03             	shr    $0x3,%eax
8010162f:	03 05 d4 19 11 80    	add    0x801119d4,%eax
80101635:	50                   	push   %eax
80101636:	56                   	push   %esi
80101637:	e8 94 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010163c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010163f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101641:	89 f8                	mov    %edi,%eax
80101643:	83 e0 07             	and    $0x7,%eax
80101646:	c1 e0 06             	shl    $0x6,%eax
80101649:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010164d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101651:	75 bd                	jne    80101610 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101653:	83 ec 04             	sub    $0x4,%esp
80101656:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101659:	6a 40                	push   $0x40
8010165b:	6a 00                	push   $0x0
8010165d:	51                   	push   %ecx
8010165e:	e8 dd 31 00 00       	call   80104840 <memset>
      dip->type = type;
80101663:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101667:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010166a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010166d:	89 1c 24             	mov    %ebx,(%esp)
80101670:	e8 fb 18 00 00       	call   80102f70 <log_write>
      brelse(bp);
80101675:	89 1c 24             	mov    %ebx,(%esp)
80101678:	e8 73 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
8010167d:	83 c4 10             	add    $0x10,%esp
}
80101680:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101683:	89 fa                	mov    %edi,%edx
}
80101685:	5b                   	pop    %ebx
      return iget(dev, inum);
80101686:	89 f0                	mov    %esi,%eax
}
80101688:	5e                   	pop    %esi
80101689:	5f                   	pop    %edi
8010168a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010168b:	e9 b0 fc ff ff       	jmp    80101340 <iget>
  panic("ialloc: no inodes");
80101690:	83 ec 0c             	sub    $0xc,%esp
80101693:	68 58 78 10 80       	push   $0x80107858
80101698:	e8 f3 ec ff ff       	call   80100390 <panic>
8010169d:	8d 76 00             	lea    0x0(%esi),%esi

801016a0 <iupdate>:
{
801016a0:	f3 0f 1e fb          	endbr32 
801016a4:	55                   	push   %ebp
801016a5:	89 e5                	mov    %esp,%ebp
801016a7:	56                   	push   %esi
801016a8:	53                   	push   %ebx
801016a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016ac:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016af:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016b2:	83 ec 08             	sub    $0x8,%esp
801016b5:	c1 e8 03             	shr    $0x3,%eax
801016b8:	03 05 d4 19 11 80    	add    0x801119d4,%eax
801016be:	50                   	push   %eax
801016bf:	ff 73 a4             	pushl  -0x5c(%ebx)
801016c2:	e8 09 ea ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801016c7:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016cb:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016ce:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016d0:	8b 43 a8             	mov    -0x58(%ebx),%eax
801016d3:	83 e0 07             	and    $0x7,%eax
801016d6:	c1 e0 06             	shl    $0x6,%eax
801016d9:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801016dd:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801016e0:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016e4:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801016e7:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801016eb:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801016ef:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801016f3:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801016f7:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801016fb:	8b 53 fc             	mov    -0x4(%ebx),%edx
801016fe:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101701:	6a 34                	push   $0x34
80101703:	53                   	push   %ebx
80101704:	50                   	push   %eax
80101705:	e8 d6 31 00 00       	call   801048e0 <memmove>
  log_write(bp);
8010170a:	89 34 24             	mov    %esi,(%esp)
8010170d:	e8 5e 18 00 00       	call   80102f70 <log_write>
  brelse(bp);
80101712:	89 75 08             	mov    %esi,0x8(%ebp)
80101715:	83 c4 10             	add    $0x10,%esp
}
80101718:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010171b:	5b                   	pop    %ebx
8010171c:	5e                   	pop    %esi
8010171d:	5d                   	pop    %ebp
  brelse(bp);
8010171e:	e9 cd ea ff ff       	jmp    801001f0 <brelse>
80101723:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010172a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101730 <idup>:
{
80101730:	f3 0f 1e fb          	endbr32 
80101734:	55                   	push   %ebp
80101735:	89 e5                	mov    %esp,%ebp
80101737:	53                   	push   %ebx
80101738:	83 ec 10             	sub    $0x10,%esp
8010173b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010173e:	68 e0 19 11 80       	push   $0x801119e0
80101743:	e8 e8 2f 00 00       	call   80104730 <acquire>
  ip->ref++;
80101748:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010174c:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101753:	e8 98 30 00 00       	call   801047f0 <release>
}
80101758:	89 d8                	mov    %ebx,%eax
8010175a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010175d:	c9                   	leave  
8010175e:	c3                   	ret    
8010175f:	90                   	nop

80101760 <ilock>:
{
80101760:	f3 0f 1e fb          	endbr32 
80101764:	55                   	push   %ebp
80101765:	89 e5                	mov    %esp,%ebp
80101767:	56                   	push   %esi
80101768:	53                   	push   %ebx
80101769:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
8010176c:	85 db                	test   %ebx,%ebx
8010176e:	0f 84 b3 00 00 00    	je     80101827 <ilock+0xc7>
80101774:	8b 53 08             	mov    0x8(%ebx),%edx
80101777:	85 d2                	test   %edx,%edx
80101779:	0f 8e a8 00 00 00    	jle    80101827 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010177f:	83 ec 0c             	sub    $0xc,%esp
80101782:	8d 43 0c             	lea    0xc(%ebx),%eax
80101785:	50                   	push   %eax
80101786:	e8 25 2d 00 00       	call   801044b0 <acquiresleep>
  if(ip->valid == 0){
8010178b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010178e:	83 c4 10             	add    $0x10,%esp
80101791:	85 c0                	test   %eax,%eax
80101793:	74 0b                	je     801017a0 <ilock+0x40>
}
80101795:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101798:	5b                   	pop    %ebx
80101799:	5e                   	pop    %esi
8010179a:	5d                   	pop    %ebp
8010179b:	c3                   	ret    
8010179c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017a0:	8b 43 04             	mov    0x4(%ebx),%eax
801017a3:	83 ec 08             	sub    $0x8,%esp
801017a6:	c1 e8 03             	shr    $0x3,%eax
801017a9:	03 05 d4 19 11 80    	add    0x801119d4,%eax
801017af:	50                   	push   %eax
801017b0:	ff 33                	pushl  (%ebx)
801017b2:	e8 19 e9 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017b7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017ba:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017bc:	8b 43 04             	mov    0x4(%ebx),%eax
801017bf:	83 e0 07             	and    $0x7,%eax
801017c2:	c1 e0 06             	shl    $0x6,%eax
801017c5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017c9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017cc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801017cf:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801017d3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017d7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801017db:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017df:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801017e3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801017e7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801017eb:	8b 50 fc             	mov    -0x4(%eax),%edx
801017ee:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017f1:	6a 34                	push   $0x34
801017f3:	50                   	push   %eax
801017f4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801017f7:	50                   	push   %eax
801017f8:	e8 e3 30 00 00       	call   801048e0 <memmove>
    brelse(bp);
801017fd:	89 34 24             	mov    %esi,(%esp)
80101800:	e8 eb e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101805:	83 c4 10             	add    $0x10,%esp
80101808:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010180d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101814:	0f 85 7b ff ff ff    	jne    80101795 <ilock+0x35>
      panic("ilock: no type");
8010181a:	83 ec 0c             	sub    $0xc,%esp
8010181d:	68 70 78 10 80       	push   $0x80107870
80101822:	e8 69 eb ff ff       	call   80100390 <panic>
    panic("ilock");
80101827:	83 ec 0c             	sub    $0xc,%esp
8010182a:	68 6a 78 10 80       	push   $0x8010786a
8010182f:	e8 5c eb ff ff       	call   80100390 <panic>
80101834:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010183b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010183f:	90                   	nop

80101840 <iunlock>:
{
80101840:	f3 0f 1e fb          	endbr32 
80101844:	55                   	push   %ebp
80101845:	89 e5                	mov    %esp,%ebp
80101847:	56                   	push   %esi
80101848:	53                   	push   %ebx
80101849:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010184c:	85 db                	test   %ebx,%ebx
8010184e:	74 28                	je     80101878 <iunlock+0x38>
80101850:	83 ec 0c             	sub    $0xc,%esp
80101853:	8d 73 0c             	lea    0xc(%ebx),%esi
80101856:	56                   	push   %esi
80101857:	e8 f4 2c 00 00       	call   80104550 <holdingsleep>
8010185c:	83 c4 10             	add    $0x10,%esp
8010185f:	85 c0                	test   %eax,%eax
80101861:	74 15                	je     80101878 <iunlock+0x38>
80101863:	8b 43 08             	mov    0x8(%ebx),%eax
80101866:	85 c0                	test   %eax,%eax
80101868:	7e 0e                	jle    80101878 <iunlock+0x38>
  releasesleep(&ip->lock);
8010186a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010186d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101870:	5b                   	pop    %ebx
80101871:	5e                   	pop    %esi
80101872:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101873:	e9 98 2c 00 00       	jmp    80104510 <releasesleep>
    panic("iunlock");
80101878:	83 ec 0c             	sub    $0xc,%esp
8010187b:	68 7f 78 10 80       	push   $0x8010787f
80101880:	e8 0b eb ff ff       	call   80100390 <panic>
80101885:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010188c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101890 <iput>:
{
80101890:	f3 0f 1e fb          	endbr32 
80101894:	55                   	push   %ebp
80101895:	89 e5                	mov    %esp,%ebp
80101897:	57                   	push   %edi
80101898:	56                   	push   %esi
80101899:	53                   	push   %ebx
8010189a:	83 ec 28             	sub    $0x28,%esp
8010189d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018a0:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018a3:	57                   	push   %edi
801018a4:	e8 07 2c 00 00       	call   801044b0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018a9:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018ac:	83 c4 10             	add    $0x10,%esp
801018af:	85 d2                	test   %edx,%edx
801018b1:	74 07                	je     801018ba <iput+0x2a>
801018b3:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018b8:	74 36                	je     801018f0 <iput+0x60>
  releasesleep(&ip->lock);
801018ba:	83 ec 0c             	sub    $0xc,%esp
801018bd:	57                   	push   %edi
801018be:	e8 4d 2c 00 00       	call   80104510 <releasesleep>
  acquire(&icache.lock);
801018c3:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
801018ca:	e8 61 2e 00 00       	call   80104730 <acquire>
  ip->ref--;
801018cf:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018d3:	83 c4 10             	add    $0x10,%esp
801018d6:	c7 45 08 e0 19 11 80 	movl   $0x801119e0,0x8(%ebp)
}
801018dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018e0:	5b                   	pop    %ebx
801018e1:	5e                   	pop    %esi
801018e2:	5f                   	pop    %edi
801018e3:	5d                   	pop    %ebp
  release(&icache.lock);
801018e4:	e9 07 2f 00 00       	jmp    801047f0 <release>
801018e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
801018f0:	83 ec 0c             	sub    $0xc,%esp
801018f3:	68 e0 19 11 80       	push   $0x801119e0
801018f8:	e8 33 2e 00 00       	call   80104730 <acquire>
    int r = ip->ref;
801018fd:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101900:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101907:	e8 e4 2e 00 00       	call   801047f0 <release>
    if(r == 1){
8010190c:	83 c4 10             	add    $0x10,%esp
8010190f:	83 fe 01             	cmp    $0x1,%esi
80101912:	75 a6                	jne    801018ba <iput+0x2a>
80101914:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
8010191a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8010191d:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101920:	89 cf                	mov    %ecx,%edi
80101922:	eb 0b                	jmp    8010192f <iput+0x9f>
80101924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101928:	83 c6 04             	add    $0x4,%esi
8010192b:	39 fe                	cmp    %edi,%esi
8010192d:	74 19                	je     80101948 <iput+0xb8>
    if(ip->addrs[i]){
8010192f:	8b 16                	mov    (%esi),%edx
80101931:	85 d2                	test   %edx,%edx
80101933:	74 f3                	je     80101928 <iput+0x98>
      bfree(ip->dev, ip->addrs[i]);
80101935:	8b 03                	mov    (%ebx),%eax
80101937:	e8 74 f8 ff ff       	call   801011b0 <bfree>
      ip->addrs[i] = 0;
8010193c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101942:	eb e4                	jmp    80101928 <iput+0x98>
80101944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101948:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
8010194e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101951:	85 c0                	test   %eax,%eax
80101953:	75 33                	jne    80101988 <iput+0xf8>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101955:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101958:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
8010195f:	53                   	push   %ebx
80101960:	e8 3b fd ff ff       	call   801016a0 <iupdate>
      ip->type = 0;
80101965:	31 c0                	xor    %eax,%eax
80101967:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
8010196b:	89 1c 24             	mov    %ebx,(%esp)
8010196e:	e8 2d fd ff ff       	call   801016a0 <iupdate>
      ip->valid = 0;
80101973:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
8010197a:	83 c4 10             	add    $0x10,%esp
8010197d:	e9 38 ff ff ff       	jmp    801018ba <iput+0x2a>
80101982:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101988:	83 ec 08             	sub    $0x8,%esp
8010198b:	50                   	push   %eax
8010198c:	ff 33                	pushl  (%ebx)
8010198e:	e8 3d e7 ff ff       	call   801000d0 <bread>
80101993:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101996:	83 c4 10             	add    $0x10,%esp
80101999:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
8010199f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019a2:	8d 70 5c             	lea    0x5c(%eax),%esi
801019a5:	89 cf                	mov    %ecx,%edi
801019a7:	eb 0e                	jmp    801019b7 <iput+0x127>
801019a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019b0:	83 c6 04             	add    $0x4,%esi
801019b3:	39 f7                	cmp    %esi,%edi
801019b5:	74 19                	je     801019d0 <iput+0x140>
      if(a[j])
801019b7:	8b 16                	mov    (%esi),%edx
801019b9:	85 d2                	test   %edx,%edx
801019bb:	74 f3                	je     801019b0 <iput+0x120>
        bfree(ip->dev, a[j]);
801019bd:	8b 03                	mov    (%ebx),%eax
801019bf:	e8 ec f7 ff ff       	call   801011b0 <bfree>
801019c4:	eb ea                	jmp    801019b0 <iput+0x120>
801019c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019cd:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
801019d0:	83 ec 0c             	sub    $0xc,%esp
801019d3:	ff 75 e4             	pushl  -0x1c(%ebp)
801019d6:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019d9:	e8 12 e8 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019de:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019e4:	8b 03                	mov    (%ebx),%eax
801019e6:	e8 c5 f7 ff ff       	call   801011b0 <bfree>
    ip->addrs[NDIRECT] = 0;
801019eb:	83 c4 10             	add    $0x10,%esp
801019ee:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801019f5:	00 00 00 
801019f8:	e9 58 ff ff ff       	jmp    80101955 <iput+0xc5>
801019fd:	8d 76 00             	lea    0x0(%esi),%esi

80101a00 <iunlockput>:
{
80101a00:	f3 0f 1e fb          	endbr32 
80101a04:	55                   	push   %ebp
80101a05:	89 e5                	mov    %esp,%ebp
80101a07:	53                   	push   %ebx
80101a08:	83 ec 10             	sub    $0x10,%esp
80101a0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101a0e:	53                   	push   %ebx
80101a0f:	e8 2c fe ff ff       	call   80101840 <iunlock>
  iput(ip);
80101a14:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a17:	83 c4 10             	add    $0x10,%esp
}
80101a1a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101a1d:	c9                   	leave  
  iput(ip);
80101a1e:	e9 6d fe ff ff       	jmp    80101890 <iput>
80101a23:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a30 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a30:	f3 0f 1e fb          	endbr32 
80101a34:	55                   	push   %ebp
80101a35:	89 e5                	mov    %esp,%ebp
80101a37:	8b 55 08             	mov    0x8(%ebp),%edx
80101a3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a3d:	8b 0a                	mov    (%edx),%ecx
80101a3f:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a42:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a45:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a48:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a4c:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a4f:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a53:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a57:	8b 52 58             	mov    0x58(%edx),%edx
80101a5a:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a5d:	5d                   	pop    %ebp
80101a5e:	c3                   	ret    
80101a5f:	90                   	nop

80101a60 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a60:	f3 0f 1e fb          	endbr32 
80101a64:	55                   	push   %ebp
80101a65:	89 e5                	mov    %esp,%ebp
80101a67:	57                   	push   %edi
80101a68:	56                   	push   %esi
80101a69:	53                   	push   %ebx
80101a6a:	83 ec 1c             	sub    $0x1c,%esp
80101a6d:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101a70:	8b 45 08             	mov    0x8(%ebp),%eax
80101a73:	8b 75 10             	mov    0x10(%ebp),%esi
80101a76:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101a79:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a7c:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a81:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a84:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101a87:	0f 84 a3 00 00 00    	je     80101b30 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101a8d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a90:	8b 40 58             	mov    0x58(%eax),%eax
80101a93:	39 c6                	cmp    %eax,%esi
80101a95:	0f 87 b6 00 00 00    	ja     80101b51 <readi+0xf1>
80101a9b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101a9e:	31 c9                	xor    %ecx,%ecx
80101aa0:	89 da                	mov    %ebx,%edx
80101aa2:	01 f2                	add    %esi,%edx
80101aa4:	0f 92 c1             	setb   %cl
80101aa7:	89 cf                	mov    %ecx,%edi
80101aa9:	0f 82 a2 00 00 00    	jb     80101b51 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101aaf:	89 c1                	mov    %eax,%ecx
80101ab1:	29 f1                	sub    %esi,%ecx
80101ab3:	39 d0                	cmp    %edx,%eax
80101ab5:	0f 43 cb             	cmovae %ebx,%ecx
80101ab8:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101abb:	85 c9                	test   %ecx,%ecx
80101abd:	74 63                	je     80101b22 <readi+0xc2>
80101abf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ac0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101ac3:	89 f2                	mov    %esi,%edx
80101ac5:	c1 ea 09             	shr    $0x9,%edx
80101ac8:	89 d8                	mov    %ebx,%eax
80101aca:	e8 61 f9 ff ff       	call   80101430 <bmap>
80101acf:	83 ec 08             	sub    $0x8,%esp
80101ad2:	50                   	push   %eax
80101ad3:	ff 33                	pushl  (%ebx)
80101ad5:	e8 f6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101ada:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101add:	b9 00 02 00 00       	mov    $0x200,%ecx
80101ae2:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ae5:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101ae7:	89 f0                	mov    %esi,%eax
80101ae9:	25 ff 01 00 00       	and    $0x1ff,%eax
80101aee:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101af0:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101af3:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101af5:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101af9:	39 d9                	cmp    %ebx,%ecx
80101afb:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101afe:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101aff:	01 df                	add    %ebx,%edi
80101b01:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b03:	50                   	push   %eax
80101b04:	ff 75 e0             	pushl  -0x20(%ebp)
80101b07:	e8 d4 2d 00 00       	call   801048e0 <memmove>
    brelse(bp);
80101b0c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b0f:	89 14 24             	mov    %edx,(%esp)
80101b12:	e8 d9 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b17:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b1a:	83 c4 10             	add    $0x10,%esp
80101b1d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b20:	77 9e                	ja     80101ac0 <readi+0x60>
  }
  return n;
80101b22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b25:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b28:	5b                   	pop    %ebx
80101b29:	5e                   	pop    %esi
80101b2a:	5f                   	pop    %edi
80101b2b:	5d                   	pop    %ebp
80101b2c:	c3                   	ret    
80101b2d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b30:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b34:	66 83 f8 09          	cmp    $0x9,%ax
80101b38:	77 17                	ja     80101b51 <readi+0xf1>
80101b3a:	8b 04 c5 60 19 11 80 	mov    -0x7feee6a0(,%eax,8),%eax
80101b41:	85 c0                	test   %eax,%eax
80101b43:	74 0c                	je     80101b51 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b45:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b4b:	5b                   	pop    %ebx
80101b4c:	5e                   	pop    %esi
80101b4d:	5f                   	pop    %edi
80101b4e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b4f:	ff e0                	jmp    *%eax
      return -1;
80101b51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b56:	eb cd                	jmp    80101b25 <readi+0xc5>
80101b58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b5f:	90                   	nop

80101b60 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b60:	f3 0f 1e fb          	endbr32 
80101b64:	55                   	push   %ebp
80101b65:	89 e5                	mov    %esp,%ebp
80101b67:	57                   	push   %edi
80101b68:	56                   	push   %esi
80101b69:	53                   	push   %ebx
80101b6a:	83 ec 1c             	sub    $0x1c,%esp
80101b6d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b70:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b73:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b76:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101b7b:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101b7e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b81:	8b 75 10             	mov    0x10(%ebp),%esi
80101b84:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101b87:	0f 84 b3 00 00 00    	je     80101c40 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101b8d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b90:	39 70 58             	cmp    %esi,0x58(%eax)
80101b93:	0f 82 e3 00 00 00    	jb     80101c7c <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101b99:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101b9c:	89 f8                	mov    %edi,%eax
80101b9e:	01 f0                	add    %esi,%eax
80101ba0:	0f 82 d6 00 00 00    	jb     80101c7c <writei+0x11c>
80101ba6:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101bab:	0f 87 cb 00 00 00    	ja     80101c7c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bb1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101bb8:	85 ff                	test   %edi,%edi
80101bba:	74 75                	je     80101c31 <writei+0xd1>
80101bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bc0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101bc3:	89 f2                	mov    %esi,%edx
80101bc5:	c1 ea 09             	shr    $0x9,%edx
80101bc8:	89 f8                	mov    %edi,%eax
80101bca:	e8 61 f8 ff ff       	call   80101430 <bmap>
80101bcf:	83 ec 08             	sub    $0x8,%esp
80101bd2:	50                   	push   %eax
80101bd3:	ff 37                	pushl  (%edi)
80101bd5:	e8 f6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101bda:	b9 00 02 00 00       	mov    $0x200,%ecx
80101bdf:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101be2:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101be5:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101be7:	89 f0                	mov    %esi,%eax
80101be9:	83 c4 0c             	add    $0xc,%esp
80101bec:	25 ff 01 00 00       	and    $0x1ff,%eax
80101bf1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101bf3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101bf7:	39 d9                	cmp    %ebx,%ecx
80101bf9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101bfc:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bfd:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101bff:	ff 75 dc             	pushl  -0x24(%ebp)
80101c02:	50                   	push   %eax
80101c03:	e8 d8 2c 00 00       	call   801048e0 <memmove>
    log_write(bp);
80101c08:	89 3c 24             	mov    %edi,(%esp)
80101c0b:	e8 60 13 00 00       	call   80102f70 <log_write>
    brelse(bp);
80101c10:	89 3c 24             	mov    %edi,(%esp)
80101c13:	e8 d8 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c18:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c1b:	83 c4 10             	add    $0x10,%esp
80101c1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c21:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c24:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c27:	77 97                	ja     80101bc0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c29:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c2c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c2f:	77 37                	ja     80101c68 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c31:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c34:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c37:	5b                   	pop    %ebx
80101c38:	5e                   	pop    %esi
80101c39:	5f                   	pop    %edi
80101c3a:	5d                   	pop    %ebp
80101c3b:	c3                   	ret    
80101c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c44:	66 83 f8 09          	cmp    $0x9,%ax
80101c48:	77 32                	ja     80101c7c <writei+0x11c>
80101c4a:	8b 04 c5 64 19 11 80 	mov    -0x7feee69c(,%eax,8),%eax
80101c51:	85 c0                	test   %eax,%eax
80101c53:	74 27                	je     80101c7c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c55:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101c58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c5b:	5b                   	pop    %ebx
80101c5c:	5e                   	pop    %esi
80101c5d:	5f                   	pop    %edi
80101c5e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c5f:	ff e0                	jmp    *%eax
80101c61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c68:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c6b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c6e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101c71:	50                   	push   %eax
80101c72:	e8 29 fa ff ff       	call   801016a0 <iupdate>
80101c77:	83 c4 10             	add    $0x10,%esp
80101c7a:	eb b5                	jmp    80101c31 <writei+0xd1>
      return -1;
80101c7c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c81:	eb b1                	jmp    80101c34 <writei+0xd4>
80101c83:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101c90 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101c90:	f3 0f 1e fb          	endbr32 
80101c94:	55                   	push   %ebp
80101c95:	89 e5                	mov    %esp,%ebp
80101c97:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101c9a:	6a 0e                	push   $0xe
80101c9c:	ff 75 0c             	pushl  0xc(%ebp)
80101c9f:	ff 75 08             	pushl  0x8(%ebp)
80101ca2:	e8 a9 2c 00 00       	call   80104950 <strncmp>
}
80101ca7:	c9                   	leave  
80101ca8:	c3                   	ret    
80101ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101cb0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101cb0:	f3 0f 1e fb          	endbr32 
80101cb4:	55                   	push   %ebp
80101cb5:	89 e5                	mov    %esp,%ebp
80101cb7:	57                   	push   %edi
80101cb8:	56                   	push   %esi
80101cb9:	53                   	push   %ebx
80101cba:	83 ec 1c             	sub    $0x1c,%esp
80101cbd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cc0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101cc5:	0f 85 89 00 00 00    	jne    80101d54 <dirlookup+0xa4>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101ccb:	8b 53 58             	mov    0x58(%ebx),%edx
80101cce:	31 ff                	xor    %edi,%edi
80101cd0:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101cd3:	85 d2                	test   %edx,%edx
80101cd5:	74 42                	je     80101d19 <dirlookup+0x69>
80101cd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cde:	66 90                	xchg   %ax,%ax
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ce0:	6a 10                	push   $0x10
80101ce2:	57                   	push   %edi
80101ce3:	56                   	push   %esi
80101ce4:	53                   	push   %ebx
80101ce5:	e8 76 fd ff ff       	call   80101a60 <readi>
80101cea:	83 c4 10             	add    $0x10,%esp
80101ced:	83 f8 10             	cmp    $0x10,%eax
80101cf0:	75 55                	jne    80101d47 <dirlookup+0x97>
      panic("dirlookup read");
    if(de.inum == 0)
80101cf2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101cf7:	74 18                	je     80101d11 <dirlookup+0x61>
  return strncmp(s, t, DIRSIZ);
80101cf9:	83 ec 04             	sub    $0x4,%esp
80101cfc:	8d 45 da             	lea    -0x26(%ebp),%eax
80101cff:	6a 0e                	push   $0xe
80101d01:	50                   	push   %eax
80101d02:	ff 75 0c             	pushl  0xc(%ebp)
80101d05:	e8 46 2c 00 00       	call   80104950 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d0a:	83 c4 10             	add    $0x10,%esp
80101d0d:	85 c0                	test   %eax,%eax
80101d0f:	74 17                	je     80101d28 <dirlookup+0x78>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d11:	83 c7 10             	add    $0x10,%edi
80101d14:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d17:	72 c7                	jb     80101ce0 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d19:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d1c:	31 c0                	xor    %eax,%eax
}
80101d1e:	5b                   	pop    %ebx
80101d1f:	5e                   	pop    %esi
80101d20:	5f                   	pop    %edi
80101d21:	5d                   	pop    %ebp
80101d22:	c3                   	ret    
80101d23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d27:	90                   	nop
      if(poff)
80101d28:	8b 45 10             	mov    0x10(%ebp),%eax
80101d2b:	85 c0                	test   %eax,%eax
80101d2d:	74 05                	je     80101d34 <dirlookup+0x84>
        *poff = off;
80101d2f:	8b 45 10             	mov    0x10(%ebp),%eax
80101d32:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d34:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d38:	8b 03                	mov    (%ebx),%eax
80101d3a:	e8 01 f6 ff ff       	call   80101340 <iget>
}
80101d3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d42:	5b                   	pop    %ebx
80101d43:	5e                   	pop    %esi
80101d44:	5f                   	pop    %edi
80101d45:	5d                   	pop    %ebp
80101d46:	c3                   	ret    
      panic("dirlookup read");
80101d47:	83 ec 0c             	sub    $0xc,%esp
80101d4a:	68 99 78 10 80       	push   $0x80107899
80101d4f:	e8 3c e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101d54:	83 ec 0c             	sub    $0xc,%esp
80101d57:	68 87 78 10 80       	push   $0x80107887
80101d5c:	e8 2f e6 ff ff       	call   80100390 <panic>
80101d61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d6f:	90                   	nop

80101d70 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d70:	55                   	push   %ebp
80101d71:	89 e5                	mov    %esp,%ebp
80101d73:	57                   	push   %edi
80101d74:	56                   	push   %esi
80101d75:	53                   	push   %ebx
80101d76:	89 c3                	mov    %eax,%ebx
80101d78:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d7b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d7e:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101d81:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101d84:	0f 84 86 01 00 00    	je     80101f10 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101d8a:	e8 21 1c 00 00       	call   801039b0 <myproc>
  acquire(&icache.lock);
80101d8f:	83 ec 0c             	sub    $0xc,%esp
80101d92:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80101d94:	8b 70 6c             	mov    0x6c(%eax),%esi
  acquire(&icache.lock);
80101d97:	68 e0 19 11 80       	push   $0x801119e0
80101d9c:	e8 8f 29 00 00       	call   80104730 <acquire>
  ip->ref++;
80101da1:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101da5:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101dac:	e8 3f 2a 00 00       	call   801047f0 <release>
80101db1:	83 c4 10             	add    $0x10,%esp
80101db4:	eb 0d                	jmp    80101dc3 <namex+0x53>
80101db6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dbd:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
80101dc0:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101dc3:	0f b6 07             	movzbl (%edi),%eax
80101dc6:	3c 2f                	cmp    $0x2f,%al
80101dc8:	74 f6                	je     80101dc0 <namex+0x50>
  if(*path == 0)
80101dca:	84 c0                	test   %al,%al
80101dcc:	0f 84 ee 00 00 00    	je     80101ec0 <namex+0x150>
  while(*path != '/' && *path != 0)
80101dd2:	0f b6 07             	movzbl (%edi),%eax
80101dd5:	84 c0                	test   %al,%al
80101dd7:	0f 84 fb 00 00 00    	je     80101ed8 <namex+0x168>
80101ddd:	89 fb                	mov    %edi,%ebx
80101ddf:	3c 2f                	cmp    $0x2f,%al
80101de1:	0f 84 f1 00 00 00    	je     80101ed8 <namex+0x168>
80101de7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dee:	66 90                	xchg   %ax,%ax
80101df0:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    path++;
80101df4:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80101df7:	3c 2f                	cmp    $0x2f,%al
80101df9:	74 04                	je     80101dff <namex+0x8f>
80101dfb:	84 c0                	test   %al,%al
80101dfd:	75 f1                	jne    80101df0 <namex+0x80>
  len = path - s;
80101dff:	89 d8                	mov    %ebx,%eax
80101e01:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
80101e03:	83 f8 0d             	cmp    $0xd,%eax
80101e06:	0f 8e 84 00 00 00    	jle    80101e90 <namex+0x120>
    memmove(name, s, DIRSIZ);
80101e0c:	83 ec 04             	sub    $0x4,%esp
80101e0f:	6a 0e                	push   $0xe
80101e11:	57                   	push   %edi
    path++;
80101e12:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
80101e14:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e17:	e8 c4 2a 00 00       	call   801048e0 <memmove>
80101e1c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e1f:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e22:	75 0c                	jne    80101e30 <namex+0xc0>
80101e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e28:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101e2b:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e2e:	74 f8                	je     80101e28 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e30:	83 ec 0c             	sub    $0xc,%esp
80101e33:	56                   	push   %esi
80101e34:	e8 27 f9 ff ff       	call   80101760 <ilock>
    if(ip->type != T_DIR){
80101e39:	83 c4 10             	add    $0x10,%esp
80101e3c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e41:	0f 85 a1 00 00 00    	jne    80101ee8 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e47:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101e4a:	85 d2                	test   %edx,%edx
80101e4c:	74 09                	je     80101e57 <namex+0xe7>
80101e4e:	80 3f 00             	cmpb   $0x0,(%edi)
80101e51:	0f 84 d9 00 00 00    	je     80101f30 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e57:	83 ec 04             	sub    $0x4,%esp
80101e5a:	6a 00                	push   $0x0
80101e5c:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e5f:	56                   	push   %esi
80101e60:	e8 4b fe ff ff       	call   80101cb0 <dirlookup>
80101e65:	83 c4 10             	add    $0x10,%esp
80101e68:	89 c3                	mov    %eax,%ebx
80101e6a:	85 c0                	test   %eax,%eax
80101e6c:	74 7a                	je     80101ee8 <namex+0x178>
  iunlock(ip);
80101e6e:	83 ec 0c             	sub    $0xc,%esp
80101e71:	56                   	push   %esi
80101e72:	e8 c9 f9 ff ff       	call   80101840 <iunlock>
  iput(ip);
80101e77:	89 34 24             	mov    %esi,(%esp)
80101e7a:	89 de                	mov    %ebx,%esi
80101e7c:	e8 0f fa ff ff       	call   80101890 <iput>
80101e81:	83 c4 10             	add    $0x10,%esp
80101e84:	e9 3a ff ff ff       	jmp    80101dc3 <namex+0x53>
80101e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e90:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101e93:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80101e96:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80101e99:	83 ec 04             	sub    $0x4,%esp
80101e9c:	50                   	push   %eax
80101e9d:	57                   	push   %edi
    name[len] = 0;
80101e9e:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80101ea0:	ff 75 e4             	pushl  -0x1c(%ebp)
80101ea3:	e8 38 2a 00 00       	call   801048e0 <memmove>
    name[len] = 0;
80101ea8:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101eab:	83 c4 10             	add    $0x10,%esp
80101eae:	c6 00 00             	movb   $0x0,(%eax)
80101eb1:	e9 69 ff ff ff       	jmp    80101e1f <namex+0xaf>
80101eb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ebd:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101ec0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101ec3:	85 c0                	test   %eax,%eax
80101ec5:	0f 85 85 00 00 00    	jne    80101f50 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
80101ecb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ece:	89 f0                	mov    %esi,%eax
80101ed0:	5b                   	pop    %ebx
80101ed1:	5e                   	pop    %esi
80101ed2:	5f                   	pop    %edi
80101ed3:	5d                   	pop    %ebp
80101ed4:	c3                   	ret    
80101ed5:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80101ed8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101edb:	89 fb                	mov    %edi,%ebx
80101edd:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101ee0:	31 c0                	xor    %eax,%eax
80101ee2:	eb b5                	jmp    80101e99 <namex+0x129>
80101ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101ee8:	83 ec 0c             	sub    $0xc,%esp
80101eeb:	56                   	push   %esi
80101eec:	e8 4f f9 ff ff       	call   80101840 <iunlock>
  iput(ip);
80101ef1:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101ef4:	31 f6                	xor    %esi,%esi
  iput(ip);
80101ef6:	e8 95 f9 ff ff       	call   80101890 <iput>
      return 0;
80101efb:	83 c4 10             	add    $0x10,%esp
}
80101efe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f01:	89 f0                	mov    %esi,%eax
80101f03:	5b                   	pop    %ebx
80101f04:	5e                   	pop    %esi
80101f05:	5f                   	pop    %edi
80101f06:	5d                   	pop    %ebp
80101f07:	c3                   	ret    
80101f08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f0f:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
80101f10:	ba 01 00 00 00       	mov    $0x1,%edx
80101f15:	b8 01 00 00 00       	mov    $0x1,%eax
80101f1a:	89 df                	mov    %ebx,%edi
80101f1c:	e8 1f f4 ff ff       	call   80101340 <iget>
80101f21:	89 c6                	mov    %eax,%esi
80101f23:	e9 9b fe ff ff       	jmp    80101dc3 <namex+0x53>
80101f28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f2f:	90                   	nop
      iunlock(ip);
80101f30:	83 ec 0c             	sub    $0xc,%esp
80101f33:	56                   	push   %esi
80101f34:	e8 07 f9 ff ff       	call   80101840 <iunlock>
      return ip;
80101f39:	83 c4 10             	add    $0x10,%esp
}
80101f3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f3f:	89 f0                	mov    %esi,%eax
80101f41:	5b                   	pop    %ebx
80101f42:	5e                   	pop    %esi
80101f43:	5f                   	pop    %edi
80101f44:	5d                   	pop    %ebp
80101f45:	c3                   	ret    
80101f46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f4d:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
80101f50:	83 ec 0c             	sub    $0xc,%esp
80101f53:	56                   	push   %esi
    return 0;
80101f54:	31 f6                	xor    %esi,%esi
    iput(ip);
80101f56:	e8 35 f9 ff ff       	call   80101890 <iput>
    return 0;
80101f5b:	83 c4 10             	add    $0x10,%esp
80101f5e:	e9 68 ff ff ff       	jmp    80101ecb <namex+0x15b>
80101f63:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101f70 <dirlink>:
{
80101f70:	f3 0f 1e fb          	endbr32 
80101f74:	55                   	push   %ebp
80101f75:	89 e5                	mov    %esp,%ebp
80101f77:	57                   	push   %edi
80101f78:	56                   	push   %esi
80101f79:	53                   	push   %ebx
80101f7a:	83 ec 20             	sub    $0x20,%esp
80101f7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101f80:	6a 00                	push   $0x0
80101f82:	ff 75 0c             	pushl  0xc(%ebp)
80101f85:	53                   	push   %ebx
80101f86:	e8 25 fd ff ff       	call   80101cb0 <dirlookup>
80101f8b:	83 c4 10             	add    $0x10,%esp
80101f8e:	85 c0                	test   %eax,%eax
80101f90:	75 6b                	jne    80101ffd <dirlink+0x8d>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101f92:	8b 7b 58             	mov    0x58(%ebx),%edi
80101f95:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f98:	85 ff                	test   %edi,%edi
80101f9a:	74 2d                	je     80101fc9 <dirlink+0x59>
80101f9c:	31 ff                	xor    %edi,%edi
80101f9e:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fa1:	eb 0d                	jmp    80101fb0 <dirlink+0x40>
80101fa3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101fa7:	90                   	nop
80101fa8:	83 c7 10             	add    $0x10,%edi
80101fab:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101fae:	73 19                	jae    80101fc9 <dirlink+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fb0:	6a 10                	push   $0x10
80101fb2:	57                   	push   %edi
80101fb3:	56                   	push   %esi
80101fb4:	53                   	push   %ebx
80101fb5:	e8 a6 fa ff ff       	call   80101a60 <readi>
80101fba:	83 c4 10             	add    $0x10,%esp
80101fbd:	83 f8 10             	cmp    $0x10,%eax
80101fc0:	75 4e                	jne    80102010 <dirlink+0xa0>
    if(de.inum == 0)
80101fc2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101fc7:	75 df                	jne    80101fa8 <dirlink+0x38>
  strncpy(de.name, name, DIRSIZ);
80101fc9:	83 ec 04             	sub    $0x4,%esp
80101fcc:	8d 45 da             	lea    -0x26(%ebp),%eax
80101fcf:	6a 0e                	push   $0xe
80101fd1:	ff 75 0c             	pushl  0xc(%ebp)
80101fd4:	50                   	push   %eax
80101fd5:	e8 c6 29 00 00       	call   801049a0 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fda:	6a 10                	push   $0x10
  de.inum = inum;
80101fdc:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fdf:	57                   	push   %edi
80101fe0:	56                   	push   %esi
80101fe1:	53                   	push   %ebx
  de.inum = inum;
80101fe2:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fe6:	e8 75 fb ff ff       	call   80101b60 <writei>
80101feb:	83 c4 20             	add    $0x20,%esp
80101fee:	83 f8 10             	cmp    $0x10,%eax
80101ff1:	75 2a                	jne    8010201d <dirlink+0xad>
  return 0;
80101ff3:	31 c0                	xor    %eax,%eax
}
80101ff5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ff8:	5b                   	pop    %ebx
80101ff9:	5e                   	pop    %esi
80101ffa:	5f                   	pop    %edi
80101ffb:	5d                   	pop    %ebp
80101ffc:	c3                   	ret    
    iput(ip);
80101ffd:	83 ec 0c             	sub    $0xc,%esp
80102000:	50                   	push   %eax
80102001:	e8 8a f8 ff ff       	call   80101890 <iput>
    return -1;
80102006:	83 c4 10             	add    $0x10,%esp
80102009:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010200e:	eb e5                	jmp    80101ff5 <dirlink+0x85>
      panic("dirlink read");
80102010:	83 ec 0c             	sub    $0xc,%esp
80102013:	68 a8 78 10 80       	push   $0x801078a8
80102018:	e8 73 e3 ff ff       	call   80100390 <panic>
    panic("dirlink");
8010201d:	83 ec 0c             	sub    $0xc,%esp
80102020:	68 a6 7f 10 80       	push   $0x80107fa6
80102025:	e8 66 e3 ff ff       	call   80100390 <panic>
8010202a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102030 <namei>:

struct inode*
namei(char *path)
{
80102030:	f3 0f 1e fb          	endbr32 
80102034:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102035:	31 d2                	xor    %edx,%edx
{
80102037:	89 e5                	mov    %esp,%ebp
80102039:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
8010203c:	8b 45 08             	mov    0x8(%ebp),%eax
8010203f:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80102042:	e8 29 fd ff ff       	call   80101d70 <namex>
}
80102047:	c9                   	leave  
80102048:	c3                   	ret    
80102049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102050 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102050:	f3 0f 1e fb          	endbr32 
80102054:	55                   	push   %ebp
  return namex(path, 1, name);
80102055:	ba 01 00 00 00       	mov    $0x1,%edx
{
8010205a:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
8010205c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010205f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102062:	5d                   	pop    %ebp
  return namex(path, 1, name);
80102063:	e9 08 fd ff ff       	jmp    80101d70 <namex>
80102068:	66 90                	xchg   %ax,%ax
8010206a:	66 90                	xchg   %ax,%ax
8010206c:	66 90                	xchg   %ax,%ax
8010206e:	66 90                	xchg   %ax,%ax

80102070 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102070:	55                   	push   %ebp
80102071:	89 e5                	mov    %esp,%ebp
80102073:	57                   	push   %edi
80102074:	56                   	push   %esi
80102075:	53                   	push   %ebx
80102076:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102079:	85 c0                	test   %eax,%eax
8010207b:	0f 84 b4 00 00 00    	je     80102135 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102081:	8b 70 08             	mov    0x8(%eax),%esi
80102084:	89 c3                	mov    %eax,%ebx
80102086:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010208c:	0f 87 96 00 00 00    	ja     80102128 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102092:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102097:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010209e:	66 90                	xchg   %ax,%ax
801020a0:	89 ca                	mov    %ecx,%edx
801020a2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020a3:	83 e0 c0             	and    $0xffffffc0,%eax
801020a6:	3c 40                	cmp    $0x40,%al
801020a8:	75 f6                	jne    801020a0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020aa:	31 ff                	xor    %edi,%edi
801020ac:	ba f6 03 00 00       	mov    $0x3f6,%edx
801020b1:	89 f8                	mov    %edi,%eax
801020b3:	ee                   	out    %al,(%dx)
801020b4:	b8 01 00 00 00       	mov    $0x1,%eax
801020b9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801020be:	ee                   	out    %al,(%dx)
801020bf:	ba f3 01 00 00       	mov    $0x1f3,%edx
801020c4:	89 f0                	mov    %esi,%eax
801020c6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801020c7:	89 f0                	mov    %esi,%eax
801020c9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801020ce:	c1 f8 08             	sar    $0x8,%eax
801020d1:	ee                   	out    %al,(%dx)
801020d2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801020d7:	89 f8                	mov    %edi,%eax
801020d9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801020da:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
801020de:	ba f6 01 00 00       	mov    $0x1f6,%edx
801020e3:	c1 e0 04             	shl    $0x4,%eax
801020e6:	83 e0 10             	and    $0x10,%eax
801020e9:	83 c8 e0             	or     $0xffffffe0,%eax
801020ec:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801020ed:	f6 03 04             	testb  $0x4,(%ebx)
801020f0:	75 16                	jne    80102108 <idestart+0x98>
801020f2:	b8 20 00 00 00       	mov    $0x20,%eax
801020f7:	89 ca                	mov    %ecx,%edx
801020f9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801020fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020fd:	5b                   	pop    %ebx
801020fe:	5e                   	pop    %esi
801020ff:	5f                   	pop    %edi
80102100:	5d                   	pop    %ebp
80102101:	c3                   	ret    
80102102:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102108:	b8 30 00 00 00       	mov    $0x30,%eax
8010210d:	89 ca                	mov    %ecx,%edx
8010210f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102110:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102115:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102118:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010211d:	fc                   	cld    
8010211e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102120:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102123:	5b                   	pop    %ebx
80102124:	5e                   	pop    %esi
80102125:	5f                   	pop    %edi
80102126:	5d                   	pop    %ebp
80102127:	c3                   	ret    
    panic("incorrect blockno");
80102128:	83 ec 0c             	sub    $0xc,%esp
8010212b:	68 14 79 10 80       	push   $0x80107914
80102130:	e8 5b e2 ff ff       	call   80100390 <panic>
    panic("idestart");
80102135:	83 ec 0c             	sub    $0xc,%esp
80102138:	68 0b 79 10 80       	push   $0x8010790b
8010213d:	e8 4e e2 ff ff       	call   80100390 <panic>
80102142:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102150 <ideinit>:
{
80102150:	f3 0f 1e fb          	endbr32 
80102154:	55                   	push   %ebp
80102155:	89 e5                	mov    %esp,%ebp
80102157:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
8010215a:	68 26 79 10 80       	push   $0x80107926
8010215f:	68 80 b5 10 80       	push   $0x8010b580
80102164:	e8 47 24 00 00       	call   801045b0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102169:	58                   	pop    %eax
8010216a:	a1 50 38 11 80       	mov    0x80113850,%eax
8010216f:	5a                   	pop    %edx
80102170:	83 e8 01             	sub    $0x1,%eax
80102173:	50                   	push   %eax
80102174:	6a 0e                	push   $0xe
80102176:	e8 b5 02 00 00       	call   80102430 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
8010217b:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010217e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102183:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102187:	90                   	nop
80102188:	ec                   	in     (%dx),%al
80102189:	83 e0 c0             	and    $0xffffffc0,%eax
8010218c:	3c 40                	cmp    $0x40,%al
8010218e:	75 f8                	jne    80102188 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102190:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80102195:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010219a:	ee                   	out    %al,(%dx)
8010219b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021a0:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021a5:	eb 0e                	jmp    801021b5 <ideinit+0x65>
801021a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021ae:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
801021b0:	83 e9 01             	sub    $0x1,%ecx
801021b3:	74 0f                	je     801021c4 <ideinit+0x74>
801021b5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801021b6:	84 c0                	test   %al,%al
801021b8:	74 f6                	je     801021b0 <ideinit+0x60>
      havedisk1 = 1;
801021ba:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
801021c1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021c4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801021c9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021ce:	ee                   	out    %al,(%dx)
}
801021cf:	c9                   	leave  
801021d0:	c3                   	ret    
801021d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021df:	90                   	nop

801021e0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801021e0:	f3 0f 1e fb          	endbr32 
801021e4:	55                   	push   %ebp
801021e5:	89 e5                	mov    %esp,%ebp
801021e7:	57                   	push   %edi
801021e8:	56                   	push   %esi
801021e9:	53                   	push   %ebx
801021ea:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801021ed:	68 80 b5 10 80       	push   $0x8010b580
801021f2:	e8 39 25 00 00       	call   80104730 <acquire>

  if((b = idequeue) == 0){
801021f7:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
801021fd:	83 c4 10             	add    $0x10,%esp
80102200:	85 db                	test   %ebx,%ebx
80102202:	74 5f                	je     80102263 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102204:	8b 43 58             	mov    0x58(%ebx),%eax
80102207:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010220c:	8b 33                	mov    (%ebx),%esi
8010220e:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102214:	75 2b                	jne    80102241 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102216:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010221b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010221f:	90                   	nop
80102220:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102221:	89 c1                	mov    %eax,%ecx
80102223:	83 e1 c0             	and    $0xffffffc0,%ecx
80102226:	80 f9 40             	cmp    $0x40,%cl
80102229:	75 f5                	jne    80102220 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010222b:	a8 21                	test   $0x21,%al
8010222d:	75 12                	jne    80102241 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010222f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102232:	b9 80 00 00 00       	mov    $0x80,%ecx
80102237:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010223c:	fc                   	cld    
8010223d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010223f:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102241:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102244:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102247:	83 ce 02             	or     $0x2,%esi
8010224a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010224c:	53                   	push   %ebx
8010224d:	e8 5e 20 00 00       	call   801042b0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102252:	a1 64 b5 10 80       	mov    0x8010b564,%eax
80102257:	83 c4 10             	add    $0x10,%esp
8010225a:	85 c0                	test   %eax,%eax
8010225c:	74 05                	je     80102263 <ideintr+0x83>
    idestart(idequeue);
8010225e:	e8 0d fe ff ff       	call   80102070 <idestart>
    release(&idelock);
80102263:	83 ec 0c             	sub    $0xc,%esp
80102266:	68 80 b5 10 80       	push   $0x8010b580
8010226b:	e8 80 25 00 00       	call   801047f0 <release>

  release(&idelock);
}
80102270:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102273:	5b                   	pop    %ebx
80102274:	5e                   	pop    %esi
80102275:	5f                   	pop    %edi
80102276:	5d                   	pop    %ebp
80102277:	c3                   	ret    
80102278:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010227f:	90                   	nop

80102280 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102280:	f3 0f 1e fb          	endbr32 
80102284:	55                   	push   %ebp
80102285:	89 e5                	mov    %esp,%ebp
80102287:	53                   	push   %ebx
80102288:	83 ec 10             	sub    $0x10,%esp
8010228b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010228e:	8d 43 0c             	lea    0xc(%ebx),%eax
80102291:	50                   	push   %eax
80102292:	e8 b9 22 00 00       	call   80104550 <holdingsleep>
80102297:	83 c4 10             	add    $0x10,%esp
8010229a:	85 c0                	test   %eax,%eax
8010229c:	0f 84 cf 00 00 00    	je     80102371 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801022a2:	8b 03                	mov    (%ebx),%eax
801022a4:	83 e0 06             	and    $0x6,%eax
801022a7:	83 f8 02             	cmp    $0x2,%eax
801022aa:	0f 84 b4 00 00 00    	je     80102364 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801022b0:	8b 53 04             	mov    0x4(%ebx),%edx
801022b3:	85 d2                	test   %edx,%edx
801022b5:	74 0d                	je     801022c4 <iderw+0x44>
801022b7:	a1 60 b5 10 80       	mov    0x8010b560,%eax
801022bc:	85 c0                	test   %eax,%eax
801022be:	0f 84 93 00 00 00    	je     80102357 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801022c4:	83 ec 0c             	sub    $0xc,%esp
801022c7:	68 80 b5 10 80       	push   $0x8010b580
801022cc:	e8 5f 24 00 00       	call   80104730 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801022d1:	a1 64 b5 10 80       	mov    0x8010b564,%eax
  b->qnext = 0;
801022d6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801022dd:	83 c4 10             	add    $0x10,%esp
801022e0:	85 c0                	test   %eax,%eax
801022e2:	74 6c                	je     80102350 <iderw+0xd0>
801022e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801022e8:	89 c2                	mov    %eax,%edx
801022ea:	8b 40 58             	mov    0x58(%eax),%eax
801022ed:	85 c0                	test   %eax,%eax
801022ef:	75 f7                	jne    801022e8 <iderw+0x68>
801022f1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801022f4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801022f6:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
801022fc:	74 42                	je     80102340 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801022fe:	8b 03                	mov    (%ebx),%eax
80102300:	83 e0 06             	and    $0x6,%eax
80102303:	83 f8 02             	cmp    $0x2,%eax
80102306:	74 23                	je     8010232b <iderw+0xab>
80102308:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010230f:	90                   	nop
    sleep(b, &idelock);
80102310:	83 ec 08             	sub    $0x8,%esp
80102313:	68 80 b5 10 80       	push   $0x8010b580
80102318:	53                   	push   %ebx
80102319:	e8 c2 1d 00 00       	call   801040e0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010231e:	8b 03                	mov    (%ebx),%eax
80102320:	83 c4 10             	add    $0x10,%esp
80102323:	83 e0 06             	and    $0x6,%eax
80102326:	83 f8 02             	cmp    $0x2,%eax
80102329:	75 e5                	jne    80102310 <iderw+0x90>
  }


  release(&idelock);
8010232b:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
80102332:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102335:	c9                   	leave  
  release(&idelock);
80102336:	e9 b5 24 00 00       	jmp    801047f0 <release>
8010233b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010233f:	90                   	nop
    idestart(b);
80102340:	89 d8                	mov    %ebx,%eax
80102342:	e8 29 fd ff ff       	call   80102070 <idestart>
80102347:	eb b5                	jmp    801022fe <iderw+0x7e>
80102349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102350:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
80102355:	eb 9d                	jmp    801022f4 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
80102357:	83 ec 0c             	sub    $0xc,%esp
8010235a:	68 55 79 10 80       	push   $0x80107955
8010235f:	e8 2c e0 ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
80102364:	83 ec 0c             	sub    $0xc,%esp
80102367:	68 40 79 10 80       	push   $0x80107940
8010236c:	e8 1f e0 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102371:	83 ec 0c             	sub    $0xc,%esp
80102374:	68 2a 79 10 80       	push   $0x8010792a
80102379:	e8 12 e0 ff ff       	call   80100390 <panic>
8010237e:	66 90                	xchg   %ax,%ax

80102380 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102380:	f3 0f 1e fb          	endbr32 
80102384:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102385:	c7 05 34 36 11 80 00 	movl   $0xfec00000,0x80113634
8010238c:	00 c0 fe 
{
8010238f:	89 e5                	mov    %esp,%ebp
80102391:	56                   	push   %esi
80102392:	53                   	push   %ebx
  ioapic->reg = reg;
80102393:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
8010239a:	00 00 00 
  return ioapic->data;
8010239d:	8b 15 34 36 11 80    	mov    0x80113634,%edx
801023a3:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801023a6:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801023ac:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023b2:	0f b6 15 80 37 11 80 	movzbl 0x80113780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801023b9:	c1 ee 10             	shr    $0x10,%esi
801023bc:	89 f0                	mov    %esi,%eax
801023be:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801023c1:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
801023c4:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801023c7:	39 c2                	cmp    %eax,%edx
801023c9:	74 16                	je     801023e1 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801023cb:	83 ec 0c             	sub    $0xc,%esp
801023ce:	68 74 79 10 80       	push   $0x80107974
801023d3:	e8 d8 e2 ff ff       	call   801006b0 <cprintf>
801023d8:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
801023de:	83 c4 10             	add    $0x10,%esp
801023e1:	83 c6 21             	add    $0x21,%esi
{
801023e4:	ba 10 00 00 00       	mov    $0x10,%edx
801023e9:	b8 20 00 00 00       	mov    $0x20,%eax
801023ee:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
801023f0:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801023f2:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
801023f4:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
801023fa:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801023fd:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102403:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102406:	8d 5a 01             	lea    0x1(%edx),%ebx
80102409:	83 c2 02             	add    $0x2,%edx
8010240c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010240e:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
80102414:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010241b:	39 f0                	cmp    %esi,%eax
8010241d:	75 d1                	jne    801023f0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010241f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102422:	5b                   	pop    %ebx
80102423:	5e                   	pop    %esi
80102424:	5d                   	pop    %ebp
80102425:	c3                   	ret    
80102426:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010242d:	8d 76 00             	lea    0x0(%esi),%esi

80102430 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102430:	f3 0f 1e fb          	endbr32 
80102434:	55                   	push   %ebp
  ioapic->reg = reg;
80102435:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
{
8010243b:	89 e5                	mov    %esp,%ebp
8010243d:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102440:	8d 50 20             	lea    0x20(%eax),%edx
80102443:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102447:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102449:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010244f:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102452:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102455:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102458:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
8010245a:	a1 34 36 11 80       	mov    0x80113634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010245f:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102462:	89 50 10             	mov    %edx,0x10(%eax)
}
80102465:	5d                   	pop    %ebp
80102466:	c3                   	ret    
80102467:	66 90                	xchg   %ax,%ax
80102469:	66 90                	xchg   %ax,%ax
8010246b:	66 90                	xchg   %ax,%ax
8010246d:	66 90                	xchg   %ax,%ax
8010246f:	90                   	nop

80102470 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102470:	f3 0f 1e fb          	endbr32 
80102474:	55                   	push   %ebp
80102475:	89 e5                	mov    %esp,%ebp
80102477:	53                   	push   %ebx
80102478:	83 ec 04             	sub    $0x4,%esp
8010247b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010247e:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102484:	0f 85 7e 00 00 00    	jne    80102508 <kfree+0x98>
8010248a:	81 fb 00 41 1a 80    	cmp    $0x801a4100,%ebx
80102490:	72 76                	jb     80102508 <kfree+0x98>
80102492:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102498:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
8010249d:	77 69                	ja     80102508 <kfree+0x98>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
8010249f:	83 ec 04             	sub    $0x4,%esp
801024a2:	68 00 10 00 00       	push   $0x1000
801024a7:	6a 01                	push   $0x1
801024a9:	53                   	push   %ebx
801024aa:	e8 91 23 00 00       	call   80104840 <memset>

  if(kmem.use_lock)
801024af:	8b 15 74 36 11 80    	mov    0x80113674,%edx
801024b5:	83 c4 10             	add    $0x10,%esp
801024b8:	85 d2                	test   %edx,%edx
801024ba:	75 24                	jne    801024e0 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801024bc:	a1 7c 36 11 80       	mov    0x8011367c,%eax
801024c1:	89 03                	mov    %eax,(%ebx)
  kmem.num_free_pages+=1;
  kmem.freelist = r;
  if(kmem.use_lock)
801024c3:	a1 74 36 11 80       	mov    0x80113674,%eax
  kmem.num_free_pages+=1;
801024c8:	83 05 78 36 11 80 01 	addl   $0x1,0x80113678
  kmem.freelist = r;
801024cf:	89 1d 7c 36 11 80    	mov    %ebx,0x8011367c
  if(kmem.use_lock)
801024d5:	85 c0                	test   %eax,%eax
801024d7:	75 1f                	jne    801024f8 <kfree+0x88>
    release(&kmem.lock);
}
801024d9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024dc:	c9                   	leave  
801024dd:	c3                   	ret    
801024de:	66 90                	xchg   %ax,%ax
    acquire(&kmem.lock);
801024e0:	83 ec 0c             	sub    $0xc,%esp
801024e3:	68 40 36 11 80       	push   $0x80113640
801024e8:	e8 43 22 00 00       	call   80104730 <acquire>
801024ed:	83 c4 10             	add    $0x10,%esp
801024f0:	eb ca                	jmp    801024bc <kfree+0x4c>
801024f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
801024f8:	c7 45 08 40 36 11 80 	movl   $0x80113640,0x8(%ebp)
}
801024ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102502:	c9                   	leave  
    release(&kmem.lock);
80102503:	e9 e8 22 00 00       	jmp    801047f0 <release>
    panic("kfree");
80102508:	83 ec 0c             	sub    $0xc,%esp
8010250b:	68 a6 79 10 80       	push   $0x801079a6
80102510:	e8 7b de ff ff       	call   80100390 <panic>
80102515:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010251c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102520 <freerange>:
{
80102520:	f3 0f 1e fb          	endbr32 
80102524:	55                   	push   %ebp
80102525:	89 e5                	mov    %esp,%ebp
80102527:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102528:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010252b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010252e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010252f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102535:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010253b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102541:	39 de                	cmp    %ebx,%esi
80102543:	72 1f                	jb     80102564 <freerange+0x44>
80102545:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102548:	83 ec 0c             	sub    $0xc,%esp
8010254b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102551:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102557:	50                   	push   %eax
80102558:	e8 13 ff ff ff       	call   80102470 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010255d:	83 c4 10             	add    $0x10,%esp
80102560:	39 f3                	cmp    %esi,%ebx
80102562:	76 e4                	jbe    80102548 <freerange+0x28>
}
80102564:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102567:	5b                   	pop    %ebx
80102568:	5e                   	pop    %esi
80102569:	5d                   	pop    %ebp
8010256a:	c3                   	ret    
8010256b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010256f:	90                   	nop

80102570 <kinit1>:
{
80102570:	f3 0f 1e fb          	endbr32 
80102574:	55                   	push   %ebp
80102575:	89 e5                	mov    %esp,%ebp
80102577:	56                   	push   %esi
80102578:	53                   	push   %ebx
80102579:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010257c:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010257f:	81 c3 ff 0f 00 00    	add    $0xfff,%ebx
  initlock(&kmem.lock, "kmem");
80102585:	83 ec 08             	sub    $0x8,%esp
  p = (char*)PGROUNDUP((uint)vstart);
80102588:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  initlock(&kmem.lock, "kmem");
8010258e:	68 ac 79 10 80       	push   $0x801079ac
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102593:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  initlock(&kmem.lock, "kmem");
80102599:	68 40 36 11 80       	push   $0x80113640
8010259e:	e8 0d 20 00 00       	call   801045b0 <initlock>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025a3:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
801025a6:	c7 05 74 36 11 80 00 	movl   $0x0,0x80113674
801025ad:	00 00 00 
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025b0:	39 de                	cmp    %ebx,%esi
801025b2:	72 20                	jb     801025d4 <kinit1+0x64>
801025b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025b8:	83 ec 0c             	sub    $0xc,%esp
801025bb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025c1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025c7:	50                   	push   %eax
801025c8:	e8 a3 fe ff ff       	call   80102470 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025cd:	83 c4 10             	add    $0x10,%esp
801025d0:	39 de                	cmp    %ebx,%esi
801025d2:	73 e4                	jae    801025b8 <kinit1+0x48>
}
801025d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025d7:	5b                   	pop    %ebx
801025d8:	5e                   	pop    %esi
801025d9:	5d                   	pop    %ebp
  init_rmap();
801025da:	e9 11 4e 00 00       	jmp    801073f0 <init_rmap>
801025df:	90                   	nop

801025e0 <kinit2>:
{
801025e0:	f3 0f 1e fb          	endbr32 
801025e4:	55                   	push   %ebp
801025e5:	89 e5                	mov    %esp,%ebp
801025e7:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801025e8:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025eb:	8b 75 0c             	mov    0xc(%ebp),%esi
801025ee:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025ef:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025f5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025fb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102601:	39 de                	cmp    %ebx,%esi
80102603:	72 1f                	jb     80102624 <kinit2+0x44>
80102605:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102608:	83 ec 0c             	sub    $0xc,%esp
8010260b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102611:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102617:	50                   	push   %eax
80102618:	e8 53 fe ff ff       	call   80102470 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010261d:	83 c4 10             	add    $0x10,%esp
80102620:	39 de                	cmp    %ebx,%esi
80102622:	73 e4                	jae    80102608 <kinit2+0x28>
  kmem.use_lock = 1;
80102624:	c7 05 74 36 11 80 01 	movl   $0x1,0x80113674
8010262b:	00 00 00 
}
8010262e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102631:	5b                   	pop    %ebx
80102632:	5e                   	pop    %esi
80102633:	5d                   	pop    %ebp
80102634:	c3                   	ret    
80102635:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010263c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102640 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102640:	f3 0f 1e fb          	endbr32 
  struct run *r;

  if(kmem.use_lock)
80102644:	a1 74 36 11 80       	mov    0x80113674,%eax
80102649:	85 c0                	test   %eax,%eax
8010264b:	75 2b                	jne    80102678 <kalloc+0x38>
    acquire(&kmem.lock);
  r = kmem.freelist;
8010264d:	a1 7c 36 11 80       	mov    0x8011367c,%eax
  if(r)
80102652:	85 c0                	test   %eax,%eax
80102654:	74 1a                	je     80102670 <kalloc+0x30>
  {
    kmem.freelist = r->next;
80102656:	8b 10                	mov    (%eax),%edx
    kmem.num_free_pages-=1;
80102658:	83 2d 78 36 11 80 01 	subl   $0x1,0x80113678
    kmem.freelist = r->next;
8010265f:	89 15 7c 36 11 80    	mov    %edx,0x8011367c
  }
    
  if(kmem.use_lock)
80102665:	c3                   	ret    
80102666:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010266d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&kmem.lock);
  return (char*)r;
}
80102670:	c3                   	ret    
80102671:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102678:	55                   	push   %ebp
80102679:	89 e5                	mov    %esp,%ebp
8010267b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010267e:	68 40 36 11 80       	push   $0x80113640
80102683:	e8 a8 20 00 00       	call   80104730 <acquire>
  r = kmem.freelist;
80102688:	a1 7c 36 11 80       	mov    0x8011367c,%eax
  if(r)
8010268d:	8b 15 74 36 11 80    	mov    0x80113674,%edx
80102693:	83 c4 10             	add    $0x10,%esp
80102696:	85 c0                	test   %eax,%eax
80102698:	74 0f                	je     801026a9 <kalloc+0x69>
    kmem.freelist = r->next;
8010269a:	8b 08                	mov    (%eax),%ecx
    kmem.num_free_pages-=1;
8010269c:	83 2d 78 36 11 80 01 	subl   $0x1,0x80113678
    kmem.freelist = r->next;
801026a3:	89 0d 7c 36 11 80    	mov    %ecx,0x8011367c
  if(kmem.use_lock)
801026a9:	85 d2                	test   %edx,%edx
801026ab:	74 16                	je     801026c3 <kalloc+0x83>
    release(&kmem.lock);
801026ad:	83 ec 0c             	sub    $0xc,%esp
801026b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801026b3:	68 40 36 11 80       	push   $0x80113640
801026b8:	e8 33 21 00 00       	call   801047f0 <release>
  return (char*)r;
801026bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801026c0:	83 c4 10             	add    $0x10,%esp
}
801026c3:	c9                   	leave  
801026c4:	c3                   	ret    
801026c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801026d0 <num_of_FreePages>:
uint 
num_of_FreePages(void)
{
801026d0:	f3 0f 1e fb          	endbr32 
801026d4:	55                   	push   %ebp
801026d5:	89 e5                	mov    %esp,%ebp
801026d7:	53                   	push   %ebx
801026d8:	83 ec 10             	sub    $0x10,%esp
  acquire(&kmem.lock);
801026db:	68 40 36 11 80       	push   $0x80113640
801026e0:	e8 4b 20 00 00       	call   80104730 <acquire>

  uint num_free_pages = kmem.num_free_pages;
801026e5:	8b 1d 78 36 11 80    	mov    0x80113678,%ebx
  
  release(&kmem.lock);
801026eb:	c7 04 24 40 36 11 80 	movl   $0x80113640,(%esp)
801026f2:	e8 f9 20 00 00       	call   801047f0 <release>
  
  return num_free_pages;
}
801026f7:	89 d8                	mov    %ebx,%eax
801026f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801026fc:	c9                   	leave  
801026fd:	c3                   	ret    
801026fe:	66 90                	xchg   %ax,%ax

80102700 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102700:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102704:	ba 64 00 00 00       	mov    $0x64,%edx
80102709:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
8010270a:	a8 01                	test   $0x1,%al
8010270c:	0f 84 be 00 00 00    	je     801027d0 <kbdgetc+0xd0>
{
80102712:	55                   	push   %ebp
80102713:	ba 60 00 00 00       	mov    $0x60,%edx
80102718:	89 e5                	mov    %esp,%ebp
8010271a:	53                   	push   %ebx
8010271b:	ec                   	in     (%dx),%al
  return data;
8010271c:	8b 1d b4 b5 10 80    	mov    0x8010b5b4,%ebx
    return -1;
  data = inb(KBDATAP);
80102722:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
80102725:	3c e0                	cmp    $0xe0,%al
80102727:	74 57                	je     80102780 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102729:	89 d9                	mov    %ebx,%ecx
8010272b:	83 e1 40             	and    $0x40,%ecx
8010272e:	84 c0                	test   %al,%al
80102730:	78 5e                	js     80102790 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102732:	85 c9                	test   %ecx,%ecx
80102734:	74 09                	je     8010273f <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102736:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102739:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
8010273c:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
8010273f:	0f b6 8a e0 7a 10 80 	movzbl -0x7fef8520(%edx),%ecx
  shift ^= togglecode[data];
80102746:	0f b6 82 e0 79 10 80 	movzbl -0x7fef8620(%edx),%eax
  shift |= shiftcode[data];
8010274d:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
8010274f:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102751:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102753:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102759:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010275c:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
8010275f:	8b 04 85 c0 79 10 80 	mov    -0x7fef8640(,%eax,4),%eax
80102766:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010276a:	74 0b                	je     80102777 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
8010276c:	8d 50 9f             	lea    -0x61(%eax),%edx
8010276f:	83 fa 19             	cmp    $0x19,%edx
80102772:	77 44                	ja     801027b8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102774:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102777:	5b                   	pop    %ebx
80102778:	5d                   	pop    %ebp
80102779:	c3                   	ret    
8010277a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
80102780:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102783:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102785:	89 1d b4 b5 10 80    	mov    %ebx,0x8010b5b4
}
8010278b:	5b                   	pop    %ebx
8010278c:	5d                   	pop    %ebp
8010278d:	c3                   	ret    
8010278e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102790:	83 e0 7f             	and    $0x7f,%eax
80102793:	85 c9                	test   %ecx,%ecx
80102795:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80102798:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010279a:	0f b6 8a e0 7a 10 80 	movzbl -0x7fef8520(%edx),%ecx
801027a1:	83 c9 40             	or     $0x40,%ecx
801027a4:	0f b6 c9             	movzbl %cl,%ecx
801027a7:	f7 d1                	not    %ecx
801027a9:	21 d9                	and    %ebx,%ecx
}
801027ab:	5b                   	pop    %ebx
801027ac:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
801027ad:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
801027b3:	c3                   	ret    
801027b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
801027b8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801027bb:	8d 50 20             	lea    0x20(%eax),%edx
}
801027be:	5b                   	pop    %ebx
801027bf:	5d                   	pop    %ebp
      c += 'a' - 'A';
801027c0:	83 f9 1a             	cmp    $0x1a,%ecx
801027c3:	0f 42 c2             	cmovb  %edx,%eax
}
801027c6:	c3                   	ret    
801027c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027ce:	66 90                	xchg   %ax,%ax
    return -1;
801027d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801027d5:	c3                   	ret    
801027d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027dd:	8d 76 00             	lea    0x0(%esi),%esi

801027e0 <kbdintr>:

void
kbdintr(void)
{
801027e0:	f3 0f 1e fb          	endbr32 
801027e4:	55                   	push   %ebp
801027e5:	89 e5                	mov    %esp,%ebp
801027e7:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801027ea:	68 00 27 10 80       	push   $0x80102700
801027ef:	e8 6c e0 ff ff       	call   80100860 <consoleintr>
}
801027f4:	83 c4 10             	add    $0x10,%esp
801027f7:	c9                   	leave  
801027f8:	c3                   	ret    
801027f9:	66 90                	xchg   %ax,%ax
801027fb:	66 90                	xchg   %ax,%ax
801027fd:	66 90                	xchg   %ax,%ax
801027ff:	90                   	nop

80102800 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
80102800:	f3 0f 1e fb          	endbr32 
  if(!lapic)
80102804:	a1 80 36 11 80       	mov    0x80113680,%eax
80102809:	85 c0                	test   %eax,%eax
8010280b:	0f 84 c7 00 00 00    	je     801028d8 <lapicinit+0xd8>
  lapic[index] = value;
80102811:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102818:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010281b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010281e:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102825:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102828:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010282b:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102832:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102835:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102838:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010283f:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102842:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102845:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010284c:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010284f:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102852:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102859:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010285c:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010285f:	8b 50 30             	mov    0x30(%eax),%edx
80102862:	c1 ea 10             	shr    $0x10,%edx
80102865:	81 e2 fc 00 00 00    	and    $0xfc,%edx
8010286b:	75 73                	jne    801028e0 <lapicinit+0xe0>
  lapic[index] = value;
8010286d:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102874:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102877:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010287a:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102881:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102884:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102887:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010288e:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102891:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102894:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
8010289b:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010289e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028a1:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801028a8:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028ab:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028ae:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801028b5:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801028b8:	8b 50 20             	mov    0x20(%eax),%edx
801028bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028bf:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801028c0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801028c6:	80 e6 10             	and    $0x10,%dh
801028c9:	75 f5                	jne    801028c0 <lapicinit+0xc0>
  lapic[index] = value;
801028cb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801028d2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028d5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801028d8:	c3                   	ret    
801028d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
801028e0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801028e7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028ea:	8b 50 20             	mov    0x20(%eax),%edx
}
801028ed:	e9 7b ff ff ff       	jmp    8010286d <lapicinit+0x6d>
801028f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102900 <lapicid>:

int
lapicid(void)
{
80102900:	f3 0f 1e fb          	endbr32 
  if (!lapic)
80102904:	a1 80 36 11 80       	mov    0x80113680,%eax
80102909:	85 c0                	test   %eax,%eax
8010290b:	74 0b                	je     80102918 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
8010290d:	8b 40 20             	mov    0x20(%eax),%eax
80102910:	c1 e8 18             	shr    $0x18,%eax
80102913:	c3                   	ret    
80102914:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80102918:	31 c0                	xor    %eax,%eax
}
8010291a:	c3                   	ret    
8010291b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010291f:	90                   	nop

80102920 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102920:	f3 0f 1e fb          	endbr32 
  if(lapic)
80102924:	a1 80 36 11 80       	mov    0x80113680,%eax
80102929:	85 c0                	test   %eax,%eax
8010292b:	74 0d                	je     8010293a <lapiceoi+0x1a>
  lapic[index] = value;
8010292d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102934:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102937:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
8010293a:	c3                   	ret    
8010293b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010293f:	90                   	nop

80102940 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102940:	f3 0f 1e fb          	endbr32 
}
80102944:	c3                   	ret    
80102945:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010294c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102950 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102950:	f3 0f 1e fb          	endbr32 
80102954:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102955:	b8 0f 00 00 00       	mov    $0xf,%eax
8010295a:	ba 70 00 00 00       	mov    $0x70,%edx
8010295f:	89 e5                	mov    %esp,%ebp
80102961:	53                   	push   %ebx
80102962:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102965:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102968:	ee                   	out    %al,(%dx)
80102969:	b8 0a 00 00 00       	mov    $0xa,%eax
8010296e:	ba 71 00 00 00       	mov    $0x71,%edx
80102973:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102974:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102976:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102979:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010297f:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102981:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102984:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102986:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102989:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
8010298c:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102992:	a1 80 36 11 80       	mov    0x80113680,%eax
80102997:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010299d:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029a0:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801029a7:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029aa:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029ad:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801029b4:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029b7:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029ba:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029c0:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029c3:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029c9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029cc:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029d2:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029d5:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
801029db:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
801029dc:	8b 40 20             	mov    0x20(%eax),%eax
}
801029df:	5d                   	pop    %ebp
801029e0:	c3                   	ret    
801029e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029ef:	90                   	nop

801029f0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801029f0:	f3 0f 1e fb          	endbr32 
801029f4:	55                   	push   %ebp
801029f5:	b8 0b 00 00 00       	mov    $0xb,%eax
801029fa:	ba 70 00 00 00       	mov    $0x70,%edx
801029ff:	89 e5                	mov    %esp,%ebp
80102a01:	57                   	push   %edi
80102a02:	56                   	push   %esi
80102a03:	53                   	push   %ebx
80102a04:	83 ec 4c             	sub    $0x4c,%esp
80102a07:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a08:	ba 71 00 00 00       	mov    $0x71,%edx
80102a0d:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102a0e:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a11:	bb 70 00 00 00       	mov    $0x70,%ebx
80102a16:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a20:	31 c0                	xor    %eax,%eax
80102a22:	89 da                	mov    %ebx,%edx
80102a24:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a25:	b9 71 00 00 00       	mov    $0x71,%ecx
80102a2a:	89 ca                	mov    %ecx,%edx
80102a2c:	ec                   	in     (%dx),%al
80102a2d:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a30:	89 da                	mov    %ebx,%edx
80102a32:	b8 02 00 00 00       	mov    $0x2,%eax
80102a37:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a38:	89 ca                	mov    %ecx,%edx
80102a3a:	ec                   	in     (%dx),%al
80102a3b:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a3e:	89 da                	mov    %ebx,%edx
80102a40:	b8 04 00 00 00       	mov    $0x4,%eax
80102a45:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a46:	89 ca                	mov    %ecx,%edx
80102a48:	ec                   	in     (%dx),%al
80102a49:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a4c:	89 da                	mov    %ebx,%edx
80102a4e:	b8 07 00 00 00       	mov    $0x7,%eax
80102a53:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a54:	89 ca                	mov    %ecx,%edx
80102a56:	ec                   	in     (%dx),%al
80102a57:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a5a:	89 da                	mov    %ebx,%edx
80102a5c:	b8 08 00 00 00       	mov    $0x8,%eax
80102a61:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a62:	89 ca                	mov    %ecx,%edx
80102a64:	ec                   	in     (%dx),%al
80102a65:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a67:	89 da                	mov    %ebx,%edx
80102a69:	b8 09 00 00 00       	mov    $0x9,%eax
80102a6e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a6f:	89 ca                	mov    %ecx,%edx
80102a71:	ec                   	in     (%dx),%al
80102a72:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a74:	89 da                	mov    %ebx,%edx
80102a76:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a7b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a7c:	89 ca                	mov    %ecx,%edx
80102a7e:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a7f:	84 c0                	test   %al,%al
80102a81:	78 9d                	js     80102a20 <cmostime+0x30>
  return inb(CMOS_RETURN);
80102a83:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a87:	89 fa                	mov    %edi,%edx
80102a89:	0f b6 fa             	movzbl %dl,%edi
80102a8c:	89 f2                	mov    %esi,%edx
80102a8e:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a91:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a95:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a98:	89 da                	mov    %ebx,%edx
80102a9a:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102a9d:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102aa0:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102aa4:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102aa7:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102aaa:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102aae:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102ab1:	31 c0                	xor    %eax,%eax
80102ab3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ab4:	89 ca                	mov    %ecx,%edx
80102ab6:	ec                   	in     (%dx),%al
80102ab7:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aba:	89 da                	mov    %ebx,%edx
80102abc:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102abf:	b8 02 00 00 00       	mov    $0x2,%eax
80102ac4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ac5:	89 ca                	mov    %ecx,%edx
80102ac7:	ec                   	in     (%dx),%al
80102ac8:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102acb:	89 da                	mov    %ebx,%edx
80102acd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102ad0:	b8 04 00 00 00       	mov    $0x4,%eax
80102ad5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ad6:	89 ca                	mov    %ecx,%edx
80102ad8:	ec                   	in     (%dx),%al
80102ad9:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102adc:	89 da                	mov    %ebx,%edx
80102ade:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102ae1:	b8 07 00 00 00       	mov    $0x7,%eax
80102ae6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ae7:	89 ca                	mov    %ecx,%edx
80102ae9:	ec                   	in     (%dx),%al
80102aea:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aed:	89 da                	mov    %ebx,%edx
80102aef:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102af2:	b8 08 00 00 00       	mov    $0x8,%eax
80102af7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102af8:	89 ca                	mov    %ecx,%edx
80102afa:	ec                   	in     (%dx),%al
80102afb:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102afe:	89 da                	mov    %ebx,%edx
80102b00:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102b03:	b8 09 00 00 00       	mov    $0x9,%eax
80102b08:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b09:	89 ca                	mov    %ecx,%edx
80102b0b:	ec                   	in     (%dx),%al
80102b0c:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b0f:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102b12:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b15:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102b18:	6a 18                	push   $0x18
80102b1a:	50                   	push   %eax
80102b1b:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102b1e:	50                   	push   %eax
80102b1f:	e8 6c 1d 00 00       	call   80104890 <memcmp>
80102b24:	83 c4 10             	add    $0x10,%esp
80102b27:	85 c0                	test   %eax,%eax
80102b29:	0f 85 f1 fe ff ff    	jne    80102a20 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102b2f:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102b33:	75 78                	jne    80102bad <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102b35:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b38:	89 c2                	mov    %eax,%edx
80102b3a:	83 e0 0f             	and    $0xf,%eax
80102b3d:	c1 ea 04             	shr    $0x4,%edx
80102b40:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b43:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b46:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b49:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b4c:	89 c2                	mov    %eax,%edx
80102b4e:	83 e0 0f             	and    $0xf,%eax
80102b51:	c1 ea 04             	shr    $0x4,%edx
80102b54:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b57:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b5a:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b5d:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b60:	89 c2                	mov    %eax,%edx
80102b62:	83 e0 0f             	and    $0xf,%eax
80102b65:	c1 ea 04             	shr    $0x4,%edx
80102b68:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b6b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b6e:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b71:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b74:	89 c2                	mov    %eax,%edx
80102b76:	83 e0 0f             	and    $0xf,%eax
80102b79:	c1 ea 04             	shr    $0x4,%edx
80102b7c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b7f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b82:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b85:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b88:	89 c2                	mov    %eax,%edx
80102b8a:	83 e0 0f             	and    $0xf,%eax
80102b8d:	c1 ea 04             	shr    $0x4,%edx
80102b90:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b93:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b96:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b99:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b9c:	89 c2                	mov    %eax,%edx
80102b9e:	83 e0 0f             	and    $0xf,%eax
80102ba1:	c1 ea 04             	shr    $0x4,%edx
80102ba4:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ba7:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102baa:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102bad:	8b 75 08             	mov    0x8(%ebp),%esi
80102bb0:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102bb3:	89 06                	mov    %eax,(%esi)
80102bb5:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102bb8:	89 46 04             	mov    %eax,0x4(%esi)
80102bbb:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102bbe:	89 46 08             	mov    %eax,0x8(%esi)
80102bc1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102bc4:	89 46 0c             	mov    %eax,0xc(%esi)
80102bc7:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102bca:	89 46 10             	mov    %eax,0x10(%esi)
80102bcd:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102bd0:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102bd3:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102bda:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102bdd:	5b                   	pop    %ebx
80102bde:	5e                   	pop    %esi
80102bdf:	5f                   	pop    %edi
80102be0:	5d                   	pop    %ebp
80102be1:	c3                   	ret    
80102be2:	66 90                	xchg   %ax,%ax
80102be4:	66 90                	xchg   %ax,%ax
80102be6:	66 90                	xchg   %ax,%ax
80102be8:	66 90                	xchg   %ax,%ax
80102bea:	66 90                	xchg   %ax,%ax
80102bec:	66 90                	xchg   %ax,%ax
80102bee:	66 90                	xchg   %ax,%ax

80102bf0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102bf0:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
80102bf6:	85 c9                	test   %ecx,%ecx
80102bf8:	0f 8e 8a 00 00 00    	jle    80102c88 <install_trans+0x98>
{
80102bfe:	55                   	push   %ebp
80102bff:	89 e5                	mov    %esp,%ebp
80102c01:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102c02:	31 ff                	xor    %edi,%edi
{
80102c04:	56                   	push   %esi
80102c05:	53                   	push   %ebx
80102c06:	83 ec 0c             	sub    $0xc,%esp
80102c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102c10:	a1 d4 36 11 80       	mov    0x801136d4,%eax
80102c15:	83 ec 08             	sub    $0x8,%esp
80102c18:	01 f8                	add    %edi,%eax
80102c1a:	83 c0 01             	add    $0x1,%eax
80102c1d:	50                   	push   %eax
80102c1e:	ff 35 e4 36 11 80    	pushl  0x801136e4
80102c24:	e8 a7 d4 ff ff       	call   801000d0 <bread>
80102c29:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c2b:	58                   	pop    %eax
80102c2c:	5a                   	pop    %edx
80102c2d:	ff 34 bd ec 36 11 80 	pushl  -0x7feec914(,%edi,4)
80102c34:	ff 35 e4 36 11 80    	pushl  0x801136e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102c3a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c3d:	e8 8e d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c42:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c45:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c47:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c4a:	68 00 02 00 00       	push   $0x200
80102c4f:	50                   	push   %eax
80102c50:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102c53:	50                   	push   %eax
80102c54:	e8 87 1c 00 00       	call   801048e0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c59:	89 1c 24             	mov    %ebx,(%esp)
80102c5c:	e8 4f d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c61:	89 34 24             	mov    %esi,(%esp)
80102c64:	e8 87 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c69:	89 1c 24             	mov    %ebx,(%esp)
80102c6c:	e8 7f d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c71:	83 c4 10             	add    $0x10,%esp
80102c74:	39 3d e8 36 11 80    	cmp    %edi,0x801136e8
80102c7a:	7f 94                	jg     80102c10 <install_trans+0x20>
  }
}
80102c7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c7f:	5b                   	pop    %ebx
80102c80:	5e                   	pop    %esi
80102c81:	5f                   	pop    %edi
80102c82:	5d                   	pop    %ebp
80102c83:	c3                   	ret    
80102c84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c88:	c3                   	ret    
80102c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c90 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c90:	55                   	push   %ebp
80102c91:	89 e5                	mov    %esp,%ebp
80102c93:	53                   	push   %ebx
80102c94:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c97:	ff 35 d4 36 11 80    	pushl  0x801136d4
80102c9d:	ff 35 e4 36 11 80    	pushl  0x801136e4
80102ca3:	e8 28 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102ca8:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102cab:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102cad:	a1 e8 36 11 80       	mov    0x801136e8,%eax
80102cb2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102cb5:	85 c0                	test   %eax,%eax
80102cb7:	7e 19                	jle    80102cd2 <write_head+0x42>
80102cb9:	31 d2                	xor    %edx,%edx
80102cbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cbf:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102cc0:	8b 0c 95 ec 36 11 80 	mov    -0x7feec914(,%edx,4),%ecx
80102cc7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102ccb:	83 c2 01             	add    $0x1,%edx
80102cce:	39 d0                	cmp    %edx,%eax
80102cd0:	75 ee                	jne    80102cc0 <write_head+0x30>
  }
  bwrite(buf);
80102cd2:	83 ec 0c             	sub    $0xc,%esp
80102cd5:	53                   	push   %ebx
80102cd6:	e8 d5 d4 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102cdb:	89 1c 24             	mov    %ebx,(%esp)
80102cde:	e8 0d d5 ff ff       	call   801001f0 <brelse>
}
80102ce3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ce6:	83 c4 10             	add    $0x10,%esp
80102ce9:	c9                   	leave  
80102cea:	c3                   	ret    
80102ceb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cef:	90                   	nop

80102cf0 <initlog>:
{
80102cf0:	f3 0f 1e fb          	endbr32 
80102cf4:	55                   	push   %ebp
80102cf5:	89 e5                	mov    %esp,%ebp
80102cf7:	53                   	push   %ebx
80102cf8:	83 ec 2c             	sub    $0x2c,%esp
80102cfb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102cfe:	68 e0 7b 10 80       	push   $0x80107be0
80102d03:	68 a0 36 11 80       	push   $0x801136a0
80102d08:	e8 a3 18 00 00       	call   801045b0 <initlock>
  readsb(dev, &sb);
80102d0d:	58                   	pop    %eax
80102d0e:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102d11:	5a                   	pop    %edx
80102d12:	50                   	push   %eax
80102d13:	53                   	push   %ebx
80102d14:	e8 e7 e7 ff ff       	call   80101500 <readsb>
  log.start = sb.logstart;
80102d19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102d1c:	59                   	pop    %ecx
  log.dev = dev;
80102d1d:	89 1d e4 36 11 80    	mov    %ebx,0x801136e4
  log.size = sb.nlog;
80102d23:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102d26:	a3 d4 36 11 80       	mov    %eax,0x801136d4
  log.size = sb.nlog;
80102d2b:	89 15 d8 36 11 80    	mov    %edx,0x801136d8
  struct buf *buf = bread(log.dev, log.start);
80102d31:	5a                   	pop    %edx
80102d32:	50                   	push   %eax
80102d33:	53                   	push   %ebx
80102d34:	e8 97 d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102d39:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102d3c:	8b 48 5c             	mov    0x5c(%eax),%ecx
80102d3f:	89 0d e8 36 11 80    	mov    %ecx,0x801136e8
  for (i = 0; i < log.lh.n; i++) {
80102d45:	85 c9                	test   %ecx,%ecx
80102d47:	7e 19                	jle    80102d62 <initlog+0x72>
80102d49:	31 d2                	xor    %edx,%edx
80102d4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d4f:	90                   	nop
    log.lh.block[i] = lh->block[i];
80102d50:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80102d54:	89 1c 95 ec 36 11 80 	mov    %ebx,-0x7feec914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d5b:	83 c2 01             	add    $0x1,%edx
80102d5e:	39 d1                	cmp    %edx,%ecx
80102d60:	75 ee                	jne    80102d50 <initlog+0x60>
  brelse(buf);
80102d62:	83 ec 0c             	sub    $0xc,%esp
80102d65:	50                   	push   %eax
80102d66:	e8 85 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d6b:	e8 80 fe ff ff       	call   80102bf0 <install_trans>
  log.lh.n = 0;
80102d70:	c7 05 e8 36 11 80 00 	movl   $0x0,0x801136e8
80102d77:	00 00 00 
  write_head(); // clear the log
80102d7a:	e8 11 ff ff ff       	call   80102c90 <write_head>
}
80102d7f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d82:	83 c4 10             	add    $0x10,%esp
80102d85:	c9                   	leave  
80102d86:	c3                   	ret    
80102d87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d8e:	66 90                	xchg   %ax,%ax

80102d90 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d90:	f3 0f 1e fb          	endbr32 
80102d94:	55                   	push   %ebp
80102d95:	89 e5                	mov    %esp,%ebp
80102d97:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d9a:	68 a0 36 11 80       	push   $0x801136a0
80102d9f:	e8 8c 19 00 00       	call   80104730 <acquire>
80102da4:	83 c4 10             	add    $0x10,%esp
80102da7:	eb 1c                	jmp    80102dc5 <begin_op+0x35>
80102da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102db0:	83 ec 08             	sub    $0x8,%esp
80102db3:	68 a0 36 11 80       	push   $0x801136a0
80102db8:	68 a0 36 11 80       	push   $0x801136a0
80102dbd:	e8 1e 13 00 00       	call   801040e0 <sleep>
80102dc2:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102dc5:	a1 e0 36 11 80       	mov    0x801136e0,%eax
80102dca:	85 c0                	test   %eax,%eax
80102dcc:	75 e2                	jne    80102db0 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102dce:	a1 dc 36 11 80       	mov    0x801136dc,%eax
80102dd3:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
80102dd9:	83 c0 01             	add    $0x1,%eax
80102ddc:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102ddf:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102de2:	83 fa 1e             	cmp    $0x1e,%edx
80102de5:	7f c9                	jg     80102db0 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102de7:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102dea:	a3 dc 36 11 80       	mov    %eax,0x801136dc
      release(&log.lock);
80102def:	68 a0 36 11 80       	push   $0x801136a0
80102df4:	e8 f7 19 00 00       	call   801047f0 <release>
      break;
    }
  }
}
80102df9:	83 c4 10             	add    $0x10,%esp
80102dfc:	c9                   	leave  
80102dfd:	c3                   	ret    
80102dfe:	66 90                	xchg   %ax,%ax

80102e00 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102e00:	f3 0f 1e fb          	endbr32 
80102e04:	55                   	push   %ebp
80102e05:	89 e5                	mov    %esp,%ebp
80102e07:	57                   	push   %edi
80102e08:	56                   	push   %esi
80102e09:	53                   	push   %ebx
80102e0a:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102e0d:	68 a0 36 11 80       	push   $0x801136a0
80102e12:	e8 19 19 00 00       	call   80104730 <acquire>
  log.outstanding -= 1;
80102e17:	a1 dc 36 11 80       	mov    0x801136dc,%eax
  if(log.committing)
80102e1c:	8b 35 e0 36 11 80    	mov    0x801136e0,%esi
80102e22:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102e25:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102e28:	89 1d dc 36 11 80    	mov    %ebx,0x801136dc
  if(log.committing)
80102e2e:	85 f6                	test   %esi,%esi
80102e30:	0f 85 1e 01 00 00    	jne    80102f54 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102e36:	85 db                	test   %ebx,%ebx
80102e38:	0f 85 f2 00 00 00    	jne    80102f30 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102e3e:	c7 05 e0 36 11 80 01 	movl   $0x1,0x801136e0
80102e45:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102e48:	83 ec 0c             	sub    $0xc,%esp
80102e4b:	68 a0 36 11 80       	push   $0x801136a0
80102e50:	e8 9b 19 00 00       	call   801047f0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e55:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
80102e5b:	83 c4 10             	add    $0x10,%esp
80102e5e:	85 c9                	test   %ecx,%ecx
80102e60:	7f 3e                	jg     80102ea0 <end_op+0xa0>
    acquire(&log.lock);
80102e62:	83 ec 0c             	sub    $0xc,%esp
80102e65:	68 a0 36 11 80       	push   $0x801136a0
80102e6a:	e8 c1 18 00 00       	call   80104730 <acquire>
    wakeup(&log);
80102e6f:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
    log.committing = 0;
80102e76:	c7 05 e0 36 11 80 00 	movl   $0x0,0x801136e0
80102e7d:	00 00 00 
    wakeup(&log);
80102e80:	e8 2b 14 00 00       	call   801042b0 <wakeup>
    release(&log.lock);
80102e85:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
80102e8c:	e8 5f 19 00 00       	call   801047f0 <release>
80102e91:	83 c4 10             	add    $0x10,%esp
}
80102e94:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e97:	5b                   	pop    %ebx
80102e98:	5e                   	pop    %esi
80102e99:	5f                   	pop    %edi
80102e9a:	5d                   	pop    %ebp
80102e9b:	c3                   	ret    
80102e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102ea0:	a1 d4 36 11 80       	mov    0x801136d4,%eax
80102ea5:	83 ec 08             	sub    $0x8,%esp
80102ea8:	01 d8                	add    %ebx,%eax
80102eaa:	83 c0 01             	add    $0x1,%eax
80102ead:	50                   	push   %eax
80102eae:	ff 35 e4 36 11 80    	pushl  0x801136e4
80102eb4:	e8 17 d2 ff ff       	call   801000d0 <bread>
80102eb9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ebb:	58                   	pop    %eax
80102ebc:	5a                   	pop    %edx
80102ebd:	ff 34 9d ec 36 11 80 	pushl  -0x7feec914(,%ebx,4)
80102ec4:	ff 35 e4 36 11 80    	pushl  0x801136e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102eca:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ecd:	e8 fe d1 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102ed2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ed5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102ed7:	8d 40 5c             	lea    0x5c(%eax),%eax
80102eda:	68 00 02 00 00       	push   $0x200
80102edf:	50                   	push   %eax
80102ee0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102ee3:	50                   	push   %eax
80102ee4:	e8 f7 19 00 00       	call   801048e0 <memmove>
    bwrite(to);  // write the log
80102ee9:	89 34 24             	mov    %esi,(%esp)
80102eec:	e8 bf d2 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102ef1:	89 3c 24             	mov    %edi,(%esp)
80102ef4:	e8 f7 d2 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102ef9:	89 34 24             	mov    %esi,(%esp)
80102efc:	e8 ef d2 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102f01:	83 c4 10             	add    $0x10,%esp
80102f04:	3b 1d e8 36 11 80    	cmp    0x801136e8,%ebx
80102f0a:	7c 94                	jl     80102ea0 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102f0c:	e8 7f fd ff ff       	call   80102c90 <write_head>
    install_trans(); // Now install writes to home locations
80102f11:	e8 da fc ff ff       	call   80102bf0 <install_trans>
    log.lh.n = 0;
80102f16:	c7 05 e8 36 11 80 00 	movl   $0x0,0x801136e8
80102f1d:	00 00 00 
    write_head();    // Erase the transaction from the log
80102f20:	e8 6b fd ff ff       	call   80102c90 <write_head>
80102f25:	e9 38 ff ff ff       	jmp    80102e62 <end_op+0x62>
80102f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102f30:	83 ec 0c             	sub    $0xc,%esp
80102f33:	68 a0 36 11 80       	push   $0x801136a0
80102f38:	e8 73 13 00 00       	call   801042b0 <wakeup>
  release(&log.lock);
80102f3d:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
80102f44:	e8 a7 18 00 00       	call   801047f0 <release>
80102f49:	83 c4 10             	add    $0x10,%esp
}
80102f4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f4f:	5b                   	pop    %ebx
80102f50:	5e                   	pop    %esi
80102f51:	5f                   	pop    %edi
80102f52:	5d                   	pop    %ebp
80102f53:	c3                   	ret    
    panic("log.committing");
80102f54:	83 ec 0c             	sub    $0xc,%esp
80102f57:	68 e4 7b 10 80       	push   $0x80107be4
80102f5c:	e8 2f d4 ff ff       	call   80100390 <panic>
80102f61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f6f:	90                   	nop

80102f70 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f70:	f3 0f 1e fb          	endbr32 
80102f74:	55                   	push   %ebp
80102f75:	89 e5                	mov    %esp,%ebp
80102f77:	53                   	push   %ebx
80102f78:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f7b:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
{
80102f81:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f84:	83 fa 1d             	cmp    $0x1d,%edx
80102f87:	0f 8f 91 00 00 00    	jg     8010301e <log_write+0xae>
80102f8d:	a1 d8 36 11 80       	mov    0x801136d8,%eax
80102f92:	83 e8 01             	sub    $0x1,%eax
80102f95:	39 c2                	cmp    %eax,%edx
80102f97:	0f 8d 81 00 00 00    	jge    8010301e <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f9d:	a1 dc 36 11 80       	mov    0x801136dc,%eax
80102fa2:	85 c0                	test   %eax,%eax
80102fa4:	0f 8e 81 00 00 00    	jle    8010302b <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102faa:	83 ec 0c             	sub    $0xc,%esp
80102fad:	68 a0 36 11 80       	push   $0x801136a0
80102fb2:	e8 79 17 00 00       	call   80104730 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102fb7:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
80102fbd:	83 c4 10             	add    $0x10,%esp
80102fc0:	85 d2                	test   %edx,%edx
80102fc2:	7e 4e                	jle    80103012 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102fc4:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102fc7:	31 c0                	xor    %eax,%eax
80102fc9:	eb 0c                	jmp    80102fd7 <log_write+0x67>
80102fcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102fcf:	90                   	nop
80102fd0:	83 c0 01             	add    $0x1,%eax
80102fd3:	39 c2                	cmp    %eax,%edx
80102fd5:	74 29                	je     80103000 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102fd7:	39 0c 85 ec 36 11 80 	cmp    %ecx,-0x7feec914(,%eax,4)
80102fde:	75 f0                	jne    80102fd0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102fe0:	89 0c 85 ec 36 11 80 	mov    %ecx,-0x7feec914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102fe7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102fea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102fed:	c7 45 08 a0 36 11 80 	movl   $0x801136a0,0x8(%ebp)
}
80102ff4:	c9                   	leave  
  release(&log.lock);
80102ff5:	e9 f6 17 00 00       	jmp    801047f0 <release>
80102ffa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103000:	89 0c 95 ec 36 11 80 	mov    %ecx,-0x7feec914(,%edx,4)
    log.lh.n++;
80103007:	83 c2 01             	add    $0x1,%edx
8010300a:	89 15 e8 36 11 80    	mov    %edx,0x801136e8
80103010:	eb d5                	jmp    80102fe7 <log_write+0x77>
  log.lh.block[i] = b->blockno;
80103012:	8b 43 08             	mov    0x8(%ebx),%eax
80103015:	a3 ec 36 11 80       	mov    %eax,0x801136ec
  if (i == log.lh.n)
8010301a:	75 cb                	jne    80102fe7 <log_write+0x77>
8010301c:	eb e9                	jmp    80103007 <log_write+0x97>
    panic("too big a transaction");
8010301e:	83 ec 0c             	sub    $0xc,%esp
80103021:	68 f3 7b 10 80       	push   $0x80107bf3
80103026:	e8 65 d3 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
8010302b:	83 ec 0c             	sub    $0xc,%esp
8010302e:	68 09 7c 10 80       	push   $0x80107c09
80103033:	e8 58 d3 ff ff       	call   80100390 <panic>
80103038:	66 90                	xchg   %ax,%ax
8010303a:	66 90                	xchg   %ax,%ax
8010303c:	66 90                	xchg   %ax,%ax
8010303e:	66 90                	xchg   %ax,%ax

80103040 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103040:	55                   	push   %ebp
80103041:	89 e5                	mov    %esp,%ebp
80103043:	53                   	push   %ebx
80103044:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103047:	e8 44 09 00 00       	call   80103990 <cpuid>
8010304c:	89 c3                	mov    %eax,%ebx
8010304e:	e8 3d 09 00 00       	call   80103990 <cpuid>
80103053:	83 ec 04             	sub    $0x4,%esp
80103056:	53                   	push   %ebx
80103057:	50                   	push   %eax
80103058:	68 24 7c 10 80       	push   $0x80107c24
8010305d:	e8 4e d6 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80103062:	e8 b9 2a 00 00       	call   80105b20 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103067:	e8 c4 08 00 00       	call   80103930 <mycpu>
8010306c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010306e:	b8 01 00 00 00       	mov    $0x1,%eax
80103073:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010307a:	e8 81 0c 00 00       	call   80103d00 <scheduler>
8010307f:	90                   	nop

80103080 <mpenter>:
{
80103080:	f3 0f 1e fb          	endbr32 
80103084:	55                   	push   %ebp
80103085:	89 e5                	mov    %esp,%ebp
80103087:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
8010308a:	e8 c1 3b 00 00       	call   80106c50 <switchkvm>
  seginit();
8010308f:	e8 2c 39 00 00       	call   801069c0 <seginit>
  lapicinit();
80103094:	e8 67 f7 ff ff       	call   80102800 <lapicinit>
  mpmain();
80103099:	e8 a2 ff ff ff       	call   80103040 <mpmain>
8010309e:	66 90                	xchg   %ax,%ax

801030a0 <main>:
{
801030a0:	f3 0f 1e fb          	endbr32 
801030a4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801030a8:	83 e4 f0             	and    $0xfffffff0,%esp
801030ab:	ff 71 fc             	pushl  -0x4(%ecx)
801030ae:	55                   	push   %ebp
801030af:	89 e5                	mov    %esp,%ebp
801030b1:	53                   	push   %ebx
801030b2:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801030b3:	83 ec 08             	sub    $0x8,%esp
801030b6:	68 00 00 40 80       	push   $0x80400000
801030bb:	68 00 41 1a 80       	push   $0x801a4100
801030c0:	e8 ab f4 ff ff       	call   80102570 <kinit1>
  kvmalloc();      // kernel page table
801030c5:	e8 f6 40 00 00       	call   801071c0 <kvmalloc>
  mpinit();        // detect other processors
801030ca:	e8 81 01 00 00       	call   80103250 <mpinit>
  lapicinit();     // interrupt controller
801030cf:	e8 2c f7 ff ff       	call   80102800 <lapicinit>
  seginit();       // segment descriptors
801030d4:	e8 e7 38 00 00       	call   801069c0 <seginit>
  picinit();       // disable pic
801030d9:	e8 52 03 00 00       	call   80103430 <picinit>
  ioapicinit();    // another interrupt controller
801030de:	e8 9d f2 ff ff       	call   80102380 <ioapicinit>
  consoleinit();   // console hardware
801030e3:	e8 48 d9 ff ff       	call   80100a30 <consoleinit>
  uartinit();      // serial port
801030e8:	e8 53 2d 00 00       	call   80105e40 <uartinit>
  pinit();         // process table
801030ed:	e8 1e 08 00 00       	call   80103910 <pinit>
  tvinit();        // trap vectors
801030f2:	e8 a9 29 00 00       	call   80105aa0 <tvinit>
  binit();         // buffer cache
801030f7:	e8 44 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
801030fc:	e8 df dc ff ff       	call   80100de0 <fileinit>
  ideinit();       // disk 
80103101:	e8 4a f0 ff ff       	call   80102150 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103106:	83 c4 0c             	add    $0xc,%esp
80103109:	68 8a 00 00 00       	push   $0x8a
8010310e:	68 8c b4 10 80       	push   $0x8010b48c
80103113:	68 00 70 00 80       	push   $0x80007000
80103118:	e8 c3 17 00 00       	call   801048e0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010311d:	83 c4 10             	add    $0x10,%esp
80103120:	69 05 50 38 11 80 b0 	imul   $0xb0,0x80113850,%eax
80103127:	00 00 00 
8010312a:	05 a0 37 11 80       	add    $0x801137a0,%eax
8010312f:	3d a0 37 11 80       	cmp    $0x801137a0,%eax
80103134:	76 7a                	jbe    801031b0 <main+0x110>
80103136:	bb a0 37 11 80       	mov    $0x801137a0,%ebx
8010313b:	eb 1c                	jmp    80103159 <main+0xb9>
8010313d:	8d 76 00             	lea    0x0(%esi),%esi
80103140:	69 05 50 38 11 80 b0 	imul   $0xb0,0x80113850,%eax
80103147:	00 00 00 
8010314a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103150:	05 a0 37 11 80       	add    $0x801137a0,%eax
80103155:	39 c3                	cmp    %eax,%ebx
80103157:	73 57                	jae    801031b0 <main+0x110>
    if(c == mycpu())  // We've started already.
80103159:	e8 d2 07 00 00       	call   80103930 <mycpu>
8010315e:	39 c3                	cmp    %eax,%ebx
80103160:	74 de                	je     80103140 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103162:	e8 d9 f4 ff ff       	call   80102640 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103167:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010316a:	c7 05 f8 6f 00 80 80 	movl   $0x80103080,0x80006ff8
80103171:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103174:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010317b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010317e:	05 00 10 00 00       	add    $0x1000,%eax
80103183:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103188:	0f b6 03             	movzbl (%ebx),%eax
8010318b:	68 00 70 00 00       	push   $0x7000
80103190:	50                   	push   %eax
80103191:	e8 ba f7 ff ff       	call   80102950 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103196:	83 c4 10             	add    $0x10,%esp
80103199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031a0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801031a6:	85 c0                	test   %eax,%eax
801031a8:	74 f6                	je     801031a0 <main+0x100>
801031aa:	eb 94                	jmp    80103140 <main+0xa0>
801031ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801031b0:	83 ec 08             	sub    $0x8,%esp
801031b3:	68 00 00 40 80       	push   $0x80400000
801031b8:	68 00 00 40 80       	push   $0x80400000
801031bd:	e8 1e f4 ff ff       	call   801025e0 <kinit2>
  userinit();      // first user process
801031c2:	e8 19 08 00 00       	call   801039e0 <userinit>
  mpmain();        // finish this processor's setup
801031c7:	e8 74 fe ff ff       	call   80103040 <mpmain>
801031cc:	66 90                	xchg   %ax,%ax
801031ce:	66 90                	xchg   %ax,%ax

801031d0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801031d0:	55                   	push   %ebp
801031d1:	89 e5                	mov    %esp,%ebp
801031d3:	57                   	push   %edi
801031d4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801031d5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801031db:	53                   	push   %ebx
  e = addr+len;
801031dc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801031df:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801031e2:	39 de                	cmp    %ebx,%esi
801031e4:	72 10                	jb     801031f6 <mpsearch1+0x26>
801031e6:	eb 50                	jmp    80103238 <mpsearch1+0x68>
801031e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031ef:	90                   	nop
801031f0:	89 fe                	mov    %edi,%esi
801031f2:	39 fb                	cmp    %edi,%ebx
801031f4:	76 42                	jbe    80103238 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031f6:	83 ec 04             	sub    $0x4,%esp
801031f9:	8d 7e 10             	lea    0x10(%esi),%edi
801031fc:	6a 04                	push   $0x4
801031fe:	68 38 7c 10 80       	push   $0x80107c38
80103203:	56                   	push   %esi
80103204:	e8 87 16 00 00       	call   80104890 <memcmp>
80103209:	83 c4 10             	add    $0x10,%esp
8010320c:	85 c0                	test   %eax,%eax
8010320e:	75 e0                	jne    801031f0 <mpsearch1+0x20>
80103210:	89 f2                	mov    %esi,%edx
80103212:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103218:	0f b6 0a             	movzbl (%edx),%ecx
8010321b:	83 c2 01             	add    $0x1,%edx
8010321e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103220:	39 fa                	cmp    %edi,%edx
80103222:	75 f4                	jne    80103218 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103224:	84 c0                	test   %al,%al
80103226:	75 c8                	jne    801031f0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103228:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010322b:	89 f0                	mov    %esi,%eax
8010322d:	5b                   	pop    %ebx
8010322e:	5e                   	pop    %esi
8010322f:	5f                   	pop    %edi
80103230:	5d                   	pop    %ebp
80103231:	c3                   	ret    
80103232:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103238:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010323b:	31 f6                	xor    %esi,%esi
}
8010323d:	5b                   	pop    %ebx
8010323e:	89 f0                	mov    %esi,%eax
80103240:	5e                   	pop    %esi
80103241:	5f                   	pop    %edi
80103242:	5d                   	pop    %ebp
80103243:	c3                   	ret    
80103244:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010324b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010324f:	90                   	nop

80103250 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103250:	f3 0f 1e fb          	endbr32 
80103254:	55                   	push   %ebp
80103255:	89 e5                	mov    %esp,%ebp
80103257:	57                   	push   %edi
80103258:	56                   	push   %esi
80103259:	53                   	push   %ebx
8010325a:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
8010325d:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103264:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
8010326b:	c1 e0 08             	shl    $0x8,%eax
8010326e:	09 d0                	or     %edx,%eax
80103270:	c1 e0 04             	shl    $0x4,%eax
80103273:	75 1b                	jne    80103290 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103275:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010327c:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103283:	c1 e0 08             	shl    $0x8,%eax
80103286:	09 d0                	or     %edx,%eax
80103288:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
8010328b:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80103290:	ba 00 04 00 00       	mov    $0x400,%edx
80103295:	e8 36 ff ff ff       	call   801031d0 <mpsearch1>
8010329a:	89 c6                	mov    %eax,%esi
8010329c:	85 c0                	test   %eax,%eax
8010329e:	0f 84 4c 01 00 00    	je     801033f0 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801032a4:	8b 5e 04             	mov    0x4(%esi),%ebx
801032a7:	85 db                	test   %ebx,%ebx
801032a9:	0f 84 61 01 00 00    	je     80103410 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
801032af:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801032b2:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
801032b8:	6a 04                	push   $0x4
801032ba:	68 3d 7c 10 80       	push   $0x80107c3d
801032bf:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801032c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801032c3:	e8 c8 15 00 00       	call   80104890 <memcmp>
801032c8:	83 c4 10             	add    $0x10,%esp
801032cb:	85 c0                	test   %eax,%eax
801032cd:	0f 85 3d 01 00 00    	jne    80103410 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
801032d3:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801032da:	3c 01                	cmp    $0x1,%al
801032dc:	74 08                	je     801032e6 <mpinit+0x96>
801032de:	3c 04                	cmp    $0x4,%al
801032e0:	0f 85 2a 01 00 00    	jne    80103410 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
801032e6:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
801032ed:	66 85 d2             	test   %dx,%dx
801032f0:	74 26                	je     80103318 <mpinit+0xc8>
801032f2:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
801032f5:	89 d8                	mov    %ebx,%eax
  sum = 0;
801032f7:	31 d2                	xor    %edx,%edx
801032f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103300:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
80103307:	83 c0 01             	add    $0x1,%eax
8010330a:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
8010330c:	39 f8                	cmp    %edi,%eax
8010330e:	75 f0                	jne    80103300 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
80103310:	84 d2                	test   %dl,%dl
80103312:	0f 85 f8 00 00 00    	jne    80103410 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103318:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
8010331e:	a3 80 36 11 80       	mov    %eax,0x80113680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103323:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
80103329:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
80103330:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103335:	03 55 e4             	add    -0x1c(%ebp),%edx
80103338:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
8010333b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010333f:	90                   	nop
80103340:	39 c2                	cmp    %eax,%edx
80103342:	76 15                	jbe    80103359 <mpinit+0x109>
    switch(*p){
80103344:	0f b6 08             	movzbl (%eax),%ecx
80103347:	80 f9 02             	cmp    $0x2,%cl
8010334a:	74 5c                	je     801033a8 <mpinit+0x158>
8010334c:	77 42                	ja     80103390 <mpinit+0x140>
8010334e:	84 c9                	test   %cl,%cl
80103350:	74 6e                	je     801033c0 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103352:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103355:	39 c2                	cmp    %eax,%edx
80103357:	77 eb                	ja     80103344 <mpinit+0xf4>
80103359:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010335c:	85 db                	test   %ebx,%ebx
8010335e:	0f 84 b9 00 00 00    	je     8010341d <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103364:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103368:	74 15                	je     8010337f <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010336a:	b8 70 00 00 00       	mov    $0x70,%eax
8010336f:	ba 22 00 00 00       	mov    $0x22,%edx
80103374:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103375:	ba 23 00 00 00       	mov    $0x23,%edx
8010337a:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010337b:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010337e:	ee                   	out    %al,(%dx)
  }
}
8010337f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103382:	5b                   	pop    %ebx
80103383:	5e                   	pop    %esi
80103384:	5f                   	pop    %edi
80103385:	5d                   	pop    %ebp
80103386:	c3                   	ret    
80103387:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010338e:	66 90                	xchg   %ax,%ax
    switch(*p){
80103390:	83 e9 03             	sub    $0x3,%ecx
80103393:	80 f9 01             	cmp    $0x1,%cl
80103396:	76 ba                	jbe    80103352 <mpinit+0x102>
80103398:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010339f:	eb 9f                	jmp    80103340 <mpinit+0xf0>
801033a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801033a8:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
801033ac:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801033af:	88 0d 80 37 11 80    	mov    %cl,0x80113780
      continue;
801033b5:	eb 89                	jmp    80103340 <mpinit+0xf0>
801033b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033be:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
801033c0:	8b 0d 50 38 11 80    	mov    0x80113850,%ecx
801033c6:	85 c9                	test   %ecx,%ecx
801033c8:	7f 19                	jg     801033e3 <mpinit+0x193>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801033ca:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
801033d0:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
801033d4:	83 c1 01             	add    $0x1,%ecx
801033d7:	89 0d 50 38 11 80    	mov    %ecx,0x80113850
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801033dd:	88 9f a0 37 11 80    	mov    %bl,-0x7feec860(%edi)
      p += sizeof(struct mpproc);
801033e3:	83 c0 14             	add    $0x14,%eax
      continue;
801033e6:	e9 55 ff ff ff       	jmp    80103340 <mpinit+0xf0>
801033eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801033ef:	90                   	nop
  return mpsearch1(0xF0000, 0x10000);
801033f0:	ba 00 00 01 00       	mov    $0x10000,%edx
801033f5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801033fa:	e8 d1 fd ff ff       	call   801031d0 <mpsearch1>
801033ff:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103401:	85 c0                	test   %eax,%eax
80103403:	0f 85 9b fe ff ff    	jne    801032a4 <mpinit+0x54>
80103409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103410:	83 ec 0c             	sub    $0xc,%esp
80103413:	68 42 7c 10 80       	push   $0x80107c42
80103418:	e8 73 cf ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010341d:	83 ec 0c             	sub    $0xc,%esp
80103420:	68 5c 7c 10 80       	push   $0x80107c5c
80103425:	e8 66 cf ff ff       	call   80100390 <panic>
8010342a:	66 90                	xchg   %ax,%ax
8010342c:	66 90                	xchg   %ax,%ax
8010342e:	66 90                	xchg   %ax,%ax

80103430 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103430:	f3 0f 1e fb          	endbr32 
80103434:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103439:	ba 21 00 00 00       	mov    $0x21,%edx
8010343e:	ee                   	out    %al,(%dx)
8010343f:	ba a1 00 00 00       	mov    $0xa1,%edx
80103444:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103445:	c3                   	ret    
80103446:	66 90                	xchg   %ax,%ax
80103448:	66 90                	xchg   %ax,%ax
8010344a:	66 90                	xchg   %ax,%ax
8010344c:	66 90                	xchg   %ax,%ax
8010344e:	66 90                	xchg   %ax,%ax

80103450 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103450:	f3 0f 1e fb          	endbr32 
80103454:	55                   	push   %ebp
80103455:	89 e5                	mov    %esp,%ebp
80103457:	57                   	push   %edi
80103458:	56                   	push   %esi
80103459:	53                   	push   %ebx
8010345a:	83 ec 0c             	sub    $0xc,%esp
8010345d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103460:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103463:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103469:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010346f:	e8 8c d9 ff ff       	call   80100e00 <filealloc>
80103474:	89 03                	mov    %eax,(%ebx)
80103476:	85 c0                	test   %eax,%eax
80103478:	0f 84 ac 00 00 00    	je     8010352a <pipealloc+0xda>
8010347e:	e8 7d d9 ff ff       	call   80100e00 <filealloc>
80103483:	89 06                	mov    %eax,(%esi)
80103485:	85 c0                	test   %eax,%eax
80103487:	0f 84 8b 00 00 00    	je     80103518 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
8010348d:	e8 ae f1 ff ff       	call   80102640 <kalloc>
80103492:	89 c7                	mov    %eax,%edi
80103494:	85 c0                	test   %eax,%eax
80103496:	0f 84 b4 00 00 00    	je     80103550 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
8010349c:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801034a3:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801034a6:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
801034a9:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801034b0:	00 00 00 
  p->nwrite = 0;
801034b3:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801034ba:	00 00 00 
  p->nread = 0;
801034bd:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801034c4:	00 00 00 
  initlock(&p->lock, "pipe");
801034c7:	68 7b 7c 10 80       	push   $0x80107c7b
801034cc:	50                   	push   %eax
801034cd:	e8 de 10 00 00       	call   801045b0 <initlock>
  (*f0)->type = FD_PIPE;
801034d2:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801034d4:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801034d7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801034dd:	8b 03                	mov    (%ebx),%eax
801034df:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801034e3:	8b 03                	mov    (%ebx),%eax
801034e5:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801034e9:	8b 03                	mov    (%ebx),%eax
801034eb:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801034ee:	8b 06                	mov    (%esi),%eax
801034f0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801034f6:	8b 06                	mov    (%esi),%eax
801034f8:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801034fc:	8b 06                	mov    (%esi),%eax
801034fe:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103502:	8b 06                	mov    (%esi),%eax
80103504:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103507:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010350a:	31 c0                	xor    %eax,%eax
}
8010350c:	5b                   	pop    %ebx
8010350d:	5e                   	pop    %esi
8010350e:	5f                   	pop    %edi
8010350f:	5d                   	pop    %ebp
80103510:	c3                   	ret    
80103511:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103518:	8b 03                	mov    (%ebx),%eax
8010351a:	85 c0                	test   %eax,%eax
8010351c:	74 1e                	je     8010353c <pipealloc+0xec>
    fileclose(*f0);
8010351e:	83 ec 0c             	sub    $0xc,%esp
80103521:	50                   	push   %eax
80103522:	e8 99 d9 ff ff       	call   80100ec0 <fileclose>
80103527:	83 c4 10             	add    $0x10,%esp
  if(*f1)
8010352a:	8b 06                	mov    (%esi),%eax
8010352c:	85 c0                	test   %eax,%eax
8010352e:	74 0c                	je     8010353c <pipealloc+0xec>
    fileclose(*f1);
80103530:	83 ec 0c             	sub    $0xc,%esp
80103533:	50                   	push   %eax
80103534:	e8 87 d9 ff ff       	call   80100ec0 <fileclose>
80103539:	83 c4 10             	add    $0x10,%esp
}
8010353c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010353f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103544:	5b                   	pop    %ebx
80103545:	5e                   	pop    %esi
80103546:	5f                   	pop    %edi
80103547:	5d                   	pop    %ebp
80103548:	c3                   	ret    
80103549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103550:	8b 03                	mov    (%ebx),%eax
80103552:	85 c0                	test   %eax,%eax
80103554:	75 c8                	jne    8010351e <pipealloc+0xce>
80103556:	eb d2                	jmp    8010352a <pipealloc+0xda>
80103558:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010355f:	90                   	nop

80103560 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103560:	f3 0f 1e fb          	endbr32 
80103564:	55                   	push   %ebp
80103565:	89 e5                	mov    %esp,%ebp
80103567:	56                   	push   %esi
80103568:	53                   	push   %ebx
80103569:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010356c:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010356f:	83 ec 0c             	sub    $0xc,%esp
80103572:	53                   	push   %ebx
80103573:	e8 b8 11 00 00       	call   80104730 <acquire>
  if(writable){
80103578:	83 c4 10             	add    $0x10,%esp
8010357b:	85 f6                	test   %esi,%esi
8010357d:	74 41                	je     801035c0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010357f:	83 ec 0c             	sub    $0xc,%esp
80103582:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103588:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010358f:	00 00 00 
    wakeup(&p->nread);
80103592:	50                   	push   %eax
80103593:	e8 18 0d 00 00       	call   801042b0 <wakeup>
80103598:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
8010359b:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801035a1:	85 d2                	test   %edx,%edx
801035a3:	75 0a                	jne    801035af <pipeclose+0x4f>
801035a5:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801035ab:	85 c0                	test   %eax,%eax
801035ad:	74 31                	je     801035e0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801035af:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801035b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035b5:	5b                   	pop    %ebx
801035b6:	5e                   	pop    %esi
801035b7:	5d                   	pop    %ebp
    release(&p->lock);
801035b8:	e9 33 12 00 00       	jmp    801047f0 <release>
801035bd:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801035c0:	83 ec 0c             	sub    $0xc,%esp
801035c3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801035c9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801035d0:	00 00 00 
    wakeup(&p->nwrite);
801035d3:	50                   	push   %eax
801035d4:	e8 d7 0c 00 00       	call   801042b0 <wakeup>
801035d9:	83 c4 10             	add    $0x10,%esp
801035dc:	eb bd                	jmp    8010359b <pipeclose+0x3b>
801035de:	66 90                	xchg   %ax,%ax
    release(&p->lock);
801035e0:	83 ec 0c             	sub    $0xc,%esp
801035e3:	53                   	push   %ebx
801035e4:	e8 07 12 00 00       	call   801047f0 <release>
    kfree((char*)p);
801035e9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801035ec:	83 c4 10             	add    $0x10,%esp
}
801035ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035f2:	5b                   	pop    %ebx
801035f3:	5e                   	pop    %esi
801035f4:	5d                   	pop    %ebp
    kfree((char*)p);
801035f5:	e9 76 ee ff ff       	jmp    80102470 <kfree>
801035fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103600 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103600:	f3 0f 1e fb          	endbr32 
80103604:	55                   	push   %ebp
80103605:	89 e5                	mov    %esp,%ebp
80103607:	57                   	push   %edi
80103608:	56                   	push   %esi
80103609:	53                   	push   %ebx
8010360a:	83 ec 28             	sub    $0x28,%esp
8010360d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103610:	53                   	push   %ebx
80103611:	e8 1a 11 00 00       	call   80104730 <acquire>
  for(i = 0; i < n; i++){
80103616:	8b 45 10             	mov    0x10(%ebp),%eax
80103619:	83 c4 10             	add    $0x10,%esp
8010361c:	85 c0                	test   %eax,%eax
8010361e:	0f 8e bc 00 00 00    	jle    801036e0 <pipewrite+0xe0>
80103624:	8b 45 0c             	mov    0xc(%ebp),%eax
80103627:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
8010362d:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103633:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103636:	03 45 10             	add    0x10(%ebp),%eax
80103639:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010363c:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103642:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103648:	89 ca                	mov    %ecx,%edx
8010364a:	05 00 02 00 00       	add    $0x200,%eax
8010364f:	39 c1                	cmp    %eax,%ecx
80103651:	74 3b                	je     8010368e <pipewrite+0x8e>
80103653:	eb 63                	jmp    801036b8 <pipewrite+0xb8>
80103655:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
80103658:	e8 53 03 00 00       	call   801039b0 <myproc>
8010365d:	8b 48 28             	mov    0x28(%eax),%ecx
80103660:	85 c9                	test   %ecx,%ecx
80103662:	75 34                	jne    80103698 <pipewrite+0x98>
      wakeup(&p->nread);
80103664:	83 ec 0c             	sub    $0xc,%esp
80103667:	57                   	push   %edi
80103668:	e8 43 0c 00 00       	call   801042b0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010366d:	58                   	pop    %eax
8010366e:	5a                   	pop    %edx
8010366f:	53                   	push   %ebx
80103670:	56                   	push   %esi
80103671:	e8 6a 0a 00 00       	call   801040e0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103676:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010367c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103682:	83 c4 10             	add    $0x10,%esp
80103685:	05 00 02 00 00       	add    $0x200,%eax
8010368a:	39 c2                	cmp    %eax,%edx
8010368c:	75 2a                	jne    801036b8 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010368e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103694:	85 c0                	test   %eax,%eax
80103696:	75 c0                	jne    80103658 <pipewrite+0x58>
        release(&p->lock);
80103698:	83 ec 0c             	sub    $0xc,%esp
8010369b:	53                   	push   %ebx
8010369c:	e8 4f 11 00 00       	call   801047f0 <release>
        return -1;
801036a1:	83 c4 10             	add    $0x10,%esp
801036a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801036a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036ac:	5b                   	pop    %ebx
801036ad:	5e                   	pop    %esi
801036ae:	5f                   	pop    %edi
801036af:	5d                   	pop    %ebp
801036b0:	c3                   	ret    
801036b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036b8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801036bb:	8d 4a 01             	lea    0x1(%edx),%ecx
801036be:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801036c4:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
801036ca:	0f b6 06             	movzbl (%esi),%eax
801036cd:	83 c6 01             	add    $0x1,%esi
801036d0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
801036d3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801036d7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801036da:	0f 85 5c ff ff ff    	jne    8010363c <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801036e0:	83 ec 0c             	sub    $0xc,%esp
801036e3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801036e9:	50                   	push   %eax
801036ea:	e8 c1 0b 00 00       	call   801042b0 <wakeup>
  release(&p->lock);
801036ef:	89 1c 24             	mov    %ebx,(%esp)
801036f2:	e8 f9 10 00 00       	call   801047f0 <release>
  return n;
801036f7:	8b 45 10             	mov    0x10(%ebp),%eax
801036fa:	83 c4 10             	add    $0x10,%esp
801036fd:	eb aa                	jmp    801036a9 <pipewrite+0xa9>
801036ff:	90                   	nop

80103700 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103700:	f3 0f 1e fb          	endbr32 
80103704:	55                   	push   %ebp
80103705:	89 e5                	mov    %esp,%ebp
80103707:	57                   	push   %edi
80103708:	56                   	push   %esi
80103709:	53                   	push   %ebx
8010370a:	83 ec 18             	sub    $0x18,%esp
8010370d:	8b 75 08             	mov    0x8(%ebp),%esi
80103710:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103713:	56                   	push   %esi
80103714:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010371a:	e8 11 10 00 00       	call   80104730 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010371f:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103725:	83 c4 10             	add    $0x10,%esp
80103728:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
8010372e:	74 33                	je     80103763 <piperead+0x63>
80103730:	eb 3b                	jmp    8010376d <piperead+0x6d>
80103732:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
80103738:	e8 73 02 00 00       	call   801039b0 <myproc>
8010373d:	8b 48 28             	mov    0x28(%eax),%ecx
80103740:	85 c9                	test   %ecx,%ecx
80103742:	0f 85 88 00 00 00    	jne    801037d0 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103748:	83 ec 08             	sub    $0x8,%esp
8010374b:	56                   	push   %esi
8010374c:	53                   	push   %ebx
8010374d:	e8 8e 09 00 00       	call   801040e0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103752:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103758:	83 c4 10             	add    $0x10,%esp
8010375b:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103761:	75 0a                	jne    8010376d <piperead+0x6d>
80103763:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103769:	85 c0                	test   %eax,%eax
8010376b:	75 cb                	jne    80103738 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010376d:	8b 55 10             	mov    0x10(%ebp),%edx
80103770:	31 db                	xor    %ebx,%ebx
80103772:	85 d2                	test   %edx,%edx
80103774:	7f 28                	jg     8010379e <piperead+0x9e>
80103776:	eb 34                	jmp    801037ac <piperead+0xac>
80103778:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010377f:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103780:	8d 48 01             	lea    0x1(%eax),%ecx
80103783:	25 ff 01 00 00       	and    $0x1ff,%eax
80103788:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010378e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103793:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103796:	83 c3 01             	add    $0x1,%ebx
80103799:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010379c:	74 0e                	je     801037ac <piperead+0xac>
    if(p->nread == p->nwrite)
8010379e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801037a4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801037aa:	75 d4                	jne    80103780 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801037ac:	83 ec 0c             	sub    $0xc,%esp
801037af:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801037b5:	50                   	push   %eax
801037b6:	e8 f5 0a 00 00       	call   801042b0 <wakeup>
  release(&p->lock);
801037bb:	89 34 24             	mov    %esi,(%esp)
801037be:	e8 2d 10 00 00       	call   801047f0 <release>
  return i;
801037c3:	83 c4 10             	add    $0x10,%esp
}
801037c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037c9:	89 d8                	mov    %ebx,%eax
801037cb:	5b                   	pop    %ebx
801037cc:	5e                   	pop    %esi
801037cd:	5f                   	pop    %edi
801037ce:	5d                   	pop    %ebp
801037cf:	c3                   	ret    
      release(&p->lock);
801037d0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801037d3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801037d8:	56                   	push   %esi
801037d9:	e8 12 10 00 00       	call   801047f0 <release>
      return -1;
801037de:	83 c4 10             	add    $0x10,%esp
}
801037e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037e4:	89 d8                	mov    %ebx,%eax
801037e6:	5b                   	pop    %ebx
801037e7:	5e                   	pop    %esi
801037e8:	5f                   	pop    %edi
801037e9:	5d                   	pop    %ebp
801037ea:	c3                   	ret    
801037eb:	66 90                	xchg   %ax,%ax
801037ed:	66 90                	xchg   %ax,%ax
801037ef:	90                   	nop

801037f0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801037f0:	55                   	push   %ebp
801037f1:	89 e5                	mov    %esp,%ebp
801037f3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037f4:	bb 94 38 11 80       	mov    $0x80113894,%ebx
{
801037f9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801037fc:	68 60 38 11 80       	push   $0x80113860
80103801:	e8 2a 0f 00 00       	call   80104730 <acquire>
80103806:	83 c4 10             	add    $0x10,%esp
80103809:	eb 10                	jmp    8010381b <allocproc+0x2b>
8010380b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010380f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103810:	83 eb 80             	sub    $0xffffff80,%ebx
80103813:	81 fb 94 58 11 80    	cmp    $0x80115894,%ebx
80103819:	74 75                	je     80103890 <allocproc+0xa0>
    if(p->state == UNUSED)
8010381b:	8b 43 10             	mov    0x10(%ebx),%eax
8010381e:	85 c0                	test   %eax,%eax
80103820:	75 ee                	jne    80103810 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103822:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
80103827:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
8010382a:	c7 43 10 01 00 00 00 	movl   $0x1,0x10(%ebx)
  p->pid = nextpid++;
80103831:	89 43 14             	mov    %eax,0x14(%ebx)
80103834:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103837:	68 60 38 11 80       	push   $0x80113860
  p->pid = nextpid++;
8010383c:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103842:	e8 a9 0f 00 00       	call   801047f0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103847:	e8 f4 ed ff ff       	call   80102640 <kalloc>
8010384c:	83 c4 10             	add    $0x10,%esp
8010384f:	89 43 0c             	mov    %eax,0xc(%ebx)
80103852:	85 c0                	test   %eax,%eax
80103854:	74 53                	je     801038a9 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103856:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010385c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010385f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103864:	89 53 1c             	mov    %edx,0x1c(%ebx)
  *(uint*)sp = (uint)trapret;
80103867:	c7 40 14 86 5a 10 80 	movl   $0x80105a86,0x14(%eax)
  p->context = (struct context*)sp;
8010386e:	89 43 20             	mov    %eax,0x20(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103871:	6a 14                	push   $0x14
80103873:	6a 00                	push   $0x0
80103875:	50                   	push   %eax
80103876:	e8 c5 0f 00 00       	call   80104840 <memset>
  p->context->eip = (uint)forkret;
8010387b:	8b 43 20             	mov    0x20(%ebx),%eax

  return p;
8010387e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103881:	c7 40 10 c0 38 10 80 	movl   $0x801038c0,0x10(%eax)
}
80103888:	89 d8                	mov    %ebx,%eax
8010388a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010388d:	c9                   	leave  
8010388e:	c3                   	ret    
8010388f:	90                   	nop
  release(&ptable.lock);
80103890:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103893:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103895:	68 60 38 11 80       	push   $0x80113860
8010389a:	e8 51 0f 00 00       	call   801047f0 <release>
}
8010389f:	89 d8                	mov    %ebx,%eax
  return 0;
801038a1:	83 c4 10             	add    $0x10,%esp
}
801038a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038a7:	c9                   	leave  
801038a8:	c3                   	ret    
    p->state = UNUSED;
801038a9:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
    return 0;
801038b0:	31 db                	xor    %ebx,%ebx
}
801038b2:	89 d8                	mov    %ebx,%eax
801038b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038b7:	c9                   	leave  
801038b8:	c3                   	ret    
801038b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801038c0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801038c0:	f3 0f 1e fb          	endbr32 
801038c4:	55                   	push   %ebp
801038c5:	89 e5                	mov    %esp,%ebp
801038c7:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801038ca:	68 60 38 11 80       	push   $0x80113860
801038cf:	e8 1c 0f 00 00       	call   801047f0 <release>

  if (first) {
801038d4:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801038d9:	83 c4 10             	add    $0x10,%esp
801038dc:	85 c0                	test   %eax,%eax
801038de:	75 08                	jne    801038e8 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801038e0:	c9                   	leave  
801038e1:	c3                   	ret    
801038e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
801038e8:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
801038ef:	00 00 00 
    iinit(ROOTDEV);
801038f2:	83 ec 0c             	sub    $0xc,%esp
801038f5:	6a 01                	push   $0x1
801038f7:	e8 44 dc ff ff       	call   80101540 <iinit>
    initlog(ROOTDEV);
801038fc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103903:	e8 e8 f3 ff ff       	call   80102cf0 <initlog>
}
80103908:	83 c4 10             	add    $0x10,%esp
8010390b:	c9                   	leave  
8010390c:	c3                   	ret    
8010390d:	8d 76 00             	lea    0x0(%esi),%esi

80103910 <pinit>:
{
80103910:	f3 0f 1e fb          	endbr32 
80103914:	55                   	push   %ebp
80103915:	89 e5                	mov    %esp,%ebp
80103917:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
8010391a:	68 80 7c 10 80       	push   $0x80107c80
8010391f:	68 60 38 11 80       	push   $0x80113860
80103924:	e8 87 0c 00 00       	call   801045b0 <initlock>
}
80103929:	83 c4 10             	add    $0x10,%esp
8010392c:	c9                   	leave  
8010392d:	c3                   	ret    
8010392e:	66 90                	xchg   %ax,%ax

80103930 <mycpu>:
{
80103930:	f3 0f 1e fb          	endbr32 
80103934:	55                   	push   %ebp
80103935:	89 e5                	mov    %esp,%ebp
80103937:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010393a:	9c                   	pushf  
8010393b:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010393c:	f6 c4 02             	test   $0x2,%ah
8010393f:	75 36                	jne    80103977 <mycpu+0x47>
  apicid = lapicid();
80103941:	e8 ba ef ff ff       	call   80102900 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103946:	8b 15 50 38 11 80    	mov    0x80113850,%edx
8010394c:	85 d2                	test   %edx,%edx
8010394e:	7e 0b                	jle    8010395b <mycpu+0x2b>
    if (cpus[i].apicid == apicid)
80103950:	0f b6 15 a0 37 11 80 	movzbl 0x801137a0,%edx
80103957:	39 d0                	cmp    %edx,%eax
80103959:	74 15                	je     80103970 <mycpu+0x40>
  panic("unknown apicid\n");
8010395b:	83 ec 0c             	sub    $0xc,%esp
8010395e:	68 87 7c 10 80       	push   $0x80107c87
80103963:	e8 28 ca ff ff       	call   80100390 <panic>
80103968:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010396f:	90                   	nop
}
80103970:	c9                   	leave  
80103971:	b8 a0 37 11 80       	mov    $0x801137a0,%eax
80103976:	c3                   	ret    
    panic("mycpu called with interrupts enabled\n");
80103977:	83 ec 0c             	sub    $0xc,%esp
8010397a:	68 50 7e 10 80       	push   $0x80107e50
8010397f:	e8 0c ca ff ff       	call   80100390 <panic>
80103984:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010398b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010398f:	90                   	nop

80103990 <cpuid>:
cpuid() {
80103990:	f3 0f 1e fb          	endbr32 
80103994:	55                   	push   %ebp
80103995:	89 e5                	mov    %esp,%ebp
80103997:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
8010399a:	e8 91 ff ff ff       	call   80103930 <mycpu>
}
8010399f:	c9                   	leave  
  return mycpu()-cpus;
801039a0:	2d a0 37 11 80       	sub    $0x801137a0,%eax
801039a5:	c1 f8 04             	sar    $0x4,%eax
801039a8:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801039ae:	c3                   	ret    
801039af:	90                   	nop

801039b0 <myproc>:
myproc(void) {
801039b0:	f3 0f 1e fb          	endbr32 
801039b4:	55                   	push   %ebp
801039b5:	89 e5                	mov    %esp,%ebp
801039b7:	53                   	push   %ebx
801039b8:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801039bb:	e8 70 0c 00 00       	call   80104630 <pushcli>
  c = mycpu();
801039c0:	e8 6b ff ff ff       	call   80103930 <mycpu>
  p = c->proc;
801039c5:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801039cb:	e8 b0 0c 00 00       	call   80104680 <popcli>
}
801039d0:	83 c4 04             	add    $0x4,%esp
801039d3:	89 d8                	mov    %ebx,%eax
801039d5:	5b                   	pop    %ebx
801039d6:	5d                   	pop    %ebp
801039d7:	c3                   	ret    
801039d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039df:	90                   	nop

801039e0 <userinit>:
{
801039e0:	f3 0f 1e fb          	endbr32 
801039e4:	55                   	push   %ebp
801039e5:	89 e5                	mov    %esp,%ebp
801039e7:	53                   	push   %ebx
801039e8:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801039eb:	e8 00 fe ff ff       	call   801037f0 <allocproc>
801039f0:	89 c3                	mov    %eax,%ebx
  initproc = p;
801039f2:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
801039f7:	e8 44 37 00 00       	call   80107140 <setupkvm>
801039fc:	89 43 08             	mov    %eax,0x8(%ebx)
801039ff:	85 c0                	test   %eax,%eax
80103a01:	0f 84 bd 00 00 00    	je     80103ac4 <userinit+0xe4>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103a07:	83 ec 04             	sub    $0x4,%esp
80103a0a:	68 2c 00 00 00       	push   $0x2c
80103a0f:	68 60 b4 10 80       	push   $0x8010b460
80103a14:	50                   	push   %eax
80103a15:	e8 66 33 00 00       	call   80106d80 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103a1a:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103a1d:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103a23:	6a 4c                	push   $0x4c
80103a25:	6a 00                	push   $0x0
80103a27:	ff 73 1c             	pushl  0x1c(%ebx)
80103a2a:	e8 11 0e 00 00       	call   80104840 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a2f:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103a32:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a37:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a3a:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a3f:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a43:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103a46:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103a4a:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103a4d:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a51:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103a55:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103a58:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a5c:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103a60:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103a63:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103a6a:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103a6d:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103a74:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103a77:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a7e:	8d 43 70             	lea    0x70(%ebx),%eax
80103a81:	6a 10                	push   $0x10
80103a83:	68 b0 7c 10 80       	push   $0x80107cb0
80103a88:	50                   	push   %eax
80103a89:	e8 72 0f 00 00       	call   80104a00 <safestrcpy>
  p->cwd = namei("/");
80103a8e:	c7 04 24 b9 7c 10 80 	movl   $0x80107cb9,(%esp)
80103a95:	e8 96 e5 ff ff       	call   80102030 <namei>
80103a9a:	89 43 6c             	mov    %eax,0x6c(%ebx)
  acquire(&ptable.lock);
80103a9d:	c7 04 24 60 38 11 80 	movl   $0x80113860,(%esp)
80103aa4:	e8 87 0c 00 00       	call   80104730 <acquire>
  p->state = RUNNABLE;
80103aa9:	c7 43 10 03 00 00 00 	movl   $0x3,0x10(%ebx)
  release(&ptable.lock);
80103ab0:	c7 04 24 60 38 11 80 	movl   $0x80113860,(%esp)
80103ab7:	e8 34 0d 00 00       	call   801047f0 <release>
}
80103abc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103abf:	83 c4 10             	add    $0x10,%esp
80103ac2:	c9                   	leave  
80103ac3:	c3                   	ret    
    panic("userinit: out of memory?");
80103ac4:	83 ec 0c             	sub    $0xc,%esp
80103ac7:	68 97 7c 10 80       	push   $0x80107c97
80103acc:	e8 bf c8 ff ff       	call   80100390 <panic>
80103ad1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ad8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103adf:	90                   	nop

80103ae0 <growproc>:
{
80103ae0:	f3 0f 1e fb          	endbr32 
80103ae4:	55                   	push   %ebp
80103ae5:	89 e5                	mov    %esp,%ebp
80103ae7:	56                   	push   %esi
80103ae8:	53                   	push   %ebx
80103ae9:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103aec:	e8 3f 0b 00 00       	call   80104630 <pushcli>
  c = mycpu();
80103af1:	e8 3a fe ff ff       	call   80103930 <mycpu>
  p = c->proc;
80103af6:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103afc:	e8 7f 0b 00 00       	call   80104680 <popcli>
  sz = curproc->sz;
80103b01:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103b03:	85 f6                	test   %esi,%esi
80103b05:	7f 19                	jg     80103b20 <growproc+0x40>
  } else if(n < 0){
80103b07:	75 37                	jne    80103b40 <growproc+0x60>
  switchuvm(curproc);
80103b09:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103b0c:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103b0e:	53                   	push   %ebx
80103b0f:	e8 5c 31 00 00       	call   80106c70 <switchuvm>
  return 0;
80103b14:	83 c4 10             	add    $0x10,%esp
80103b17:	31 c0                	xor    %eax,%eax
}
80103b19:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b1c:	5b                   	pop    %ebx
80103b1d:	5e                   	pop    %esi
80103b1e:	5d                   	pop    %ebp
80103b1f:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b20:	83 ec 04             	sub    $0x4,%esp
80103b23:	01 c6                	add    %eax,%esi
80103b25:	56                   	push   %esi
80103b26:	50                   	push   %eax
80103b27:	ff 73 08             	pushl  0x8(%ebx)
80103b2a:	e8 e1 33 00 00       	call   80106f10 <allocuvm>
80103b2f:	83 c4 10             	add    $0x10,%esp
80103b32:	85 c0                	test   %eax,%eax
80103b34:	75 d3                	jne    80103b09 <growproc+0x29>
      return -1;
80103b36:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b3b:	eb dc                	jmp    80103b19 <growproc+0x39>
80103b3d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b40:	83 ec 04             	sub    $0x4,%esp
80103b43:	01 c6                	add    %eax,%esi
80103b45:	56                   	push   %esi
80103b46:	50                   	push   %eax
80103b47:	ff 73 08             	pushl  0x8(%ebx)
80103b4a:	e8 41 35 00 00       	call   80107090 <deallocuvm>
80103b4f:	83 c4 10             	add    $0x10,%esp
80103b52:	85 c0                	test   %eax,%eax
80103b54:	75 b3                	jne    80103b09 <growproc+0x29>
80103b56:	eb de                	jmp    80103b36 <growproc+0x56>
80103b58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b5f:	90                   	nop

80103b60 <fork>:
{
80103b60:	f3 0f 1e fb          	endbr32 
80103b64:	55                   	push   %ebp
80103b65:	89 e5                	mov    %esp,%ebp
80103b67:	57                   	push   %edi
80103b68:	56                   	push   %esi
80103b69:	53                   	push   %ebx
80103b6a:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103b6d:	e8 be 0a 00 00       	call   80104630 <pushcli>
  c = mycpu();
80103b72:	e8 b9 fd ff ff       	call   80103930 <mycpu>
  p = c->proc;
80103b77:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b7d:	e8 fe 0a 00 00       	call   80104680 <popcli>
  if((np = allocproc()) == 0){
80103b82:	e8 69 fc ff ff       	call   801037f0 <allocproc>
80103b87:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103b8a:	85 c0                	test   %eax,%eax
80103b8c:	0f 84 d0 00 00 00    	je     80103c62 <fork+0x102>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz,np->pid)) == 0){
80103b92:	83 ec 04             	sub    $0x4,%esp
80103b95:	ff 70 14             	pushl  0x14(%eax)
80103b98:	89 c7                	mov    %eax,%edi
80103b9a:	ff 33                	pushl  (%ebx)
80103b9c:	ff 73 08             	pushl  0x8(%ebx)
80103b9f:	e8 6c 36 00 00       	call   80107210 <copyuvm>
80103ba4:	83 c4 10             	add    $0x10,%esp
80103ba7:	89 47 08             	mov    %eax,0x8(%edi)
80103baa:	85 c0                	test   %eax,%eax
80103bac:	0f 84 b7 00 00 00    	je     80103c69 <fork+0x109>
  np->sz = curproc->sz;
80103bb2:	8b 03                	mov    (%ebx),%eax
80103bb4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103bb7:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103bb9:	8b 79 1c             	mov    0x1c(%ecx),%edi
  np->parent = curproc;
80103bbc:	89 c8                	mov    %ecx,%eax
80103bbe:	89 59 18             	mov    %ebx,0x18(%ecx)
  *np->tf = *curproc->tf;
80103bc1:	b9 13 00 00 00       	mov    $0x13,%ecx
80103bc6:	8b 73 1c             	mov    0x1c(%ebx),%esi
80103bc9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103bcb:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103bcd:	8b 40 1c             	mov    0x1c(%eax),%eax
80103bd0:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103bd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103bde:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[i])
80103be0:	8b 44 b3 2c          	mov    0x2c(%ebx,%esi,4),%eax
80103be4:	85 c0                	test   %eax,%eax
80103be6:	74 13                	je     80103bfb <fork+0x9b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103be8:	83 ec 0c             	sub    $0xc,%esp
80103beb:	50                   	push   %eax
80103bec:	e8 7f d2 ff ff       	call   80100e70 <filedup>
80103bf1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103bf4:	83 c4 10             	add    $0x10,%esp
80103bf7:	89 44 b2 2c          	mov    %eax,0x2c(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103bfb:	83 c6 01             	add    $0x1,%esi
80103bfe:	83 fe 10             	cmp    $0x10,%esi
80103c01:	75 dd                	jne    80103be0 <fork+0x80>
  np->cwd = idup(curproc->cwd);
80103c03:	83 ec 0c             	sub    $0xc,%esp
80103c06:	ff 73 6c             	pushl  0x6c(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c09:	83 c3 70             	add    $0x70,%ebx
  np->cwd = idup(curproc->cwd);
80103c0c:	e8 1f db ff ff       	call   80101730 <idup>
80103c11:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c14:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103c17:	89 47 6c             	mov    %eax,0x6c(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c1a:	8d 47 70             	lea    0x70(%edi),%eax
80103c1d:	6a 10                	push   $0x10
80103c1f:	53                   	push   %ebx
80103c20:	50                   	push   %eax
80103c21:	e8 da 0d 00 00       	call   80104a00 <safestrcpy>
  pid = np->pid;
80103c26:	8b 5f 14             	mov    0x14(%edi),%ebx
  cprintf("The pid is %d\n", pid);
80103c29:	58                   	pop    %eax
80103c2a:	5a                   	pop    %edx
80103c2b:	53                   	push   %ebx
80103c2c:	68 bb 7c 10 80       	push   $0x80107cbb
80103c31:	e8 7a ca ff ff       	call   801006b0 <cprintf>
  acquire(&ptable.lock);
80103c36:	c7 04 24 60 38 11 80 	movl   $0x80113860,(%esp)
80103c3d:	e8 ee 0a 00 00       	call   80104730 <acquire>
  np->state = RUNNABLE;
80103c42:	c7 47 10 03 00 00 00 	movl   $0x3,0x10(%edi)
  release(&ptable.lock);
80103c49:	c7 04 24 60 38 11 80 	movl   $0x80113860,(%esp)
80103c50:	e8 9b 0b 00 00       	call   801047f0 <release>
  return pid;
80103c55:	83 c4 10             	add    $0x10,%esp
}
80103c58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c5b:	89 d8                	mov    %ebx,%eax
80103c5d:	5b                   	pop    %ebx
80103c5e:	5e                   	pop    %esi
80103c5f:	5f                   	pop    %edi
80103c60:	5d                   	pop    %ebp
80103c61:	c3                   	ret    
    return -1;
80103c62:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c67:	eb ef                	jmp    80103c58 <fork+0xf8>
    kfree(np->kstack);
80103c69:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103c6c:	83 ec 0c             	sub    $0xc,%esp
80103c6f:	ff 73 0c             	pushl  0xc(%ebx)
80103c72:	e8 f9 e7 ff ff       	call   80102470 <kfree>
    np->kstack = 0;
80103c77:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103c7e:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103c81:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
    return -1;
80103c88:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c8d:	eb c9                	jmp    80103c58 <fork+0xf8>
80103c8f:	90                   	nop

80103c90 <print_rss>:
{
80103c90:	f3 0f 1e fb          	endbr32 
80103c94:	55                   	push   %ebp
80103c95:	89 e5                	mov    %esp,%ebp
80103c97:	53                   	push   %ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c98:	bb 94 38 11 80       	mov    $0x80113894,%ebx
{
80103c9d:	83 ec 10             	sub    $0x10,%esp
  cprintf("PrintingRSS\n");
80103ca0:	68 ca 7c 10 80       	push   $0x80107cca
80103ca5:	e8 06 ca ff ff       	call   801006b0 <cprintf>
  acquire(&ptable.lock);
80103caa:	c7 04 24 60 38 11 80 	movl   $0x80113860,(%esp)
80103cb1:	e8 7a 0a 00 00       	call   80104730 <acquire>
80103cb6:	83 c4 10             	add    $0x10,%esp
80103cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((p->state == UNUSED))
80103cc0:	8b 43 10             	mov    0x10(%ebx),%eax
80103cc3:	85 c0                	test   %eax,%eax
80103cc5:	74 14                	je     80103cdb <print_rss+0x4b>
    cprintf("((P)) id: %d, state: %d, rss: %d\n",p->pid,p->state,p->rss);
80103cc7:	ff 73 04             	pushl  0x4(%ebx)
80103cca:	50                   	push   %eax
80103ccb:	ff 73 14             	pushl  0x14(%ebx)
80103cce:	68 78 7e 10 80       	push   $0x80107e78
80103cd3:	e8 d8 c9 ff ff       	call   801006b0 <cprintf>
80103cd8:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103cdb:	83 eb 80             	sub    $0xffffff80,%ebx
80103cde:	81 fb 94 58 11 80    	cmp    $0x80115894,%ebx
80103ce4:	75 da                	jne    80103cc0 <print_rss+0x30>
  release(&ptable.lock);
80103ce6:	83 ec 0c             	sub    $0xc,%esp
80103ce9:	68 60 38 11 80       	push   $0x80113860
80103cee:	e8 fd 0a 00 00       	call   801047f0 <release>
}
80103cf3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103cf6:	83 c4 10             	add    $0x10,%esp
80103cf9:	c9                   	leave  
80103cfa:	c3                   	ret    
80103cfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103cff:	90                   	nop

80103d00 <scheduler>:
{
80103d00:	f3 0f 1e fb          	endbr32 
80103d04:	55                   	push   %ebp
80103d05:	89 e5                	mov    %esp,%ebp
80103d07:	57                   	push   %edi
80103d08:	56                   	push   %esi
80103d09:	53                   	push   %ebx
80103d0a:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103d0d:	e8 1e fc ff ff       	call   80103930 <mycpu>
  c->proc = 0;
80103d12:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103d19:	00 00 00 
  struct cpu *c = mycpu();
80103d1c:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103d1e:	8d 78 04             	lea    0x4(%eax),%edi
80103d21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
80103d28:	fb                   	sti    
    acquire(&ptable.lock);
80103d29:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d2c:	bb 94 38 11 80       	mov    $0x80113894,%ebx
    acquire(&ptable.lock);
80103d31:	68 60 38 11 80       	push   $0x80113860
80103d36:	e8 f5 09 00 00       	call   80104730 <acquire>
80103d3b:	83 c4 10             	add    $0x10,%esp
80103d3e:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80103d40:	83 7b 10 03          	cmpl   $0x3,0x10(%ebx)
80103d44:	75 33                	jne    80103d79 <scheduler+0x79>
      switchuvm(p);
80103d46:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103d49:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103d4f:	53                   	push   %ebx
80103d50:	e8 1b 2f 00 00       	call   80106c70 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103d55:	58                   	pop    %eax
80103d56:	5a                   	pop    %edx
80103d57:	ff 73 20             	pushl  0x20(%ebx)
80103d5a:	57                   	push   %edi
      p->state = RUNNING;
80103d5b:	c7 43 10 04 00 00 00 	movl   $0x4,0x10(%ebx)
      swtch(&(c->scheduler), p->context);
80103d62:	e8 fc 0c 00 00       	call   80104a63 <swtch>
      switchkvm();
80103d67:	e8 e4 2e 00 00       	call   80106c50 <switchkvm>
      c->proc = 0;
80103d6c:	83 c4 10             	add    $0x10,%esp
80103d6f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103d76:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d79:	83 eb 80             	sub    $0xffffff80,%ebx
80103d7c:	81 fb 94 58 11 80    	cmp    $0x80115894,%ebx
80103d82:	75 bc                	jne    80103d40 <scheduler+0x40>
    release(&ptable.lock);
80103d84:	83 ec 0c             	sub    $0xc,%esp
80103d87:	68 60 38 11 80       	push   $0x80113860
80103d8c:	e8 5f 0a 00 00       	call   801047f0 <release>
    sti();
80103d91:	83 c4 10             	add    $0x10,%esp
80103d94:	eb 92                	jmp    80103d28 <scheduler+0x28>
80103d96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d9d:	8d 76 00             	lea    0x0(%esi),%esi

80103da0 <sched>:
{
80103da0:	f3 0f 1e fb          	endbr32 
80103da4:	55                   	push   %ebp
80103da5:	89 e5                	mov    %esp,%ebp
80103da7:	56                   	push   %esi
80103da8:	53                   	push   %ebx
  pushcli();
80103da9:	e8 82 08 00 00       	call   80104630 <pushcli>
  c = mycpu();
80103dae:	e8 7d fb ff ff       	call   80103930 <mycpu>
  p = c->proc;
80103db3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103db9:	e8 c2 08 00 00       	call   80104680 <popcli>
  cprintf("Check 7: pid: %d %d\n", p->pid, p->parent->pid);
80103dbe:	83 ec 04             	sub    $0x4,%esp
80103dc1:	8b 43 18             	mov    0x18(%ebx),%eax
80103dc4:	ff 70 14             	pushl  0x14(%eax)
80103dc7:	ff 73 14             	pushl  0x14(%ebx)
80103dca:	68 d7 7c 10 80       	push   $0x80107cd7
80103dcf:	e8 dc c8 ff ff       	call   801006b0 <cprintf>
  if(!holding(&ptable.lock))
80103dd4:	c7 04 24 60 38 11 80 	movl   $0x80113860,(%esp)
80103ddb:	e8 00 09 00 00       	call   801046e0 <holding>
80103de0:	83 c4 10             	add    $0x10,%esp
80103de3:	85 c0                	test   %eax,%eax
80103de5:	0f 84 b7 00 00 00    	je     80103ea2 <sched+0x102>
  cprintf("Check 8\n");
80103deb:	83 ec 0c             	sub    $0xc,%esp
80103dee:	68 fe 7c 10 80       	push   $0x80107cfe
80103df3:	e8 b8 c8 ff ff       	call   801006b0 <cprintf>
  if(mycpu()->ncli != 1)
80103df8:	e8 33 fb ff ff       	call   80103930 <mycpu>
80103dfd:	83 c4 10             	add    $0x10,%esp
80103e00:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103e07:	0f 85 bc 00 00 00    	jne    80103ec9 <sched+0x129>
  cprintf("Check 9\n");
80103e0d:	83 ec 0c             	sub    $0xc,%esp
80103e10:	68 13 7d 10 80       	push   $0x80107d13
80103e15:	e8 96 c8 ff ff       	call   801006b0 <cprintf>
  if(p->state == RUNNING)
80103e1a:	83 c4 10             	add    $0x10,%esp
80103e1d:	83 7b 10 04          	cmpl   $0x4,0x10(%ebx)
80103e21:	0f 84 95 00 00 00    	je     80103ebc <sched+0x11c>
  cprintf("Check 10\n");
80103e27:	83 ec 0c             	sub    $0xc,%esp
80103e2a:	68 2a 7d 10 80       	push   $0x80107d2a
80103e2f:	e8 7c c8 ff ff       	call   801006b0 <cprintf>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103e34:	9c                   	pushf  
80103e35:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103e36:	83 c4 10             	add    $0x10,%esp
80103e39:	f6 c4 02             	test   $0x2,%ah
80103e3c:	75 71                	jne    80103eaf <sched+0x10f>
  cprintf("Check 11\n");
80103e3e:	83 ec 0c             	sub    $0xc,%esp
  swtch(&p->context, mycpu()->scheduler);
80103e41:	83 c3 20             	add    $0x20,%ebx
  cprintf("Check 11\n");
80103e44:	68 48 7d 10 80       	push   $0x80107d48
80103e49:	e8 62 c8 ff ff       	call   801006b0 <cprintf>
  intena = mycpu()->intena;
80103e4e:	e8 dd fa ff ff       	call   80103930 <mycpu>
80103e53:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  cprintf("Check 12\n");
80103e59:	c7 04 24 52 7d 10 80 	movl   $0x80107d52,(%esp)
80103e60:	e8 4b c8 ff ff       	call   801006b0 <cprintf>
  swtch(&p->context, mycpu()->scheduler);
80103e65:	e8 c6 fa ff ff       	call   80103930 <mycpu>
80103e6a:	5a                   	pop    %edx
80103e6b:	59                   	pop    %ecx
80103e6c:	ff 70 04             	pushl  0x4(%eax)
80103e6f:	53                   	push   %ebx
80103e70:	e8 ee 0b 00 00       	call   80104a63 <swtch>
  cprintf("Check 13\n");
80103e75:	c7 04 24 5c 7d 10 80 	movl   $0x80107d5c,(%esp)
80103e7c:	e8 2f c8 ff ff       	call   801006b0 <cprintf>
  mycpu()->intena = intena;
80103e81:	e8 aa fa ff ff       	call   80103930 <mycpu>
80103e86:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
  cprintf("Returning sched function\n");
80103e8c:	c7 04 24 66 7d 10 80 	movl   $0x80107d66,(%esp)
80103e93:	e8 18 c8 ff ff       	call   801006b0 <cprintf>
}
80103e98:	83 c4 10             	add    $0x10,%esp
80103e9b:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e9e:	5b                   	pop    %ebx
80103e9f:	5e                   	pop    %esi
80103ea0:	5d                   	pop    %ebp
80103ea1:	c3                   	ret    
    panic("sched ptable.lock");
80103ea2:	83 ec 0c             	sub    $0xc,%esp
80103ea5:	68 ec 7c 10 80       	push   $0x80107cec
80103eaa:	e8 e1 c4 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103eaf:	83 ec 0c             	sub    $0xc,%esp
80103eb2:	68 34 7d 10 80       	push   $0x80107d34
80103eb7:	e8 d4 c4 ff ff       	call   80100390 <panic>
    panic("sched running");
80103ebc:	83 ec 0c             	sub    $0xc,%esp
80103ebf:	68 1c 7d 10 80       	push   $0x80107d1c
80103ec4:	e8 c7 c4 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103ec9:	83 ec 0c             	sub    $0xc,%esp
80103ecc:	68 07 7d 10 80       	push   $0x80107d07
80103ed1:	e8 ba c4 ff ff       	call   80100390 <panic>
80103ed6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103edd:	8d 76 00             	lea    0x0(%esi),%esi

80103ee0 <exit>:
{
80103ee0:	f3 0f 1e fb          	endbr32 
80103ee4:	55                   	push   %ebp
80103ee5:	89 e5                	mov    %esp,%ebp
80103ee7:	57                   	push   %edi
80103ee8:	56                   	push   %esi
80103ee9:	53                   	push   %ebx
80103eea:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103eed:	e8 3e 07 00 00       	call   80104630 <pushcli>
  c = mycpu();
80103ef2:	e8 39 fa ff ff       	call   80103930 <mycpu>
  p = c->proc;
80103ef7:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103efd:	e8 7e 07 00 00       	call   80104680 <popcli>
  cprintf("Entering exit pid: %d\n", curproc->pid);
80103f02:	83 ec 08             	sub    $0x8,%esp
80103f05:	ff 73 14             	pushl  0x14(%ebx)
80103f08:	68 80 7d 10 80       	push   $0x80107d80
80103f0d:	e8 9e c7 ff ff       	call   801006b0 <cprintf>
  if(curproc == initproc)
80103f12:	83 c4 10             	add    $0x10,%esp
80103f15:	39 1d b8 b5 10 80    	cmp    %ebx,0x8010b5b8
80103f1b:	0f 84 5a 01 00 00    	je     8010407b <exit+0x19b>
  cprintf("Check 1\n");
80103f21:	83 ec 0c             	sub    $0xc,%esp
80103f24:	8d 73 2c             	lea    0x2c(%ebx),%esi
80103f27:	8d 7b 6c             	lea    0x6c(%ebx),%edi
80103f2a:	68 a4 7d 10 80       	push   $0x80107da4
80103f2f:	e8 7c c7 ff ff       	call   801006b0 <cprintf>
  for(fd = 0; fd < NOFILE; fd++){
80103f34:	83 c4 10             	add    $0x10,%esp
80103f37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f3e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd]){
80103f40:	8b 06                	mov    (%esi),%eax
80103f42:	85 c0                	test   %eax,%eax
80103f44:	74 12                	je     80103f58 <exit+0x78>
      fileclose(curproc->ofile[fd]);
80103f46:	83 ec 0c             	sub    $0xc,%esp
80103f49:	50                   	push   %eax
80103f4a:	e8 71 cf ff ff       	call   80100ec0 <fileclose>
      curproc->ofile[fd] = 0;
80103f4f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103f55:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103f58:	83 c6 04             	add    $0x4,%esi
80103f5b:	39 fe                	cmp    %edi,%esi
80103f5d:	75 e1                	jne    80103f40 <exit+0x60>
  cprintf("Check 2\n");
80103f5f:	83 ec 0c             	sub    $0xc,%esp
80103f62:	68 ad 7d 10 80       	push   $0x80107dad
80103f67:	e8 44 c7 ff ff       	call   801006b0 <cprintf>
  begin_op();
80103f6c:	e8 1f ee ff ff       	call   80102d90 <begin_op>
  iput(curproc->cwd);
80103f71:	58                   	pop    %eax
80103f72:	ff 73 6c             	pushl  0x6c(%ebx)
80103f75:	e8 16 d9 ff ff       	call   80101890 <iput>
  end_op();
80103f7a:	e8 81 ee ff ff       	call   80102e00 <end_op>
  curproc->cwd = 0;
80103f7f:	c7 43 6c 00 00 00 00 	movl   $0x0,0x6c(%ebx)
  acquire(&ptable.lock);
80103f86:	c7 04 24 60 38 11 80 	movl   $0x80113860,(%esp)
80103f8d:	e8 9e 07 00 00       	call   80104730 <acquire>
   cprintf("Check 3\n");
80103f92:	c7 04 24 b6 7d 10 80 	movl   $0x80107db6,(%esp)
80103f99:	e8 12 c7 ff ff       	call   801006b0 <cprintf>
  wakeup1(curproc->parent);
80103f9e:	8b 53 18             	mov    0x18(%ebx),%edx
80103fa1:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fa4:	b8 94 38 11 80       	mov    $0x80113894,%eax
80103fa9:	eb 0f                	jmp    80103fba <exit+0xda>
80103fab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103faf:	90                   	nop
80103fb0:	83 e8 80             	sub    $0xffffff80,%eax
80103fb3:	3d 94 58 11 80       	cmp    $0x80115894,%eax
80103fb8:	74 1c                	je     80103fd6 <exit+0xf6>
    if(p->state == SLEEPING && p->chan == chan)
80103fba:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
80103fbe:	75 f0                	jne    80103fb0 <exit+0xd0>
80103fc0:	3b 50 24             	cmp    0x24(%eax),%edx
80103fc3:	75 eb                	jne    80103fb0 <exit+0xd0>
      p->state = RUNNABLE;
80103fc5:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fcc:	83 e8 80             	sub    $0xffffff80,%eax
80103fcf:	3d 94 58 11 80       	cmp    $0x80115894,%eax
80103fd4:	75 e4                	jne    80103fba <exit+0xda>
   cprintf("Check 4\n");
80103fd6:	83 ec 0c             	sub    $0xc,%esp
80103fd9:	68 bf 7d 10 80       	push   $0x80107dbf
80103fde:	e8 cd c6 ff ff       	call   801006b0 <cprintf>
      p->parent = initproc;
80103fe3:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
80103fe9:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fec:	ba 94 38 11 80       	mov    $0x80113894,%edx
80103ff1:	eb 10                	jmp    80104003 <exit+0x123>
80103ff3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ff7:	90                   	nop
80103ff8:	83 ea 80             	sub    $0xffffff80,%edx
80103ffb:	81 fa 94 58 11 80    	cmp    $0x80115894,%edx
80104001:	74 3b                	je     8010403e <exit+0x15e>
    if(p->parent == curproc){
80104003:	39 5a 18             	cmp    %ebx,0x18(%edx)
80104006:	75 f0                	jne    80103ff8 <exit+0x118>
      if(p->state == ZOMBIE)
80104008:	83 7a 10 05          	cmpl   $0x5,0x10(%edx)
      p->parent = initproc;
8010400c:	89 4a 18             	mov    %ecx,0x18(%edx)
      if(p->state == ZOMBIE)
8010400f:	75 e7                	jne    80103ff8 <exit+0x118>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104011:	b8 94 38 11 80       	mov    $0x80113894,%eax
80104016:	eb 12                	jmp    8010402a <exit+0x14a>
80104018:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010401f:	90                   	nop
80104020:	83 e8 80             	sub    $0xffffff80,%eax
80104023:	3d 94 58 11 80       	cmp    $0x80115894,%eax
80104028:	74 ce                	je     80103ff8 <exit+0x118>
    if(p->state == SLEEPING && p->chan == chan)
8010402a:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
8010402e:	75 f0                	jne    80104020 <exit+0x140>
80104030:	3b 48 24             	cmp    0x24(%eax),%ecx
80104033:	75 eb                	jne    80104020 <exit+0x140>
      p->state = RUNNABLE;
80104035:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
8010403c:	eb e2                	jmp    80104020 <exit+0x140>
   cprintf("Check 5\n"); 
8010403e:	83 ec 0c             	sub    $0xc,%esp
80104041:	68 c8 7d 10 80       	push   $0x80107dc8
80104046:	e8 65 c6 ff ff       	call   801006b0 <cprintf>
  curproc->state = ZOMBIE;
8010404b:	c7 43 10 05 00 00 00 	movl   $0x5,0x10(%ebx)
  cprintf("Check 6\n");
80104052:	c7 04 24 d1 7d 10 80 	movl   $0x80107dd1,(%esp)
80104059:	e8 52 c6 ff ff       	call   801006b0 <cprintf>
  sched();
8010405e:	e8 3d fd ff ff       	call   80103da0 <sched>
  cprintf("Exited sched\n");
80104063:	c7 04 24 da 7d 10 80 	movl   $0x80107dda,(%esp)
8010406a:	e8 41 c6 ff ff       	call   801006b0 <cprintf>
  panic("zombie exit");
8010406f:	c7 04 24 e8 7d 10 80 	movl   $0x80107de8,(%esp)
80104076:	e8 15 c3 ff ff       	call   80100390 <panic>
    panic("init exiting");
8010407b:	83 ec 0c             	sub    $0xc,%esp
8010407e:	68 97 7d 10 80       	push   $0x80107d97
80104083:	e8 08 c3 ff ff       	call   80100390 <panic>
80104088:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010408f:	90                   	nop

80104090 <yield>:
{
80104090:	f3 0f 1e fb          	endbr32 
80104094:	55                   	push   %ebp
80104095:	89 e5                	mov    %esp,%ebp
80104097:	53                   	push   %ebx
80104098:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
8010409b:	68 60 38 11 80       	push   $0x80113860
801040a0:	e8 8b 06 00 00       	call   80104730 <acquire>
  pushcli();
801040a5:	e8 86 05 00 00       	call   80104630 <pushcli>
  c = mycpu();
801040aa:	e8 81 f8 ff ff       	call   80103930 <mycpu>
  p = c->proc;
801040af:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801040b5:	e8 c6 05 00 00       	call   80104680 <popcli>
  myproc()->state = RUNNABLE;
801040ba:	c7 43 10 03 00 00 00 	movl   $0x3,0x10(%ebx)
  sched();
801040c1:	e8 da fc ff ff       	call   80103da0 <sched>
  release(&ptable.lock);
801040c6:	c7 04 24 60 38 11 80 	movl   $0x80113860,(%esp)
801040cd:	e8 1e 07 00 00       	call   801047f0 <release>
}
801040d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040d5:	83 c4 10             	add    $0x10,%esp
801040d8:	c9                   	leave  
801040d9:	c3                   	ret    
801040da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801040e0 <sleep>:
{
801040e0:	f3 0f 1e fb          	endbr32 
801040e4:	55                   	push   %ebp
801040e5:	89 e5                	mov    %esp,%ebp
801040e7:	57                   	push   %edi
801040e8:	56                   	push   %esi
801040e9:	53                   	push   %ebx
801040ea:	83 ec 0c             	sub    $0xc,%esp
801040ed:	8b 7d 08             	mov    0x8(%ebp),%edi
801040f0:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801040f3:	e8 38 05 00 00       	call   80104630 <pushcli>
  c = mycpu();
801040f8:	e8 33 f8 ff ff       	call   80103930 <mycpu>
  p = c->proc;
801040fd:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104103:	e8 78 05 00 00       	call   80104680 <popcli>
  if(p == 0)
80104108:	85 db                	test   %ebx,%ebx
8010410a:	0f 84 83 00 00 00    	je     80104193 <sleep+0xb3>
  if(lk == 0)
80104110:	85 f6                	test   %esi,%esi
80104112:	74 72                	je     80104186 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104114:	81 fe 60 38 11 80    	cmp    $0x80113860,%esi
8010411a:	74 4c                	je     80104168 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
8010411c:	83 ec 0c             	sub    $0xc,%esp
8010411f:	68 60 38 11 80       	push   $0x80113860
80104124:	e8 07 06 00 00       	call   80104730 <acquire>
    release(lk);
80104129:	89 34 24             	mov    %esi,(%esp)
8010412c:	e8 bf 06 00 00       	call   801047f0 <release>
  p->chan = chan;
80104131:	89 7b 24             	mov    %edi,0x24(%ebx)
  p->state = SLEEPING;
80104134:	c7 43 10 02 00 00 00 	movl   $0x2,0x10(%ebx)
  sched();
8010413b:	e8 60 fc ff ff       	call   80103da0 <sched>
  p->chan = 0;
80104140:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
    release(&ptable.lock);
80104147:	c7 04 24 60 38 11 80 	movl   $0x80113860,(%esp)
8010414e:	e8 9d 06 00 00       	call   801047f0 <release>
    acquire(lk);
80104153:	89 75 08             	mov    %esi,0x8(%ebp)
80104156:	83 c4 10             	add    $0x10,%esp
}
80104159:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010415c:	5b                   	pop    %ebx
8010415d:	5e                   	pop    %esi
8010415e:	5f                   	pop    %edi
8010415f:	5d                   	pop    %ebp
    acquire(lk);
80104160:	e9 cb 05 00 00       	jmp    80104730 <acquire>
80104165:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
80104168:	89 7b 24             	mov    %edi,0x24(%ebx)
  p->state = SLEEPING;
8010416b:	c7 43 10 02 00 00 00 	movl   $0x2,0x10(%ebx)
  sched();
80104172:	e8 29 fc ff ff       	call   80103da0 <sched>
  p->chan = 0;
80104177:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
}
8010417e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104181:	5b                   	pop    %ebx
80104182:	5e                   	pop    %esi
80104183:	5f                   	pop    %edi
80104184:	5d                   	pop    %ebp
80104185:	c3                   	ret    
    panic("sleep without lk");
80104186:	83 ec 0c             	sub    $0xc,%esp
80104189:	68 fa 7d 10 80       	push   $0x80107dfa
8010418e:	e8 fd c1 ff ff       	call   80100390 <panic>
    panic("sleep");
80104193:	83 ec 0c             	sub    $0xc,%esp
80104196:	68 f4 7d 10 80       	push   $0x80107df4
8010419b:	e8 f0 c1 ff ff       	call   80100390 <panic>

801041a0 <wait>:
{
801041a0:	f3 0f 1e fb          	endbr32 
801041a4:	55                   	push   %ebp
801041a5:	89 e5                	mov    %esp,%ebp
801041a7:	56                   	push   %esi
801041a8:	53                   	push   %ebx
  pushcli();
801041a9:	e8 82 04 00 00       	call   80104630 <pushcli>
  c = mycpu();
801041ae:	e8 7d f7 ff ff       	call   80103930 <mycpu>
  p = c->proc;
801041b3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801041b9:	e8 c2 04 00 00       	call   80104680 <popcli>
  acquire(&ptable.lock);
801041be:	83 ec 0c             	sub    $0xc,%esp
801041c1:	68 60 38 11 80       	push   $0x80113860
801041c6:	e8 65 05 00 00       	call   80104730 <acquire>
801041cb:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801041ce:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041d0:	bb 94 38 11 80       	mov    $0x80113894,%ebx
801041d5:	eb 14                	jmp    801041eb <wait+0x4b>
801041d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041de:	66 90                	xchg   %ax,%ax
801041e0:	83 eb 80             	sub    $0xffffff80,%ebx
801041e3:	81 fb 94 58 11 80    	cmp    $0x80115894,%ebx
801041e9:	74 1b                	je     80104206 <wait+0x66>
      if(p->parent != curproc)
801041eb:	39 73 18             	cmp    %esi,0x18(%ebx)
801041ee:	75 f0                	jne    801041e0 <wait+0x40>
      if(p->state == ZOMBIE){
801041f0:	83 7b 10 05          	cmpl   $0x5,0x10(%ebx)
801041f4:	74 3a                	je     80104230 <wait+0x90>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041f6:	83 eb 80             	sub    $0xffffff80,%ebx
      havekids = 1;
801041f9:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041fe:	81 fb 94 58 11 80    	cmp    $0x80115894,%ebx
80104204:	75 e5                	jne    801041eb <wait+0x4b>
    if(!havekids || curproc->killed){
80104206:	85 c0                	test   %eax,%eax
80104208:	0f 84 84 00 00 00    	je     80104292 <wait+0xf2>
8010420e:	8b 46 28             	mov    0x28(%esi),%eax
80104211:	85 c0                	test   %eax,%eax
80104213:	75 7d                	jne    80104292 <wait+0xf2>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104215:	83 ec 08             	sub    $0x8,%esp
80104218:	68 60 38 11 80       	push   $0x80113860
8010421d:	56                   	push   %esi
8010421e:	e8 bd fe ff ff       	call   801040e0 <sleep>
    havekids = 0;
80104223:	83 c4 10             	add    $0x10,%esp
80104226:	eb a6                	jmp    801041ce <wait+0x2e>
80104228:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010422f:	90                   	nop
        pid = p->pid;
80104230:	8b 73 14             	mov    0x14(%ebx),%esi
        cprintf("hey: pid: %d\n", p->pid);
80104233:	83 ec 08             	sub    $0x8,%esp
80104236:	56                   	push   %esi
80104237:	68 0b 7e 10 80       	push   $0x80107e0b
8010423c:	e8 6f c4 ff ff       	call   801006b0 <cprintf>
        kfree(p->kstack);
80104241:	5a                   	pop    %edx
80104242:	ff 73 0c             	pushl  0xc(%ebx)
80104245:	e8 26 e2 ff ff       	call   80102470 <kfree>
        freevm(p->pgdir);
8010424a:	59                   	pop    %ecx
8010424b:	ff 73 08             	pushl  0x8(%ebx)
        p->kstack = 0;
8010424e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        freevm(p->pgdir);
80104255:	e8 66 2e 00 00       	call   801070c0 <freevm>
        release(&ptable.lock);
8010425a:	c7 04 24 60 38 11 80 	movl   $0x80113860,(%esp)
        p->pid = 0;
80104261:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->parent = 0;
80104268:	c7 43 18 00 00 00 00 	movl   $0x0,0x18(%ebx)
        p->name[0] = 0;
8010426f:	c6 43 70 00          	movb   $0x0,0x70(%ebx)
        p->killed = 0;
80104273:	c7 43 28 00 00 00 00 	movl   $0x0,0x28(%ebx)
        p->state = UNUSED;
8010427a:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        release(&ptable.lock);
80104281:	e8 6a 05 00 00       	call   801047f0 <release>
        return pid;
80104286:	83 c4 10             	add    $0x10,%esp
}
80104289:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010428c:	89 f0                	mov    %esi,%eax
8010428e:	5b                   	pop    %ebx
8010428f:	5e                   	pop    %esi
80104290:	5d                   	pop    %ebp
80104291:	c3                   	ret    
      release(&ptable.lock);
80104292:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104295:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010429a:	68 60 38 11 80       	push   $0x80113860
8010429f:	e8 4c 05 00 00       	call   801047f0 <release>
      return -1;
801042a4:	83 c4 10             	add    $0x10,%esp
801042a7:	eb e0                	jmp    80104289 <wait+0xe9>
801042a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801042b0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801042b0:	f3 0f 1e fb          	endbr32 
801042b4:	55                   	push   %ebp
801042b5:	89 e5                	mov    %esp,%ebp
801042b7:	53                   	push   %ebx
801042b8:	83 ec 10             	sub    $0x10,%esp
801042bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801042be:	68 60 38 11 80       	push   $0x80113860
801042c3:	e8 68 04 00 00       	call   80104730 <acquire>
801042c8:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042cb:	b8 94 38 11 80       	mov    $0x80113894,%eax
801042d0:	eb 10                	jmp    801042e2 <wakeup+0x32>
801042d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801042d8:	83 e8 80             	sub    $0xffffff80,%eax
801042db:	3d 94 58 11 80       	cmp    $0x80115894,%eax
801042e0:	74 1c                	je     801042fe <wakeup+0x4e>
    if(p->state == SLEEPING && p->chan == chan)
801042e2:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
801042e6:	75 f0                	jne    801042d8 <wakeup+0x28>
801042e8:	3b 58 24             	cmp    0x24(%eax),%ebx
801042eb:	75 eb                	jne    801042d8 <wakeup+0x28>
      p->state = RUNNABLE;
801042ed:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042f4:	83 e8 80             	sub    $0xffffff80,%eax
801042f7:	3d 94 58 11 80       	cmp    $0x80115894,%eax
801042fc:	75 e4                	jne    801042e2 <wakeup+0x32>
  wakeup1(chan);
  release(&ptable.lock);
801042fe:	c7 45 08 60 38 11 80 	movl   $0x80113860,0x8(%ebp)
}
80104305:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104308:	c9                   	leave  
  release(&ptable.lock);
80104309:	e9 e2 04 00 00       	jmp    801047f0 <release>
8010430e:	66 90                	xchg   %ax,%ax

80104310 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104310:	f3 0f 1e fb          	endbr32 
80104314:	55                   	push   %ebp
80104315:	89 e5                	mov    %esp,%ebp
80104317:	53                   	push   %ebx
80104318:	83 ec 10             	sub    $0x10,%esp
8010431b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010431e:	68 60 38 11 80       	push   $0x80113860
80104323:	e8 08 04 00 00       	call   80104730 <acquire>
80104328:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010432b:	b8 94 38 11 80       	mov    $0x80113894,%eax
80104330:	eb 10                	jmp    80104342 <kill+0x32>
80104332:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104338:	83 e8 80             	sub    $0xffffff80,%eax
8010433b:	3d 94 58 11 80       	cmp    $0x80115894,%eax
80104340:	74 36                	je     80104378 <kill+0x68>
    if(p->pid == pid){
80104342:	39 58 14             	cmp    %ebx,0x14(%eax)
80104345:	75 f1                	jne    80104338 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104347:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
      p->killed = 1;
8010434b:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
      if(p->state == SLEEPING)
80104352:	75 07                	jne    8010435b <kill+0x4b>
        p->state = RUNNABLE;
80104354:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
      release(&ptable.lock);
8010435b:	83 ec 0c             	sub    $0xc,%esp
8010435e:	68 60 38 11 80       	push   $0x80113860
80104363:	e8 88 04 00 00       	call   801047f0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104368:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
8010436b:	83 c4 10             	add    $0x10,%esp
8010436e:	31 c0                	xor    %eax,%eax
}
80104370:	c9                   	leave  
80104371:	c3                   	ret    
80104372:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104378:	83 ec 0c             	sub    $0xc,%esp
8010437b:	68 60 38 11 80       	push   $0x80113860
80104380:	e8 6b 04 00 00       	call   801047f0 <release>
}
80104385:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104388:	83 c4 10             	add    $0x10,%esp
8010438b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104390:	c9                   	leave  
80104391:	c3                   	ret    
80104392:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801043a0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801043a0:	f3 0f 1e fb          	endbr32 
801043a4:	55                   	push   %ebp
801043a5:	89 e5                	mov    %esp,%ebp
801043a7:	57                   	push   %edi
801043a8:	56                   	push   %esi
801043a9:	8d 75 e8             	lea    -0x18(%ebp),%esi
801043ac:	53                   	push   %ebx
801043ad:	bb 04 39 11 80       	mov    $0x80113904,%ebx
801043b2:	83 ec 3c             	sub    $0x3c,%esp
801043b5:	eb 28                	jmp    801043df <procdump+0x3f>
801043b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043be:	66 90                	xchg   %ax,%ax
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801043c0:	83 ec 0c             	sub    $0xc,%esp
801043c3:	68 bf 81 10 80       	push   $0x801081bf
801043c8:	e8 e3 c2 ff ff       	call   801006b0 <cprintf>
801043cd:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043d0:	83 eb 80             	sub    $0xffffff80,%ebx
801043d3:	81 fb 04 59 11 80    	cmp    $0x80115904,%ebx
801043d9:	0f 84 81 00 00 00    	je     80104460 <procdump+0xc0>
    if(p->state == UNUSED)
801043df:	8b 43 a0             	mov    -0x60(%ebx),%eax
801043e2:	85 c0                	test   %eax,%eax
801043e4:	74 ea                	je     801043d0 <procdump+0x30>
      state = "???";
801043e6:	ba 19 7e 10 80       	mov    $0x80107e19,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801043eb:	83 f8 05             	cmp    $0x5,%eax
801043ee:	77 11                	ja     80104401 <procdump+0x61>
801043f0:	8b 14 85 9c 7e 10 80 	mov    -0x7fef8164(,%eax,4),%edx
      state = "???";
801043f7:	b8 19 7e 10 80       	mov    $0x80107e19,%eax
801043fc:	85 d2                	test   %edx,%edx
801043fe:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104401:	53                   	push   %ebx
80104402:	52                   	push   %edx
80104403:	ff 73 a4             	pushl  -0x5c(%ebx)
80104406:	68 1d 7e 10 80       	push   $0x80107e1d
8010440b:	e8 a0 c2 ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
80104410:	83 c4 10             	add    $0x10,%esp
80104413:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104417:	75 a7                	jne    801043c0 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104419:	83 ec 08             	sub    $0x8,%esp
8010441c:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010441f:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104422:	50                   	push   %eax
80104423:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104426:	8b 40 0c             	mov    0xc(%eax),%eax
80104429:	83 c0 08             	add    $0x8,%eax
8010442c:	50                   	push   %eax
8010442d:	e8 9e 01 00 00       	call   801045d0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104432:	83 c4 10             	add    $0x10,%esp
80104435:	8d 76 00             	lea    0x0(%esi),%esi
80104438:	8b 17                	mov    (%edi),%edx
8010443a:	85 d2                	test   %edx,%edx
8010443c:	74 82                	je     801043c0 <procdump+0x20>
        cprintf(" %p", pc[i]);
8010443e:	83 ec 08             	sub    $0x8,%esp
80104441:	83 c7 04             	add    $0x4,%edi
80104444:	52                   	push   %edx
80104445:	68 81 77 10 80       	push   $0x80107781
8010444a:	e8 61 c2 ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
8010444f:	83 c4 10             	add    $0x10,%esp
80104452:	39 fe                	cmp    %edi,%esi
80104454:	75 e2                	jne    80104438 <procdump+0x98>
80104456:	e9 65 ff ff ff       	jmp    801043c0 <procdump+0x20>
8010445b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010445f:	90                   	nop
  }
}
80104460:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104463:	5b                   	pop    %ebx
80104464:	5e                   	pop    %esi
80104465:	5f                   	pop    %edi
80104466:	5d                   	pop    %ebp
80104467:	c3                   	ret    
80104468:	66 90                	xchg   %ax,%ax
8010446a:	66 90                	xchg   %ax,%ax
8010446c:	66 90                	xchg   %ax,%ax
8010446e:	66 90                	xchg   %ax,%ax

80104470 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104470:	f3 0f 1e fb          	endbr32 
80104474:	55                   	push   %ebp
80104475:	89 e5                	mov    %esp,%ebp
80104477:	53                   	push   %ebx
80104478:	83 ec 0c             	sub    $0xc,%esp
8010447b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010447e:	68 b4 7e 10 80       	push   $0x80107eb4
80104483:	8d 43 04             	lea    0x4(%ebx),%eax
80104486:	50                   	push   %eax
80104487:	e8 24 01 00 00       	call   801045b0 <initlock>
  lk->name = name;
8010448c:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010448f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104495:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104498:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010449f:	89 43 38             	mov    %eax,0x38(%ebx)
}
801044a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044a5:	c9                   	leave  
801044a6:	c3                   	ret    
801044a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044ae:	66 90                	xchg   %ax,%ax

801044b0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801044b0:	f3 0f 1e fb          	endbr32 
801044b4:	55                   	push   %ebp
801044b5:	89 e5                	mov    %esp,%ebp
801044b7:	56                   	push   %esi
801044b8:	53                   	push   %ebx
801044b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801044bc:	8d 73 04             	lea    0x4(%ebx),%esi
801044bf:	83 ec 0c             	sub    $0xc,%esp
801044c2:	56                   	push   %esi
801044c3:	e8 68 02 00 00       	call   80104730 <acquire>
  while (lk->locked) {
801044c8:	8b 13                	mov    (%ebx),%edx
801044ca:	83 c4 10             	add    $0x10,%esp
801044cd:	85 d2                	test   %edx,%edx
801044cf:	74 1a                	je     801044eb <acquiresleep+0x3b>
801044d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
801044d8:	83 ec 08             	sub    $0x8,%esp
801044db:	56                   	push   %esi
801044dc:	53                   	push   %ebx
801044dd:	e8 fe fb ff ff       	call   801040e0 <sleep>
  while (lk->locked) {
801044e2:	8b 03                	mov    (%ebx),%eax
801044e4:	83 c4 10             	add    $0x10,%esp
801044e7:	85 c0                	test   %eax,%eax
801044e9:	75 ed                	jne    801044d8 <acquiresleep+0x28>
  }
  lk->locked = 1;
801044eb:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801044f1:	e8 ba f4 ff ff       	call   801039b0 <myproc>
801044f6:	8b 40 14             	mov    0x14(%eax),%eax
801044f9:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801044fc:	89 75 08             	mov    %esi,0x8(%ebp)
}
801044ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104502:	5b                   	pop    %ebx
80104503:	5e                   	pop    %esi
80104504:	5d                   	pop    %ebp
  release(&lk->lk);
80104505:	e9 e6 02 00 00       	jmp    801047f0 <release>
8010450a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104510 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104510:	f3 0f 1e fb          	endbr32 
80104514:	55                   	push   %ebp
80104515:	89 e5                	mov    %esp,%ebp
80104517:	56                   	push   %esi
80104518:	53                   	push   %ebx
80104519:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010451c:	8d 73 04             	lea    0x4(%ebx),%esi
8010451f:	83 ec 0c             	sub    $0xc,%esp
80104522:	56                   	push   %esi
80104523:	e8 08 02 00 00       	call   80104730 <acquire>
  lk->locked = 0;
80104528:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010452e:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104535:	89 1c 24             	mov    %ebx,(%esp)
80104538:	e8 73 fd ff ff       	call   801042b0 <wakeup>
  release(&lk->lk);
8010453d:	89 75 08             	mov    %esi,0x8(%ebp)
80104540:	83 c4 10             	add    $0x10,%esp
}
80104543:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104546:	5b                   	pop    %ebx
80104547:	5e                   	pop    %esi
80104548:	5d                   	pop    %ebp
  release(&lk->lk);
80104549:	e9 a2 02 00 00       	jmp    801047f0 <release>
8010454e:	66 90                	xchg   %ax,%ax

80104550 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104550:	f3 0f 1e fb          	endbr32 
80104554:	55                   	push   %ebp
80104555:	89 e5                	mov    %esp,%ebp
80104557:	57                   	push   %edi
80104558:	31 ff                	xor    %edi,%edi
8010455a:	56                   	push   %esi
8010455b:	53                   	push   %ebx
8010455c:	83 ec 18             	sub    $0x18,%esp
8010455f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104562:	8d 73 04             	lea    0x4(%ebx),%esi
80104565:	56                   	push   %esi
80104566:	e8 c5 01 00 00       	call   80104730 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
8010456b:	8b 03                	mov    (%ebx),%eax
8010456d:	83 c4 10             	add    $0x10,%esp
80104570:	85 c0                	test   %eax,%eax
80104572:	75 1c                	jne    80104590 <holdingsleep+0x40>
  release(&lk->lk);
80104574:	83 ec 0c             	sub    $0xc,%esp
80104577:	56                   	push   %esi
80104578:	e8 73 02 00 00       	call   801047f0 <release>
  return r;
}
8010457d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104580:	89 f8                	mov    %edi,%eax
80104582:	5b                   	pop    %ebx
80104583:	5e                   	pop    %esi
80104584:	5f                   	pop    %edi
80104585:	5d                   	pop    %ebp
80104586:	c3                   	ret    
80104587:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010458e:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
80104590:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104593:	e8 18 f4 ff ff       	call   801039b0 <myproc>
80104598:	39 58 14             	cmp    %ebx,0x14(%eax)
8010459b:	0f 94 c0             	sete   %al
8010459e:	0f b6 c0             	movzbl %al,%eax
801045a1:	89 c7                	mov    %eax,%edi
801045a3:	eb cf                	jmp    80104574 <holdingsleep+0x24>
801045a5:	66 90                	xchg   %ax,%ax
801045a7:	66 90                	xchg   %ax,%ax
801045a9:	66 90                	xchg   %ax,%ax
801045ab:	66 90                	xchg   %ax,%ax
801045ad:	66 90                	xchg   %ax,%ax
801045af:	90                   	nop

801045b0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801045b0:	f3 0f 1e fb          	endbr32 
801045b4:	55                   	push   %ebp
801045b5:	89 e5                	mov    %esp,%ebp
801045b7:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801045ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801045bd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801045c3:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801045c6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801045cd:	5d                   	pop    %ebp
801045ce:	c3                   	ret    
801045cf:	90                   	nop

801045d0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801045d0:	f3 0f 1e fb          	endbr32 
801045d4:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801045d5:	31 d2                	xor    %edx,%edx
{
801045d7:	89 e5                	mov    %esp,%ebp
801045d9:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801045da:	8b 45 08             	mov    0x8(%ebp),%eax
{
801045dd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801045e0:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
801045e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045e7:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801045e8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801045ee:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801045f4:	77 1a                	ja     80104610 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
801045f6:	8b 58 04             	mov    0x4(%eax),%ebx
801045f9:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801045fc:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801045ff:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104601:	83 fa 0a             	cmp    $0xa,%edx
80104604:	75 e2                	jne    801045e8 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104606:	5b                   	pop    %ebx
80104607:	5d                   	pop    %ebp
80104608:	c3                   	ret    
80104609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104610:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104613:	8d 51 28             	lea    0x28(%ecx),%edx
80104616:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010461d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104620:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104626:	83 c0 04             	add    $0x4,%eax
80104629:	39 d0                	cmp    %edx,%eax
8010462b:	75 f3                	jne    80104620 <getcallerpcs+0x50>
}
8010462d:	5b                   	pop    %ebx
8010462e:	5d                   	pop    %ebp
8010462f:	c3                   	ret    

80104630 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104630:	f3 0f 1e fb          	endbr32 
80104634:	55                   	push   %ebp
80104635:	89 e5                	mov    %esp,%ebp
80104637:	53                   	push   %ebx
80104638:	83 ec 04             	sub    $0x4,%esp
8010463b:	9c                   	pushf  
8010463c:	5b                   	pop    %ebx
  asm volatile("cli");
8010463d:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010463e:	e8 ed f2 ff ff       	call   80103930 <mycpu>
80104643:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104649:	85 c0                	test   %eax,%eax
8010464b:	74 13                	je     80104660 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
8010464d:	e8 de f2 ff ff       	call   80103930 <mycpu>
80104652:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104659:	83 c4 04             	add    $0x4,%esp
8010465c:	5b                   	pop    %ebx
8010465d:	5d                   	pop    %ebp
8010465e:	c3                   	ret    
8010465f:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
80104660:	e8 cb f2 ff ff       	call   80103930 <mycpu>
80104665:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010466b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104671:	eb da                	jmp    8010464d <pushcli+0x1d>
80104673:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010467a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104680 <popcli>:

void
popcli(void)
{
80104680:	f3 0f 1e fb          	endbr32 
80104684:	55                   	push   %ebp
80104685:	89 e5                	mov    %esp,%ebp
80104687:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010468a:	9c                   	pushf  
8010468b:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010468c:	f6 c4 02             	test   $0x2,%ah
8010468f:	75 31                	jne    801046c2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104691:	e8 9a f2 ff ff       	call   80103930 <mycpu>
80104696:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
8010469d:	78 30                	js     801046cf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010469f:	e8 8c f2 ff ff       	call   80103930 <mycpu>
801046a4:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801046aa:	85 d2                	test   %edx,%edx
801046ac:	74 02                	je     801046b0 <popcli+0x30>
    sti();
}
801046ae:	c9                   	leave  
801046af:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
801046b0:	e8 7b f2 ff ff       	call   80103930 <mycpu>
801046b5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801046bb:	85 c0                	test   %eax,%eax
801046bd:	74 ef                	je     801046ae <popcli+0x2e>
  asm volatile("sti");
801046bf:	fb                   	sti    
}
801046c0:	c9                   	leave  
801046c1:	c3                   	ret    
    panic("popcli - interruptible");
801046c2:	83 ec 0c             	sub    $0xc,%esp
801046c5:	68 bf 7e 10 80       	push   $0x80107ebf
801046ca:	e8 c1 bc ff ff       	call   80100390 <panic>
    panic("popcli");
801046cf:	83 ec 0c             	sub    $0xc,%esp
801046d2:	68 d6 7e 10 80       	push   $0x80107ed6
801046d7:	e8 b4 bc ff ff       	call   80100390 <panic>
801046dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801046e0 <holding>:
{
801046e0:	f3 0f 1e fb          	endbr32 
801046e4:	55                   	push   %ebp
801046e5:	89 e5                	mov    %esp,%ebp
801046e7:	56                   	push   %esi
801046e8:	53                   	push   %ebx
801046e9:	8b 75 08             	mov    0x8(%ebp),%esi
801046ec:	31 db                	xor    %ebx,%ebx
  pushcli();
801046ee:	e8 3d ff ff ff       	call   80104630 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801046f3:	8b 06                	mov    (%esi),%eax
801046f5:	85 c0                	test   %eax,%eax
801046f7:	75 0f                	jne    80104708 <holding+0x28>
  popcli();
801046f9:	e8 82 ff ff ff       	call   80104680 <popcli>
}
801046fe:	89 d8                	mov    %ebx,%eax
80104700:	5b                   	pop    %ebx
80104701:	5e                   	pop    %esi
80104702:	5d                   	pop    %ebp
80104703:	c3                   	ret    
80104704:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80104708:	8b 5e 08             	mov    0x8(%esi),%ebx
8010470b:	e8 20 f2 ff ff       	call   80103930 <mycpu>
80104710:	39 c3                	cmp    %eax,%ebx
80104712:	0f 94 c3             	sete   %bl
  popcli();
80104715:	e8 66 ff ff ff       	call   80104680 <popcli>
  r = lock->locked && lock->cpu == mycpu();
8010471a:	0f b6 db             	movzbl %bl,%ebx
}
8010471d:	89 d8                	mov    %ebx,%eax
8010471f:	5b                   	pop    %ebx
80104720:	5e                   	pop    %esi
80104721:	5d                   	pop    %ebp
80104722:	c3                   	ret    
80104723:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010472a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104730 <acquire>:
{
80104730:	f3 0f 1e fb          	endbr32 
80104734:	55                   	push   %ebp
80104735:	89 e5                	mov    %esp,%ebp
80104737:	56                   	push   %esi
80104738:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104739:	e8 f2 fe ff ff       	call   80104630 <pushcli>
  if(holding(lk))
8010473e:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104741:	83 ec 0c             	sub    $0xc,%esp
80104744:	53                   	push   %ebx
80104745:	e8 96 ff ff ff       	call   801046e0 <holding>
8010474a:	83 c4 10             	add    $0x10,%esp
8010474d:	85 c0                	test   %eax,%eax
8010474f:	0f 85 7f 00 00 00    	jne    801047d4 <acquire+0xa4>
80104755:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104757:	ba 01 00 00 00       	mov    $0x1,%edx
8010475c:	eb 05                	jmp    80104763 <acquire+0x33>
8010475e:	66 90                	xchg   %ax,%ax
80104760:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104763:	89 d0                	mov    %edx,%eax
80104765:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104768:	85 c0                	test   %eax,%eax
8010476a:	75 f4                	jne    80104760 <acquire+0x30>
  __sync_synchronize();
8010476c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104771:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104774:	e8 b7 f1 ff ff       	call   80103930 <mycpu>
80104779:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
8010477c:	89 e8                	mov    %ebp,%eax
8010477e:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104780:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80104786:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
8010478c:	77 22                	ja     801047b0 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
8010478e:	8b 50 04             	mov    0x4(%eax),%edx
80104791:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
80104795:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104798:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
8010479a:	83 fe 0a             	cmp    $0xa,%esi
8010479d:	75 e1                	jne    80104780 <acquire+0x50>
}
8010479f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047a2:	5b                   	pop    %ebx
801047a3:	5e                   	pop    %esi
801047a4:	5d                   	pop    %ebp
801047a5:	c3                   	ret    
801047a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047ad:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
801047b0:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
801047b4:	83 c3 34             	add    $0x34,%ebx
801047b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047be:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801047c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801047c6:	83 c0 04             	add    $0x4,%eax
801047c9:	39 d8                	cmp    %ebx,%eax
801047cb:	75 f3                	jne    801047c0 <acquire+0x90>
}
801047cd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047d0:	5b                   	pop    %ebx
801047d1:	5e                   	pop    %esi
801047d2:	5d                   	pop    %ebp
801047d3:	c3                   	ret    
    panic("acquire");
801047d4:	83 ec 0c             	sub    $0xc,%esp
801047d7:	68 dd 7e 10 80       	push   $0x80107edd
801047dc:	e8 af bb ff ff       	call   80100390 <panic>
801047e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047ef:	90                   	nop

801047f0 <release>:
{
801047f0:	f3 0f 1e fb          	endbr32 
801047f4:	55                   	push   %ebp
801047f5:	89 e5                	mov    %esp,%ebp
801047f7:	53                   	push   %ebx
801047f8:	83 ec 10             	sub    $0x10,%esp
801047fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
801047fe:	53                   	push   %ebx
801047ff:	e8 dc fe ff ff       	call   801046e0 <holding>
80104804:	83 c4 10             	add    $0x10,%esp
80104807:	85 c0                	test   %eax,%eax
80104809:	74 22                	je     8010482d <release+0x3d>
  lk->pcs[0] = 0;
8010480b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104812:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104819:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010481e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104824:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104827:	c9                   	leave  
  popcli();
80104828:	e9 53 fe ff ff       	jmp    80104680 <popcli>
    panic("release");
8010482d:	83 ec 0c             	sub    $0xc,%esp
80104830:	68 e5 7e 10 80       	push   $0x80107ee5
80104835:	e8 56 bb ff ff       	call   80100390 <panic>
8010483a:	66 90                	xchg   %ax,%ax
8010483c:	66 90                	xchg   %ax,%ax
8010483e:	66 90                	xchg   %ax,%ax

80104840 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104840:	f3 0f 1e fb          	endbr32 
80104844:	55                   	push   %ebp
80104845:	89 e5                	mov    %esp,%ebp
80104847:	57                   	push   %edi
80104848:	8b 55 08             	mov    0x8(%ebp),%edx
8010484b:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010484e:	53                   	push   %ebx
8010484f:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80104852:	89 d7                	mov    %edx,%edi
80104854:	09 cf                	or     %ecx,%edi
80104856:	83 e7 03             	and    $0x3,%edi
80104859:	75 25                	jne    80104880 <memset+0x40>
    c &= 0xFF;
8010485b:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010485e:	c1 e0 18             	shl    $0x18,%eax
80104861:	89 fb                	mov    %edi,%ebx
80104863:	c1 e9 02             	shr    $0x2,%ecx
80104866:	c1 e3 10             	shl    $0x10,%ebx
80104869:	09 d8                	or     %ebx,%eax
8010486b:	09 f8                	or     %edi,%eax
8010486d:	c1 e7 08             	shl    $0x8,%edi
80104870:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104872:	89 d7                	mov    %edx,%edi
80104874:	fc                   	cld    
80104875:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104877:	5b                   	pop    %ebx
80104878:	89 d0                	mov    %edx,%eax
8010487a:	5f                   	pop    %edi
8010487b:	5d                   	pop    %ebp
8010487c:	c3                   	ret    
8010487d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
80104880:	89 d7                	mov    %edx,%edi
80104882:	fc                   	cld    
80104883:	f3 aa                	rep stos %al,%es:(%edi)
80104885:	5b                   	pop    %ebx
80104886:	89 d0                	mov    %edx,%eax
80104888:	5f                   	pop    %edi
80104889:	5d                   	pop    %ebp
8010488a:	c3                   	ret    
8010488b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010488f:	90                   	nop

80104890 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104890:	f3 0f 1e fb          	endbr32 
80104894:	55                   	push   %ebp
80104895:	89 e5                	mov    %esp,%ebp
80104897:	56                   	push   %esi
80104898:	8b 75 10             	mov    0x10(%ebp),%esi
8010489b:	8b 55 08             	mov    0x8(%ebp),%edx
8010489e:	53                   	push   %ebx
8010489f:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801048a2:	85 f6                	test   %esi,%esi
801048a4:	74 2a                	je     801048d0 <memcmp+0x40>
801048a6:	01 c6                	add    %eax,%esi
801048a8:	eb 10                	jmp    801048ba <memcmp+0x2a>
801048aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
801048b0:	83 c0 01             	add    $0x1,%eax
801048b3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
801048b6:	39 f0                	cmp    %esi,%eax
801048b8:	74 16                	je     801048d0 <memcmp+0x40>
    if(*s1 != *s2)
801048ba:	0f b6 0a             	movzbl (%edx),%ecx
801048bd:	0f b6 18             	movzbl (%eax),%ebx
801048c0:	38 d9                	cmp    %bl,%cl
801048c2:	74 ec                	je     801048b0 <memcmp+0x20>
      return *s1 - *s2;
801048c4:	0f b6 c1             	movzbl %cl,%eax
801048c7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
801048c9:	5b                   	pop    %ebx
801048ca:	5e                   	pop    %esi
801048cb:	5d                   	pop    %ebp
801048cc:	c3                   	ret    
801048cd:	8d 76 00             	lea    0x0(%esi),%esi
801048d0:	5b                   	pop    %ebx
  return 0;
801048d1:	31 c0                	xor    %eax,%eax
}
801048d3:	5e                   	pop    %esi
801048d4:	5d                   	pop    %ebp
801048d5:	c3                   	ret    
801048d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048dd:	8d 76 00             	lea    0x0(%esi),%esi

801048e0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801048e0:	f3 0f 1e fb          	endbr32 
801048e4:	55                   	push   %ebp
801048e5:	89 e5                	mov    %esp,%ebp
801048e7:	57                   	push   %edi
801048e8:	8b 55 08             	mov    0x8(%ebp),%edx
801048eb:	8b 4d 10             	mov    0x10(%ebp),%ecx
801048ee:	56                   	push   %esi
801048ef:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801048f2:	39 d6                	cmp    %edx,%esi
801048f4:	73 2a                	jae    80104920 <memmove+0x40>
801048f6:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
801048f9:	39 fa                	cmp    %edi,%edx
801048fb:	73 23                	jae    80104920 <memmove+0x40>
801048fd:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104900:	85 c9                	test   %ecx,%ecx
80104902:	74 13                	je     80104917 <memmove+0x37>
80104904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104908:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
8010490c:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
8010490f:	83 e8 01             	sub    $0x1,%eax
80104912:	83 f8 ff             	cmp    $0xffffffff,%eax
80104915:	75 f1                	jne    80104908 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104917:	5e                   	pop    %esi
80104918:	89 d0                	mov    %edx,%eax
8010491a:	5f                   	pop    %edi
8010491b:	5d                   	pop    %ebp
8010491c:	c3                   	ret    
8010491d:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80104920:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104923:	89 d7                	mov    %edx,%edi
80104925:	85 c9                	test   %ecx,%ecx
80104927:	74 ee                	je     80104917 <memmove+0x37>
80104929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104930:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104931:	39 f0                	cmp    %esi,%eax
80104933:	75 fb                	jne    80104930 <memmove+0x50>
}
80104935:	5e                   	pop    %esi
80104936:	89 d0                	mov    %edx,%eax
80104938:	5f                   	pop    %edi
80104939:	5d                   	pop    %ebp
8010493a:	c3                   	ret    
8010493b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010493f:	90                   	nop

80104940 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104940:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80104944:	eb 9a                	jmp    801048e0 <memmove>
80104946:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010494d:	8d 76 00             	lea    0x0(%esi),%esi

80104950 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104950:	f3 0f 1e fb          	endbr32 
80104954:	55                   	push   %ebp
80104955:	89 e5                	mov    %esp,%ebp
80104957:	56                   	push   %esi
80104958:	8b 75 10             	mov    0x10(%ebp),%esi
8010495b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010495e:	53                   	push   %ebx
8010495f:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80104962:	85 f6                	test   %esi,%esi
80104964:	74 32                	je     80104998 <strncmp+0x48>
80104966:	01 c6                	add    %eax,%esi
80104968:	eb 14                	jmp    8010497e <strncmp+0x2e>
8010496a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104970:	38 da                	cmp    %bl,%dl
80104972:	75 14                	jne    80104988 <strncmp+0x38>
    n--, p++, q++;
80104974:	83 c0 01             	add    $0x1,%eax
80104977:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010497a:	39 f0                	cmp    %esi,%eax
8010497c:	74 1a                	je     80104998 <strncmp+0x48>
8010497e:	0f b6 11             	movzbl (%ecx),%edx
80104981:	0f b6 18             	movzbl (%eax),%ebx
80104984:	84 d2                	test   %dl,%dl
80104986:	75 e8                	jne    80104970 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104988:	0f b6 c2             	movzbl %dl,%eax
8010498b:	29 d8                	sub    %ebx,%eax
}
8010498d:	5b                   	pop    %ebx
8010498e:	5e                   	pop    %esi
8010498f:	5d                   	pop    %ebp
80104990:	c3                   	ret    
80104991:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104998:	5b                   	pop    %ebx
    return 0;
80104999:	31 c0                	xor    %eax,%eax
}
8010499b:	5e                   	pop    %esi
8010499c:	5d                   	pop    %ebp
8010499d:	c3                   	ret    
8010499e:	66 90                	xchg   %ax,%ax

801049a0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801049a0:	f3 0f 1e fb          	endbr32 
801049a4:	55                   	push   %ebp
801049a5:	89 e5                	mov    %esp,%ebp
801049a7:	57                   	push   %edi
801049a8:	56                   	push   %esi
801049a9:	8b 75 08             	mov    0x8(%ebp),%esi
801049ac:	53                   	push   %ebx
801049ad:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801049b0:	89 f2                	mov    %esi,%edx
801049b2:	eb 1b                	jmp    801049cf <strncpy+0x2f>
801049b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049b8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
801049bc:	8b 7d 0c             	mov    0xc(%ebp),%edi
801049bf:	83 c2 01             	add    $0x1,%edx
801049c2:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
801049c6:	89 f9                	mov    %edi,%ecx
801049c8:	88 4a ff             	mov    %cl,-0x1(%edx)
801049cb:	84 c9                	test   %cl,%cl
801049cd:	74 09                	je     801049d8 <strncpy+0x38>
801049cf:	89 c3                	mov    %eax,%ebx
801049d1:	83 e8 01             	sub    $0x1,%eax
801049d4:	85 db                	test   %ebx,%ebx
801049d6:	7f e0                	jg     801049b8 <strncpy+0x18>
    ;
  while(n-- > 0)
801049d8:	89 d1                	mov    %edx,%ecx
801049da:	85 c0                	test   %eax,%eax
801049dc:	7e 15                	jle    801049f3 <strncpy+0x53>
801049de:	66 90                	xchg   %ax,%ax
    *s++ = 0;
801049e0:	83 c1 01             	add    $0x1,%ecx
801049e3:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
801049e7:	89 c8                	mov    %ecx,%eax
801049e9:	f7 d0                	not    %eax
801049eb:	01 d0                	add    %edx,%eax
801049ed:	01 d8                	add    %ebx,%eax
801049ef:	85 c0                	test   %eax,%eax
801049f1:	7f ed                	jg     801049e0 <strncpy+0x40>
  return os;
}
801049f3:	5b                   	pop    %ebx
801049f4:	89 f0                	mov    %esi,%eax
801049f6:	5e                   	pop    %esi
801049f7:	5f                   	pop    %edi
801049f8:	5d                   	pop    %ebp
801049f9:	c3                   	ret    
801049fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a00 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104a00:	f3 0f 1e fb          	endbr32 
80104a04:	55                   	push   %ebp
80104a05:	89 e5                	mov    %esp,%ebp
80104a07:	56                   	push   %esi
80104a08:	8b 55 10             	mov    0x10(%ebp),%edx
80104a0b:	8b 75 08             	mov    0x8(%ebp),%esi
80104a0e:	53                   	push   %ebx
80104a0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104a12:	85 d2                	test   %edx,%edx
80104a14:	7e 21                	jle    80104a37 <safestrcpy+0x37>
80104a16:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104a1a:	89 f2                	mov    %esi,%edx
80104a1c:	eb 12                	jmp    80104a30 <safestrcpy+0x30>
80104a1e:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104a20:	0f b6 08             	movzbl (%eax),%ecx
80104a23:	83 c0 01             	add    $0x1,%eax
80104a26:	83 c2 01             	add    $0x1,%edx
80104a29:	88 4a ff             	mov    %cl,-0x1(%edx)
80104a2c:	84 c9                	test   %cl,%cl
80104a2e:	74 04                	je     80104a34 <safestrcpy+0x34>
80104a30:	39 d8                	cmp    %ebx,%eax
80104a32:	75 ec                	jne    80104a20 <safestrcpy+0x20>
    ;
  *s = 0;
80104a34:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104a37:	89 f0                	mov    %esi,%eax
80104a39:	5b                   	pop    %ebx
80104a3a:	5e                   	pop    %esi
80104a3b:	5d                   	pop    %ebp
80104a3c:	c3                   	ret    
80104a3d:	8d 76 00             	lea    0x0(%esi),%esi

80104a40 <strlen>:

int
strlen(const char *s)
{
80104a40:	f3 0f 1e fb          	endbr32 
80104a44:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104a45:	31 c0                	xor    %eax,%eax
{
80104a47:	89 e5                	mov    %esp,%ebp
80104a49:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104a4c:	80 3a 00             	cmpb   $0x0,(%edx)
80104a4f:	74 10                	je     80104a61 <strlen+0x21>
80104a51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a58:	83 c0 01             	add    $0x1,%eax
80104a5b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104a5f:	75 f7                	jne    80104a58 <strlen+0x18>
    ;
  return n;
}
80104a61:	5d                   	pop    %ebp
80104a62:	c3                   	ret    

80104a63 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104a63:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104a67:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104a6b:	55                   	push   %ebp
  pushl %ebx
80104a6c:	53                   	push   %ebx
  pushl %esi
80104a6d:	56                   	push   %esi
  pushl %edi
80104a6e:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104a6f:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104a71:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104a73:	5f                   	pop    %edi
  popl %esi
80104a74:	5e                   	pop    %esi
  popl %ebx
80104a75:	5b                   	pop    %ebx
  popl %ebp
80104a76:	5d                   	pop    %ebp
  ret
80104a77:	c3                   	ret    
80104a78:	66 90                	xchg   %ax,%ax
80104a7a:	66 90                	xchg   %ax,%ax
80104a7c:	66 90                	xchg   %ax,%ax
80104a7e:	66 90                	xchg   %ax,%ax

80104a80 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104a80:	f3 0f 1e fb          	endbr32 
80104a84:	55                   	push   %ebp
80104a85:	89 e5                	mov    %esp,%ebp
80104a87:	53                   	push   %ebx
80104a88:	83 ec 04             	sub    $0x4,%esp
80104a8b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104a8e:	e8 1d ef ff ff       	call   801039b0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a93:	8b 00                	mov    (%eax),%eax
80104a95:	39 d8                	cmp    %ebx,%eax
80104a97:	76 17                	jbe    80104ab0 <fetchint+0x30>
80104a99:	8d 53 04             	lea    0x4(%ebx),%edx
80104a9c:	39 d0                	cmp    %edx,%eax
80104a9e:	72 10                	jb     80104ab0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104aa0:	8b 45 0c             	mov    0xc(%ebp),%eax
80104aa3:	8b 13                	mov    (%ebx),%edx
80104aa5:	89 10                	mov    %edx,(%eax)
  return 0;
80104aa7:	31 c0                	xor    %eax,%eax
}
80104aa9:	83 c4 04             	add    $0x4,%esp
80104aac:	5b                   	pop    %ebx
80104aad:	5d                   	pop    %ebp
80104aae:	c3                   	ret    
80104aaf:	90                   	nop
    return -1;
80104ab0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ab5:	eb f2                	jmp    80104aa9 <fetchint+0x29>
80104ab7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104abe:	66 90                	xchg   %ax,%ax

80104ac0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104ac0:	f3 0f 1e fb          	endbr32 
80104ac4:	55                   	push   %ebp
80104ac5:	89 e5                	mov    %esp,%ebp
80104ac7:	53                   	push   %ebx
80104ac8:	83 ec 04             	sub    $0x4,%esp
80104acb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104ace:	e8 dd ee ff ff       	call   801039b0 <myproc>

  if(addr >= curproc->sz)
80104ad3:	39 18                	cmp    %ebx,(%eax)
80104ad5:	76 31                	jbe    80104b08 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
80104ad7:	8b 55 0c             	mov    0xc(%ebp),%edx
80104ada:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104adc:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104ade:	39 d3                	cmp    %edx,%ebx
80104ae0:	73 26                	jae    80104b08 <fetchstr+0x48>
80104ae2:	89 d8                	mov    %ebx,%eax
80104ae4:	eb 11                	jmp    80104af7 <fetchstr+0x37>
80104ae6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104aed:	8d 76 00             	lea    0x0(%esi),%esi
80104af0:	83 c0 01             	add    $0x1,%eax
80104af3:	39 c2                	cmp    %eax,%edx
80104af5:	76 11                	jbe    80104b08 <fetchstr+0x48>
    if(*s == 0)
80104af7:	80 38 00             	cmpb   $0x0,(%eax)
80104afa:	75 f4                	jne    80104af0 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
80104afc:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
80104aff:	29 d8                	sub    %ebx,%eax
}
80104b01:	5b                   	pop    %ebx
80104b02:	5d                   	pop    %ebp
80104b03:	c3                   	ret    
80104b04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b08:	83 c4 04             	add    $0x4,%esp
    return -1;
80104b0b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b10:	5b                   	pop    %ebx
80104b11:	5d                   	pop    %ebp
80104b12:	c3                   	ret    
80104b13:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b20 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104b20:	f3 0f 1e fb          	endbr32 
80104b24:	55                   	push   %ebp
80104b25:	89 e5                	mov    %esp,%ebp
80104b27:	56                   	push   %esi
80104b28:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b29:	e8 82 ee ff ff       	call   801039b0 <myproc>
80104b2e:	8b 55 08             	mov    0x8(%ebp),%edx
80104b31:	8b 40 1c             	mov    0x1c(%eax),%eax
80104b34:	8b 40 44             	mov    0x44(%eax),%eax
80104b37:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104b3a:	e8 71 ee ff ff       	call   801039b0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b3f:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b42:	8b 00                	mov    (%eax),%eax
80104b44:	39 c6                	cmp    %eax,%esi
80104b46:	73 18                	jae    80104b60 <argint+0x40>
80104b48:	8d 53 08             	lea    0x8(%ebx),%edx
80104b4b:	39 d0                	cmp    %edx,%eax
80104b4d:	72 11                	jb     80104b60 <argint+0x40>
  *ip = *(int*)(addr);
80104b4f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b52:	8b 53 04             	mov    0x4(%ebx),%edx
80104b55:	89 10                	mov    %edx,(%eax)
  return 0;
80104b57:	31 c0                	xor    %eax,%eax
}
80104b59:	5b                   	pop    %ebx
80104b5a:	5e                   	pop    %esi
80104b5b:	5d                   	pop    %ebp
80104b5c:	c3                   	ret    
80104b5d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104b60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b65:	eb f2                	jmp    80104b59 <argint+0x39>
80104b67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b6e:	66 90                	xchg   %ax,%ax

80104b70 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104b70:	f3 0f 1e fb          	endbr32 
80104b74:	55                   	push   %ebp
80104b75:	89 e5                	mov    %esp,%ebp
80104b77:	56                   	push   %esi
80104b78:	53                   	push   %ebx
80104b79:	83 ec 10             	sub    $0x10,%esp
80104b7c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104b7f:	e8 2c ee ff ff       	call   801039b0 <myproc>
 
  if(argint(n, &i) < 0)
80104b84:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80104b87:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
80104b89:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b8c:	50                   	push   %eax
80104b8d:	ff 75 08             	pushl  0x8(%ebp)
80104b90:	e8 8b ff ff ff       	call   80104b20 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104b95:	83 c4 10             	add    $0x10,%esp
80104b98:	85 c0                	test   %eax,%eax
80104b9a:	78 24                	js     80104bc0 <argptr+0x50>
80104b9c:	85 db                	test   %ebx,%ebx
80104b9e:	78 20                	js     80104bc0 <argptr+0x50>
80104ba0:	8b 16                	mov    (%esi),%edx
80104ba2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ba5:	39 c2                	cmp    %eax,%edx
80104ba7:	76 17                	jbe    80104bc0 <argptr+0x50>
80104ba9:	01 c3                	add    %eax,%ebx
80104bab:	39 da                	cmp    %ebx,%edx
80104bad:	72 11                	jb     80104bc0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104baf:	8b 55 0c             	mov    0xc(%ebp),%edx
80104bb2:	89 02                	mov    %eax,(%edx)
  return 0;
80104bb4:	31 c0                	xor    %eax,%eax
}
80104bb6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104bb9:	5b                   	pop    %ebx
80104bba:	5e                   	pop    %esi
80104bbb:	5d                   	pop    %ebp
80104bbc:	c3                   	ret    
80104bbd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104bc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104bc5:	eb ef                	jmp    80104bb6 <argptr+0x46>
80104bc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bce:	66 90                	xchg   %ax,%ax

80104bd0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104bd0:	f3 0f 1e fb          	endbr32 
80104bd4:	55                   	push   %ebp
80104bd5:	89 e5                	mov    %esp,%ebp
80104bd7:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104bda:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104bdd:	50                   	push   %eax
80104bde:	ff 75 08             	pushl  0x8(%ebp)
80104be1:	e8 3a ff ff ff       	call   80104b20 <argint>
80104be6:	83 c4 10             	add    $0x10,%esp
80104be9:	85 c0                	test   %eax,%eax
80104beb:	78 13                	js     80104c00 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104bed:	83 ec 08             	sub    $0x8,%esp
80104bf0:	ff 75 0c             	pushl  0xc(%ebp)
80104bf3:	ff 75 f4             	pushl  -0xc(%ebp)
80104bf6:	e8 c5 fe ff ff       	call   80104ac0 <fetchstr>
80104bfb:	83 c4 10             	add    $0x10,%esp
}
80104bfe:	c9                   	leave  
80104bff:	c3                   	ret    
80104c00:	c9                   	leave  
    return -1;
80104c01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c06:	c3                   	ret    
80104c07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c0e:	66 90                	xchg   %ax,%ax

80104c10 <syscall>:
[SYS_getNumFreePages]   sys_getNumFreePages,
};

void
syscall(void)
{
80104c10:	f3 0f 1e fb          	endbr32 
80104c14:	55                   	push   %ebp
80104c15:	89 e5                	mov    %esp,%ebp
80104c17:	53                   	push   %ebx
80104c18:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104c1b:	e8 90 ed ff ff       	call   801039b0 <myproc>
80104c20:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104c22:	8b 40 1c             	mov    0x1c(%eax),%eax
80104c25:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104c28:	8d 50 ff             	lea    -0x1(%eax),%edx
80104c2b:	83 fa 16             	cmp    $0x16,%edx
80104c2e:	77 20                	ja     80104c50 <syscall+0x40>
80104c30:	8b 14 85 20 7f 10 80 	mov    -0x7fef80e0(,%eax,4),%edx
80104c37:	85 d2                	test   %edx,%edx
80104c39:	74 15                	je     80104c50 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104c3b:	ff d2                	call   *%edx
80104c3d:	89 c2                	mov    %eax,%edx
80104c3f:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104c42:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104c45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c48:	c9                   	leave  
80104c49:	c3                   	ret    
80104c4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104c50:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104c51:	8d 43 70             	lea    0x70(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104c54:	50                   	push   %eax
80104c55:	ff 73 14             	pushl  0x14(%ebx)
80104c58:	68 ed 7e 10 80       	push   $0x80107eed
80104c5d:	e8 4e ba ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80104c62:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104c65:	83 c4 10             	add    $0x10,%esp
80104c68:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104c6f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c72:	c9                   	leave  
80104c73:	c3                   	ret    
80104c74:	66 90                	xchg   %ax,%ax
80104c76:	66 90                	xchg   %ax,%ax
80104c78:	66 90                	xchg   %ax,%ax
80104c7a:	66 90                	xchg   %ax,%ax
80104c7c:	66 90                	xchg   %ax,%ax
80104c7e:	66 90                	xchg   %ax,%ax

80104c80 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104c80:	55                   	push   %ebp
80104c81:	89 e5                	mov    %esp,%ebp
80104c83:	57                   	push   %edi
80104c84:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104c85:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104c88:	53                   	push   %ebx
80104c89:	83 ec 34             	sub    $0x34,%esp
80104c8c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104c8f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104c92:	57                   	push   %edi
80104c93:	50                   	push   %eax
{
80104c94:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104c97:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104c9a:	e8 b1 d3 ff ff       	call   80102050 <nameiparent>
80104c9f:	83 c4 10             	add    $0x10,%esp
80104ca2:	85 c0                	test   %eax,%eax
80104ca4:	0f 84 46 01 00 00    	je     80104df0 <create+0x170>
    return 0;
  ilock(dp);
80104caa:	83 ec 0c             	sub    $0xc,%esp
80104cad:	89 c3                	mov    %eax,%ebx
80104caf:	50                   	push   %eax
80104cb0:	e8 ab ca ff ff       	call   80101760 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104cb5:	83 c4 0c             	add    $0xc,%esp
80104cb8:	6a 00                	push   $0x0
80104cba:	57                   	push   %edi
80104cbb:	53                   	push   %ebx
80104cbc:	e8 ef cf ff ff       	call   80101cb0 <dirlookup>
80104cc1:	83 c4 10             	add    $0x10,%esp
80104cc4:	89 c6                	mov    %eax,%esi
80104cc6:	85 c0                	test   %eax,%eax
80104cc8:	74 56                	je     80104d20 <create+0xa0>
    iunlockput(dp);
80104cca:	83 ec 0c             	sub    $0xc,%esp
80104ccd:	53                   	push   %ebx
80104cce:	e8 2d cd ff ff       	call   80101a00 <iunlockput>
    ilock(ip);
80104cd3:	89 34 24             	mov    %esi,(%esp)
80104cd6:	e8 85 ca ff ff       	call   80101760 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104cdb:	83 c4 10             	add    $0x10,%esp
80104cde:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104ce3:	75 1b                	jne    80104d00 <create+0x80>
80104ce5:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104cea:	75 14                	jne    80104d00 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104cec:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104cef:	89 f0                	mov    %esi,%eax
80104cf1:	5b                   	pop    %ebx
80104cf2:	5e                   	pop    %esi
80104cf3:	5f                   	pop    %edi
80104cf4:	5d                   	pop    %ebp
80104cf5:	c3                   	ret    
80104cf6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cfd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80104d00:	83 ec 0c             	sub    $0xc,%esp
80104d03:	56                   	push   %esi
    return 0;
80104d04:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104d06:	e8 f5 cc ff ff       	call   80101a00 <iunlockput>
    return 0;
80104d0b:	83 c4 10             	add    $0x10,%esp
}
80104d0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d11:	89 f0                	mov    %esi,%eax
80104d13:	5b                   	pop    %ebx
80104d14:	5e                   	pop    %esi
80104d15:	5f                   	pop    %edi
80104d16:	5d                   	pop    %ebp
80104d17:	c3                   	ret    
80104d18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d1f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104d20:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104d24:	83 ec 08             	sub    $0x8,%esp
80104d27:	50                   	push   %eax
80104d28:	ff 33                	pushl  (%ebx)
80104d2a:	e8 b1 c8 ff ff       	call   801015e0 <ialloc>
80104d2f:	83 c4 10             	add    $0x10,%esp
80104d32:	89 c6                	mov    %eax,%esi
80104d34:	85 c0                	test   %eax,%eax
80104d36:	0f 84 cd 00 00 00    	je     80104e09 <create+0x189>
  ilock(ip);
80104d3c:	83 ec 0c             	sub    $0xc,%esp
80104d3f:	50                   	push   %eax
80104d40:	e8 1b ca ff ff       	call   80101760 <ilock>
  ip->major = major;
80104d45:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104d49:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104d4d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104d51:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104d55:	b8 01 00 00 00       	mov    $0x1,%eax
80104d5a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104d5e:	89 34 24             	mov    %esi,(%esp)
80104d61:	e8 3a c9 ff ff       	call   801016a0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104d66:	83 c4 10             	add    $0x10,%esp
80104d69:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104d6e:	74 30                	je     80104da0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104d70:	83 ec 04             	sub    $0x4,%esp
80104d73:	ff 76 04             	pushl  0x4(%esi)
80104d76:	57                   	push   %edi
80104d77:	53                   	push   %ebx
80104d78:	e8 f3 d1 ff ff       	call   80101f70 <dirlink>
80104d7d:	83 c4 10             	add    $0x10,%esp
80104d80:	85 c0                	test   %eax,%eax
80104d82:	78 78                	js     80104dfc <create+0x17c>
  iunlockput(dp);
80104d84:	83 ec 0c             	sub    $0xc,%esp
80104d87:	53                   	push   %ebx
80104d88:	e8 73 cc ff ff       	call   80101a00 <iunlockput>
  return ip;
80104d8d:	83 c4 10             	add    $0x10,%esp
}
80104d90:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d93:	89 f0                	mov    %esi,%eax
80104d95:	5b                   	pop    %ebx
80104d96:	5e                   	pop    %esi
80104d97:	5f                   	pop    %edi
80104d98:	5d                   	pop    %ebp
80104d99:	c3                   	ret    
80104d9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104da0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104da3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104da8:	53                   	push   %ebx
80104da9:	e8 f2 c8 ff ff       	call   801016a0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104dae:	83 c4 0c             	add    $0xc,%esp
80104db1:	ff 76 04             	pushl  0x4(%esi)
80104db4:	68 9c 7f 10 80       	push   $0x80107f9c
80104db9:	56                   	push   %esi
80104dba:	e8 b1 d1 ff ff       	call   80101f70 <dirlink>
80104dbf:	83 c4 10             	add    $0x10,%esp
80104dc2:	85 c0                	test   %eax,%eax
80104dc4:	78 18                	js     80104dde <create+0x15e>
80104dc6:	83 ec 04             	sub    $0x4,%esp
80104dc9:	ff 73 04             	pushl  0x4(%ebx)
80104dcc:	68 9b 7f 10 80       	push   $0x80107f9b
80104dd1:	56                   	push   %esi
80104dd2:	e8 99 d1 ff ff       	call   80101f70 <dirlink>
80104dd7:	83 c4 10             	add    $0x10,%esp
80104dda:	85 c0                	test   %eax,%eax
80104ddc:	79 92                	jns    80104d70 <create+0xf0>
      panic("create dots");
80104dde:	83 ec 0c             	sub    $0xc,%esp
80104de1:	68 8f 7f 10 80       	push   $0x80107f8f
80104de6:	e8 a5 b5 ff ff       	call   80100390 <panic>
80104deb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104def:	90                   	nop
}
80104df0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104df3:	31 f6                	xor    %esi,%esi
}
80104df5:	5b                   	pop    %ebx
80104df6:	89 f0                	mov    %esi,%eax
80104df8:	5e                   	pop    %esi
80104df9:	5f                   	pop    %edi
80104dfa:	5d                   	pop    %ebp
80104dfb:	c3                   	ret    
    panic("create: dirlink");
80104dfc:	83 ec 0c             	sub    $0xc,%esp
80104dff:	68 9e 7f 10 80       	push   $0x80107f9e
80104e04:	e8 87 b5 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80104e09:	83 ec 0c             	sub    $0xc,%esp
80104e0c:	68 80 7f 10 80       	push   $0x80107f80
80104e11:	e8 7a b5 ff ff       	call   80100390 <panic>
80104e16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e1d:	8d 76 00             	lea    0x0(%esi),%esi

80104e20 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104e20:	55                   	push   %ebp
80104e21:	89 e5                	mov    %esp,%ebp
80104e23:	56                   	push   %esi
80104e24:	89 d6                	mov    %edx,%esi
80104e26:	53                   	push   %ebx
80104e27:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104e29:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104e2c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104e2f:	50                   	push   %eax
80104e30:	6a 00                	push   $0x0
80104e32:	e8 e9 fc ff ff       	call   80104b20 <argint>
80104e37:	83 c4 10             	add    $0x10,%esp
80104e3a:	85 c0                	test   %eax,%eax
80104e3c:	78 2a                	js     80104e68 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104e3e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104e42:	77 24                	ja     80104e68 <argfd.constprop.0+0x48>
80104e44:	e8 67 eb ff ff       	call   801039b0 <myproc>
80104e49:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e4c:	8b 44 90 2c          	mov    0x2c(%eax,%edx,4),%eax
80104e50:	85 c0                	test   %eax,%eax
80104e52:	74 14                	je     80104e68 <argfd.constprop.0+0x48>
  if(pfd)
80104e54:	85 db                	test   %ebx,%ebx
80104e56:	74 02                	je     80104e5a <argfd.constprop.0+0x3a>
    *pfd = fd;
80104e58:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80104e5a:	89 06                	mov    %eax,(%esi)
  return 0;
80104e5c:	31 c0                	xor    %eax,%eax
}
80104e5e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e61:	5b                   	pop    %ebx
80104e62:	5e                   	pop    %esi
80104e63:	5d                   	pop    %ebp
80104e64:	c3                   	ret    
80104e65:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104e68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e6d:	eb ef                	jmp    80104e5e <argfd.constprop.0+0x3e>
80104e6f:	90                   	nop

80104e70 <sys_dup>:
{
80104e70:	f3 0f 1e fb          	endbr32 
80104e74:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104e75:	31 c0                	xor    %eax,%eax
{
80104e77:	89 e5                	mov    %esp,%ebp
80104e79:	56                   	push   %esi
80104e7a:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104e7b:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104e7e:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104e81:	e8 9a ff ff ff       	call   80104e20 <argfd.constprop.0>
80104e86:	85 c0                	test   %eax,%eax
80104e88:	78 1e                	js     80104ea8 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
80104e8a:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104e8d:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104e8f:	e8 1c eb ff ff       	call   801039b0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104e94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80104e98:	8b 54 98 2c          	mov    0x2c(%eax,%ebx,4),%edx
80104e9c:	85 d2                	test   %edx,%edx
80104e9e:	74 20                	je     80104ec0 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
80104ea0:	83 c3 01             	add    $0x1,%ebx
80104ea3:	83 fb 10             	cmp    $0x10,%ebx
80104ea6:	75 f0                	jne    80104e98 <sys_dup+0x28>
}
80104ea8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104eab:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104eb0:	89 d8                	mov    %ebx,%eax
80104eb2:	5b                   	pop    %ebx
80104eb3:	5e                   	pop    %esi
80104eb4:	5d                   	pop    %ebp
80104eb5:	c3                   	ret    
80104eb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ebd:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80104ec0:	89 74 98 2c          	mov    %esi,0x2c(%eax,%ebx,4)
  filedup(f);
80104ec4:	83 ec 0c             	sub    $0xc,%esp
80104ec7:	ff 75 f4             	pushl  -0xc(%ebp)
80104eca:	e8 a1 bf ff ff       	call   80100e70 <filedup>
  return fd;
80104ecf:	83 c4 10             	add    $0x10,%esp
}
80104ed2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ed5:	89 d8                	mov    %ebx,%eax
80104ed7:	5b                   	pop    %ebx
80104ed8:	5e                   	pop    %esi
80104ed9:	5d                   	pop    %ebp
80104eda:	c3                   	ret    
80104edb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104edf:	90                   	nop

80104ee0 <sys_read>:
{
80104ee0:	f3 0f 1e fb          	endbr32 
80104ee4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ee5:	31 c0                	xor    %eax,%eax
{
80104ee7:	89 e5                	mov    %esp,%ebp
80104ee9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104eec:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104eef:	e8 2c ff ff ff       	call   80104e20 <argfd.constprop.0>
80104ef4:	85 c0                	test   %eax,%eax
80104ef6:	78 48                	js     80104f40 <sys_read+0x60>
80104ef8:	83 ec 08             	sub    $0x8,%esp
80104efb:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104efe:	50                   	push   %eax
80104eff:	6a 02                	push   $0x2
80104f01:	e8 1a fc ff ff       	call   80104b20 <argint>
80104f06:	83 c4 10             	add    $0x10,%esp
80104f09:	85 c0                	test   %eax,%eax
80104f0b:	78 33                	js     80104f40 <sys_read+0x60>
80104f0d:	83 ec 04             	sub    $0x4,%esp
80104f10:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f13:	ff 75 f0             	pushl  -0x10(%ebp)
80104f16:	50                   	push   %eax
80104f17:	6a 01                	push   $0x1
80104f19:	e8 52 fc ff ff       	call   80104b70 <argptr>
80104f1e:	83 c4 10             	add    $0x10,%esp
80104f21:	85 c0                	test   %eax,%eax
80104f23:	78 1b                	js     80104f40 <sys_read+0x60>
  return fileread(f, p, n);
80104f25:	83 ec 04             	sub    $0x4,%esp
80104f28:	ff 75 f0             	pushl  -0x10(%ebp)
80104f2b:	ff 75 f4             	pushl  -0xc(%ebp)
80104f2e:	ff 75 ec             	pushl  -0x14(%ebp)
80104f31:	e8 ba c0 ff ff       	call   80100ff0 <fileread>
80104f36:	83 c4 10             	add    $0x10,%esp
}
80104f39:	c9                   	leave  
80104f3a:	c3                   	ret    
80104f3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f3f:	90                   	nop
80104f40:	c9                   	leave  
    return -1;
80104f41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f46:	c3                   	ret    
80104f47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f4e:	66 90                	xchg   %ax,%ax

80104f50 <sys_write>:
{
80104f50:	f3 0f 1e fb          	endbr32 
80104f54:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104f55:	31 c0                	xor    %eax,%eax
{
80104f57:	89 e5                	mov    %esp,%ebp
80104f59:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104f5c:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104f5f:	e8 bc fe ff ff       	call   80104e20 <argfd.constprop.0>
80104f64:	85 c0                	test   %eax,%eax
80104f66:	78 48                	js     80104fb0 <sys_write+0x60>
80104f68:	83 ec 08             	sub    $0x8,%esp
80104f6b:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f6e:	50                   	push   %eax
80104f6f:	6a 02                	push   $0x2
80104f71:	e8 aa fb ff ff       	call   80104b20 <argint>
80104f76:	83 c4 10             	add    $0x10,%esp
80104f79:	85 c0                	test   %eax,%eax
80104f7b:	78 33                	js     80104fb0 <sys_write+0x60>
80104f7d:	83 ec 04             	sub    $0x4,%esp
80104f80:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f83:	ff 75 f0             	pushl  -0x10(%ebp)
80104f86:	50                   	push   %eax
80104f87:	6a 01                	push   $0x1
80104f89:	e8 e2 fb ff ff       	call   80104b70 <argptr>
80104f8e:	83 c4 10             	add    $0x10,%esp
80104f91:	85 c0                	test   %eax,%eax
80104f93:	78 1b                	js     80104fb0 <sys_write+0x60>
  return filewrite(f, p, n);
80104f95:	83 ec 04             	sub    $0x4,%esp
80104f98:	ff 75 f0             	pushl  -0x10(%ebp)
80104f9b:	ff 75 f4             	pushl  -0xc(%ebp)
80104f9e:	ff 75 ec             	pushl  -0x14(%ebp)
80104fa1:	e8 ea c0 ff ff       	call   80101090 <filewrite>
80104fa6:	83 c4 10             	add    $0x10,%esp
}
80104fa9:	c9                   	leave  
80104faa:	c3                   	ret    
80104fab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104faf:	90                   	nop
80104fb0:	c9                   	leave  
    return -1;
80104fb1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104fb6:	c3                   	ret    
80104fb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fbe:	66 90                	xchg   %ax,%ax

80104fc0 <sys_close>:
{
80104fc0:	f3 0f 1e fb          	endbr32 
80104fc4:	55                   	push   %ebp
80104fc5:	89 e5                	mov    %esp,%ebp
80104fc7:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80104fca:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104fcd:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104fd0:	e8 4b fe ff ff       	call   80104e20 <argfd.constprop.0>
80104fd5:	85 c0                	test   %eax,%eax
80104fd7:	78 27                	js     80105000 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80104fd9:	e8 d2 e9 ff ff       	call   801039b0 <myproc>
80104fde:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104fe1:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104fe4:	c7 44 90 2c 00 00 00 	movl   $0x0,0x2c(%eax,%edx,4)
80104feb:	00 
  fileclose(f);
80104fec:	ff 75 f4             	pushl  -0xc(%ebp)
80104fef:	e8 cc be ff ff       	call   80100ec0 <fileclose>
  return 0;
80104ff4:	83 c4 10             	add    $0x10,%esp
80104ff7:	31 c0                	xor    %eax,%eax
}
80104ff9:	c9                   	leave  
80104ffa:	c3                   	ret    
80104ffb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104fff:	90                   	nop
80105000:	c9                   	leave  
    return -1;
80105001:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105006:	c3                   	ret    
80105007:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010500e:	66 90                	xchg   %ax,%ax

80105010 <sys_fstat>:
{
80105010:	f3 0f 1e fb          	endbr32 
80105014:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105015:	31 c0                	xor    %eax,%eax
{
80105017:	89 e5                	mov    %esp,%ebp
80105019:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
8010501c:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010501f:	e8 fc fd ff ff       	call   80104e20 <argfd.constprop.0>
80105024:	85 c0                	test   %eax,%eax
80105026:	78 30                	js     80105058 <sys_fstat+0x48>
80105028:	83 ec 04             	sub    $0x4,%esp
8010502b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010502e:	6a 14                	push   $0x14
80105030:	50                   	push   %eax
80105031:	6a 01                	push   $0x1
80105033:	e8 38 fb ff ff       	call   80104b70 <argptr>
80105038:	83 c4 10             	add    $0x10,%esp
8010503b:	85 c0                	test   %eax,%eax
8010503d:	78 19                	js     80105058 <sys_fstat+0x48>
  return filestat(f, st);
8010503f:	83 ec 08             	sub    $0x8,%esp
80105042:	ff 75 f4             	pushl  -0xc(%ebp)
80105045:	ff 75 f0             	pushl  -0x10(%ebp)
80105048:	e8 53 bf ff ff       	call   80100fa0 <filestat>
8010504d:	83 c4 10             	add    $0x10,%esp
}
80105050:	c9                   	leave  
80105051:	c3                   	ret    
80105052:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105058:	c9                   	leave  
    return -1;
80105059:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010505e:	c3                   	ret    
8010505f:	90                   	nop

80105060 <sys_link>:
{
80105060:	f3 0f 1e fb          	endbr32 
80105064:	55                   	push   %ebp
80105065:	89 e5                	mov    %esp,%ebp
80105067:	57                   	push   %edi
80105068:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105069:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
8010506c:	53                   	push   %ebx
8010506d:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105070:	50                   	push   %eax
80105071:	6a 00                	push   $0x0
80105073:	e8 58 fb ff ff       	call   80104bd0 <argstr>
80105078:	83 c4 10             	add    $0x10,%esp
8010507b:	85 c0                	test   %eax,%eax
8010507d:	0f 88 ff 00 00 00    	js     80105182 <sys_link+0x122>
80105083:	83 ec 08             	sub    $0x8,%esp
80105086:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105089:	50                   	push   %eax
8010508a:	6a 01                	push   $0x1
8010508c:	e8 3f fb ff ff       	call   80104bd0 <argstr>
80105091:	83 c4 10             	add    $0x10,%esp
80105094:	85 c0                	test   %eax,%eax
80105096:	0f 88 e6 00 00 00    	js     80105182 <sys_link+0x122>
  begin_op();
8010509c:	e8 ef dc ff ff       	call   80102d90 <begin_op>
  if((ip = namei(old)) == 0){
801050a1:	83 ec 0c             	sub    $0xc,%esp
801050a4:	ff 75 d4             	pushl  -0x2c(%ebp)
801050a7:	e8 84 cf ff ff       	call   80102030 <namei>
801050ac:	83 c4 10             	add    $0x10,%esp
801050af:	89 c3                	mov    %eax,%ebx
801050b1:	85 c0                	test   %eax,%eax
801050b3:	0f 84 e8 00 00 00    	je     801051a1 <sys_link+0x141>
  ilock(ip);
801050b9:	83 ec 0c             	sub    $0xc,%esp
801050bc:	50                   	push   %eax
801050bd:	e8 9e c6 ff ff       	call   80101760 <ilock>
  if(ip->type == T_DIR){
801050c2:	83 c4 10             	add    $0x10,%esp
801050c5:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801050ca:	0f 84 b9 00 00 00    	je     80105189 <sys_link+0x129>
  iupdate(ip);
801050d0:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
801050d3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
801050d8:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801050db:	53                   	push   %ebx
801050dc:	e8 bf c5 ff ff       	call   801016a0 <iupdate>
  iunlock(ip);
801050e1:	89 1c 24             	mov    %ebx,(%esp)
801050e4:	e8 57 c7 ff ff       	call   80101840 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801050e9:	58                   	pop    %eax
801050ea:	5a                   	pop    %edx
801050eb:	57                   	push   %edi
801050ec:	ff 75 d0             	pushl  -0x30(%ebp)
801050ef:	e8 5c cf ff ff       	call   80102050 <nameiparent>
801050f4:	83 c4 10             	add    $0x10,%esp
801050f7:	89 c6                	mov    %eax,%esi
801050f9:	85 c0                	test   %eax,%eax
801050fb:	74 5f                	je     8010515c <sys_link+0xfc>
  ilock(dp);
801050fd:	83 ec 0c             	sub    $0xc,%esp
80105100:	50                   	push   %eax
80105101:	e8 5a c6 ff ff       	call   80101760 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105106:	8b 03                	mov    (%ebx),%eax
80105108:	83 c4 10             	add    $0x10,%esp
8010510b:	39 06                	cmp    %eax,(%esi)
8010510d:	75 41                	jne    80105150 <sys_link+0xf0>
8010510f:	83 ec 04             	sub    $0x4,%esp
80105112:	ff 73 04             	pushl  0x4(%ebx)
80105115:	57                   	push   %edi
80105116:	56                   	push   %esi
80105117:	e8 54 ce ff ff       	call   80101f70 <dirlink>
8010511c:	83 c4 10             	add    $0x10,%esp
8010511f:	85 c0                	test   %eax,%eax
80105121:	78 2d                	js     80105150 <sys_link+0xf0>
  iunlockput(dp);
80105123:	83 ec 0c             	sub    $0xc,%esp
80105126:	56                   	push   %esi
80105127:	e8 d4 c8 ff ff       	call   80101a00 <iunlockput>
  iput(ip);
8010512c:	89 1c 24             	mov    %ebx,(%esp)
8010512f:	e8 5c c7 ff ff       	call   80101890 <iput>
  end_op();
80105134:	e8 c7 dc ff ff       	call   80102e00 <end_op>
  return 0;
80105139:	83 c4 10             	add    $0x10,%esp
8010513c:	31 c0                	xor    %eax,%eax
}
8010513e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105141:	5b                   	pop    %ebx
80105142:	5e                   	pop    %esi
80105143:	5f                   	pop    %edi
80105144:	5d                   	pop    %ebp
80105145:	c3                   	ret    
80105146:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010514d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80105150:	83 ec 0c             	sub    $0xc,%esp
80105153:	56                   	push   %esi
80105154:	e8 a7 c8 ff ff       	call   80101a00 <iunlockput>
    goto bad;
80105159:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
8010515c:	83 ec 0c             	sub    $0xc,%esp
8010515f:	53                   	push   %ebx
80105160:	e8 fb c5 ff ff       	call   80101760 <ilock>
  ip->nlink--;
80105165:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010516a:	89 1c 24             	mov    %ebx,(%esp)
8010516d:	e8 2e c5 ff ff       	call   801016a0 <iupdate>
  iunlockput(ip);
80105172:	89 1c 24             	mov    %ebx,(%esp)
80105175:	e8 86 c8 ff ff       	call   80101a00 <iunlockput>
  end_op();
8010517a:	e8 81 dc ff ff       	call   80102e00 <end_op>
  return -1;
8010517f:	83 c4 10             	add    $0x10,%esp
80105182:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105187:	eb b5                	jmp    8010513e <sys_link+0xde>
    iunlockput(ip);
80105189:	83 ec 0c             	sub    $0xc,%esp
8010518c:	53                   	push   %ebx
8010518d:	e8 6e c8 ff ff       	call   80101a00 <iunlockput>
    end_op();
80105192:	e8 69 dc ff ff       	call   80102e00 <end_op>
    return -1;
80105197:	83 c4 10             	add    $0x10,%esp
8010519a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010519f:	eb 9d                	jmp    8010513e <sys_link+0xde>
    end_op();
801051a1:	e8 5a dc ff ff       	call   80102e00 <end_op>
    return -1;
801051a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051ab:	eb 91                	jmp    8010513e <sys_link+0xde>
801051ad:	8d 76 00             	lea    0x0(%esi),%esi

801051b0 <sys_unlink>:
{
801051b0:	f3 0f 1e fb          	endbr32 
801051b4:	55                   	push   %ebp
801051b5:	89 e5                	mov    %esp,%ebp
801051b7:	57                   	push   %edi
801051b8:	56                   	push   %esi
  if(argstr(0, &path) < 0)
801051b9:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801051bc:	53                   	push   %ebx
801051bd:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
801051c0:	50                   	push   %eax
801051c1:	6a 00                	push   $0x0
801051c3:	e8 08 fa ff ff       	call   80104bd0 <argstr>
801051c8:	83 c4 10             	add    $0x10,%esp
801051cb:	85 c0                	test   %eax,%eax
801051cd:	0f 88 7d 01 00 00    	js     80105350 <sys_unlink+0x1a0>
  begin_op();
801051d3:	e8 b8 db ff ff       	call   80102d90 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801051d8:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801051db:	83 ec 08             	sub    $0x8,%esp
801051de:	53                   	push   %ebx
801051df:	ff 75 c0             	pushl  -0x40(%ebp)
801051e2:	e8 69 ce ff ff       	call   80102050 <nameiparent>
801051e7:	83 c4 10             	add    $0x10,%esp
801051ea:	89 c6                	mov    %eax,%esi
801051ec:	85 c0                	test   %eax,%eax
801051ee:	0f 84 66 01 00 00    	je     8010535a <sys_unlink+0x1aa>
  ilock(dp);
801051f4:	83 ec 0c             	sub    $0xc,%esp
801051f7:	50                   	push   %eax
801051f8:	e8 63 c5 ff ff       	call   80101760 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801051fd:	58                   	pop    %eax
801051fe:	5a                   	pop    %edx
801051ff:	68 9c 7f 10 80       	push   $0x80107f9c
80105204:	53                   	push   %ebx
80105205:	e8 86 ca ff ff       	call   80101c90 <namecmp>
8010520a:	83 c4 10             	add    $0x10,%esp
8010520d:	85 c0                	test   %eax,%eax
8010520f:	0f 84 03 01 00 00    	je     80105318 <sys_unlink+0x168>
80105215:	83 ec 08             	sub    $0x8,%esp
80105218:	68 9b 7f 10 80       	push   $0x80107f9b
8010521d:	53                   	push   %ebx
8010521e:	e8 6d ca ff ff       	call   80101c90 <namecmp>
80105223:	83 c4 10             	add    $0x10,%esp
80105226:	85 c0                	test   %eax,%eax
80105228:	0f 84 ea 00 00 00    	je     80105318 <sys_unlink+0x168>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010522e:	83 ec 04             	sub    $0x4,%esp
80105231:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105234:	50                   	push   %eax
80105235:	53                   	push   %ebx
80105236:	56                   	push   %esi
80105237:	e8 74 ca ff ff       	call   80101cb0 <dirlookup>
8010523c:	83 c4 10             	add    $0x10,%esp
8010523f:	89 c3                	mov    %eax,%ebx
80105241:	85 c0                	test   %eax,%eax
80105243:	0f 84 cf 00 00 00    	je     80105318 <sys_unlink+0x168>
  ilock(ip);
80105249:	83 ec 0c             	sub    $0xc,%esp
8010524c:	50                   	push   %eax
8010524d:	e8 0e c5 ff ff       	call   80101760 <ilock>
  if(ip->nlink < 1)
80105252:	83 c4 10             	add    $0x10,%esp
80105255:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010525a:	0f 8e 23 01 00 00    	jle    80105383 <sys_unlink+0x1d3>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105260:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105265:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105268:	74 66                	je     801052d0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010526a:	83 ec 04             	sub    $0x4,%esp
8010526d:	6a 10                	push   $0x10
8010526f:	6a 00                	push   $0x0
80105271:	57                   	push   %edi
80105272:	e8 c9 f5 ff ff       	call   80104840 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105277:	6a 10                	push   $0x10
80105279:	ff 75 c4             	pushl  -0x3c(%ebp)
8010527c:	57                   	push   %edi
8010527d:	56                   	push   %esi
8010527e:	e8 dd c8 ff ff       	call   80101b60 <writei>
80105283:	83 c4 20             	add    $0x20,%esp
80105286:	83 f8 10             	cmp    $0x10,%eax
80105289:	0f 85 e7 00 00 00    	jne    80105376 <sys_unlink+0x1c6>
  if(ip->type == T_DIR){
8010528f:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105294:	0f 84 96 00 00 00    	je     80105330 <sys_unlink+0x180>
  iunlockput(dp);
8010529a:	83 ec 0c             	sub    $0xc,%esp
8010529d:	56                   	push   %esi
8010529e:	e8 5d c7 ff ff       	call   80101a00 <iunlockput>
  ip->nlink--;
801052a3:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801052a8:	89 1c 24             	mov    %ebx,(%esp)
801052ab:	e8 f0 c3 ff ff       	call   801016a0 <iupdate>
  iunlockput(ip);
801052b0:	89 1c 24             	mov    %ebx,(%esp)
801052b3:	e8 48 c7 ff ff       	call   80101a00 <iunlockput>
  end_op();
801052b8:	e8 43 db ff ff       	call   80102e00 <end_op>
  return 0;
801052bd:	83 c4 10             	add    $0x10,%esp
801052c0:	31 c0                	xor    %eax,%eax
}
801052c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801052c5:	5b                   	pop    %ebx
801052c6:	5e                   	pop    %esi
801052c7:	5f                   	pop    %edi
801052c8:	5d                   	pop    %ebp
801052c9:	c3                   	ret    
801052ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801052d0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801052d4:	76 94                	jbe    8010526a <sys_unlink+0xba>
801052d6:	ba 20 00 00 00       	mov    $0x20,%edx
801052db:	eb 0b                	jmp    801052e8 <sys_unlink+0x138>
801052dd:	8d 76 00             	lea    0x0(%esi),%esi
801052e0:	83 c2 10             	add    $0x10,%edx
801052e3:	39 53 58             	cmp    %edx,0x58(%ebx)
801052e6:	76 82                	jbe    8010526a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801052e8:	6a 10                	push   $0x10
801052ea:	52                   	push   %edx
801052eb:	57                   	push   %edi
801052ec:	53                   	push   %ebx
801052ed:	89 55 b4             	mov    %edx,-0x4c(%ebp)
801052f0:	e8 6b c7 ff ff       	call   80101a60 <readi>
801052f5:	83 c4 10             	add    $0x10,%esp
801052f8:	8b 55 b4             	mov    -0x4c(%ebp),%edx
801052fb:	83 f8 10             	cmp    $0x10,%eax
801052fe:	75 69                	jne    80105369 <sys_unlink+0x1b9>
    if(de.inum != 0)
80105300:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105305:	74 d9                	je     801052e0 <sys_unlink+0x130>
    iunlockput(ip);
80105307:	83 ec 0c             	sub    $0xc,%esp
8010530a:	53                   	push   %ebx
8010530b:	e8 f0 c6 ff ff       	call   80101a00 <iunlockput>
    goto bad;
80105310:	83 c4 10             	add    $0x10,%esp
80105313:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105317:	90                   	nop
  iunlockput(dp);
80105318:	83 ec 0c             	sub    $0xc,%esp
8010531b:	56                   	push   %esi
8010531c:	e8 df c6 ff ff       	call   80101a00 <iunlockput>
  end_op();
80105321:	e8 da da ff ff       	call   80102e00 <end_op>
  return -1;
80105326:	83 c4 10             	add    $0x10,%esp
80105329:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010532e:	eb 92                	jmp    801052c2 <sys_unlink+0x112>
    iupdate(dp);
80105330:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105333:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105338:	56                   	push   %esi
80105339:	e8 62 c3 ff ff       	call   801016a0 <iupdate>
8010533e:	83 c4 10             	add    $0x10,%esp
80105341:	e9 54 ff ff ff       	jmp    8010529a <sys_unlink+0xea>
80105346:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010534d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105350:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105355:	e9 68 ff ff ff       	jmp    801052c2 <sys_unlink+0x112>
    end_op();
8010535a:	e8 a1 da ff ff       	call   80102e00 <end_op>
    return -1;
8010535f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105364:	e9 59 ff ff ff       	jmp    801052c2 <sys_unlink+0x112>
      panic("isdirempty: readi");
80105369:	83 ec 0c             	sub    $0xc,%esp
8010536c:	68 c0 7f 10 80       	push   $0x80107fc0
80105371:	e8 1a b0 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105376:	83 ec 0c             	sub    $0xc,%esp
80105379:	68 d2 7f 10 80       	push   $0x80107fd2
8010537e:	e8 0d b0 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105383:	83 ec 0c             	sub    $0xc,%esp
80105386:	68 ae 7f 10 80       	push   $0x80107fae
8010538b:	e8 00 b0 ff ff       	call   80100390 <panic>

80105390 <sys_open>:

int
sys_open(void)
{
80105390:	f3 0f 1e fb          	endbr32 
80105394:	55                   	push   %ebp
80105395:	89 e5                	mov    %esp,%ebp
80105397:	57                   	push   %edi
80105398:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105399:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
8010539c:	53                   	push   %ebx
8010539d:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801053a0:	50                   	push   %eax
801053a1:	6a 00                	push   $0x0
801053a3:	e8 28 f8 ff ff       	call   80104bd0 <argstr>
801053a8:	83 c4 10             	add    $0x10,%esp
801053ab:	85 c0                	test   %eax,%eax
801053ad:	0f 88 8a 00 00 00    	js     8010543d <sys_open+0xad>
801053b3:	83 ec 08             	sub    $0x8,%esp
801053b6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801053b9:	50                   	push   %eax
801053ba:	6a 01                	push   $0x1
801053bc:	e8 5f f7 ff ff       	call   80104b20 <argint>
801053c1:	83 c4 10             	add    $0x10,%esp
801053c4:	85 c0                	test   %eax,%eax
801053c6:	78 75                	js     8010543d <sys_open+0xad>
    return -1;

  begin_op();
801053c8:	e8 c3 d9 ff ff       	call   80102d90 <begin_op>

  if(omode & O_CREATE){
801053cd:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801053d1:	75 75                	jne    80105448 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801053d3:	83 ec 0c             	sub    $0xc,%esp
801053d6:	ff 75 e0             	pushl  -0x20(%ebp)
801053d9:	e8 52 cc ff ff       	call   80102030 <namei>
801053de:	83 c4 10             	add    $0x10,%esp
801053e1:	89 c6                	mov    %eax,%esi
801053e3:	85 c0                	test   %eax,%eax
801053e5:	74 7e                	je     80105465 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801053e7:	83 ec 0c             	sub    $0xc,%esp
801053ea:	50                   	push   %eax
801053eb:	e8 70 c3 ff ff       	call   80101760 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801053f0:	83 c4 10             	add    $0x10,%esp
801053f3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801053f8:	0f 84 c2 00 00 00    	je     801054c0 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801053fe:	e8 fd b9 ff ff       	call   80100e00 <filealloc>
80105403:	89 c7                	mov    %eax,%edi
80105405:	85 c0                	test   %eax,%eax
80105407:	74 23                	je     8010542c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105409:	e8 a2 e5 ff ff       	call   801039b0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010540e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105410:	8b 54 98 2c          	mov    0x2c(%eax,%ebx,4),%edx
80105414:	85 d2                	test   %edx,%edx
80105416:	74 60                	je     80105478 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105418:	83 c3 01             	add    $0x1,%ebx
8010541b:	83 fb 10             	cmp    $0x10,%ebx
8010541e:	75 f0                	jne    80105410 <sys_open+0x80>
    if(f)
      fileclose(f);
80105420:	83 ec 0c             	sub    $0xc,%esp
80105423:	57                   	push   %edi
80105424:	e8 97 ba ff ff       	call   80100ec0 <fileclose>
80105429:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010542c:	83 ec 0c             	sub    $0xc,%esp
8010542f:	56                   	push   %esi
80105430:	e8 cb c5 ff ff       	call   80101a00 <iunlockput>
    end_op();
80105435:	e8 c6 d9 ff ff       	call   80102e00 <end_op>
    return -1;
8010543a:	83 c4 10             	add    $0x10,%esp
8010543d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105442:	eb 6d                	jmp    801054b1 <sys_open+0x121>
80105444:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105448:	83 ec 0c             	sub    $0xc,%esp
8010544b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010544e:	31 c9                	xor    %ecx,%ecx
80105450:	ba 02 00 00 00       	mov    $0x2,%edx
80105455:	6a 00                	push   $0x0
80105457:	e8 24 f8 ff ff       	call   80104c80 <create>
    if(ip == 0){
8010545c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010545f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105461:	85 c0                	test   %eax,%eax
80105463:	75 99                	jne    801053fe <sys_open+0x6e>
      end_op();
80105465:	e8 96 d9 ff ff       	call   80102e00 <end_op>
      return -1;
8010546a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010546f:	eb 40                	jmp    801054b1 <sys_open+0x121>
80105471:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105478:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010547b:	89 7c 98 2c          	mov    %edi,0x2c(%eax,%ebx,4)
  iunlock(ip);
8010547f:	56                   	push   %esi
80105480:	e8 bb c3 ff ff       	call   80101840 <iunlock>
  end_op();
80105485:	e8 76 d9 ff ff       	call   80102e00 <end_op>

  f->type = FD_INODE;
8010548a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105490:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105493:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105496:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105499:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010549b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801054a2:	f7 d0                	not    %eax
801054a4:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801054a7:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801054aa:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801054ad:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801054b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801054b4:	89 d8                	mov    %ebx,%eax
801054b6:	5b                   	pop    %ebx
801054b7:	5e                   	pop    %esi
801054b8:	5f                   	pop    %edi
801054b9:	5d                   	pop    %ebp
801054ba:	c3                   	ret    
801054bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801054bf:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
801054c0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801054c3:	85 c9                	test   %ecx,%ecx
801054c5:	0f 84 33 ff ff ff    	je     801053fe <sys_open+0x6e>
801054cb:	e9 5c ff ff ff       	jmp    8010542c <sys_open+0x9c>

801054d0 <sys_mkdir>:

int
sys_mkdir(void)
{
801054d0:	f3 0f 1e fb          	endbr32 
801054d4:	55                   	push   %ebp
801054d5:	89 e5                	mov    %esp,%ebp
801054d7:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801054da:	e8 b1 d8 ff ff       	call   80102d90 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801054df:	83 ec 08             	sub    $0x8,%esp
801054e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054e5:	50                   	push   %eax
801054e6:	6a 00                	push   $0x0
801054e8:	e8 e3 f6 ff ff       	call   80104bd0 <argstr>
801054ed:	83 c4 10             	add    $0x10,%esp
801054f0:	85 c0                	test   %eax,%eax
801054f2:	78 34                	js     80105528 <sys_mkdir+0x58>
801054f4:	83 ec 0c             	sub    $0xc,%esp
801054f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054fa:	31 c9                	xor    %ecx,%ecx
801054fc:	ba 01 00 00 00       	mov    $0x1,%edx
80105501:	6a 00                	push   $0x0
80105503:	e8 78 f7 ff ff       	call   80104c80 <create>
80105508:	83 c4 10             	add    $0x10,%esp
8010550b:	85 c0                	test   %eax,%eax
8010550d:	74 19                	je     80105528 <sys_mkdir+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010550f:	83 ec 0c             	sub    $0xc,%esp
80105512:	50                   	push   %eax
80105513:	e8 e8 c4 ff ff       	call   80101a00 <iunlockput>
  end_op();
80105518:	e8 e3 d8 ff ff       	call   80102e00 <end_op>
  return 0;
8010551d:	83 c4 10             	add    $0x10,%esp
80105520:	31 c0                	xor    %eax,%eax
}
80105522:	c9                   	leave  
80105523:	c3                   	ret    
80105524:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105528:	e8 d3 d8 ff ff       	call   80102e00 <end_op>
    return -1;
8010552d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105532:	c9                   	leave  
80105533:	c3                   	ret    
80105534:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010553b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010553f:	90                   	nop

80105540 <sys_mknod>:

int
sys_mknod(void)
{
80105540:	f3 0f 1e fb          	endbr32 
80105544:	55                   	push   %ebp
80105545:	89 e5                	mov    %esp,%ebp
80105547:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
8010554a:	e8 41 d8 ff ff       	call   80102d90 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010554f:	83 ec 08             	sub    $0x8,%esp
80105552:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105555:	50                   	push   %eax
80105556:	6a 00                	push   $0x0
80105558:	e8 73 f6 ff ff       	call   80104bd0 <argstr>
8010555d:	83 c4 10             	add    $0x10,%esp
80105560:	85 c0                	test   %eax,%eax
80105562:	78 64                	js     801055c8 <sys_mknod+0x88>
     argint(1, &major) < 0 ||
80105564:	83 ec 08             	sub    $0x8,%esp
80105567:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010556a:	50                   	push   %eax
8010556b:	6a 01                	push   $0x1
8010556d:	e8 ae f5 ff ff       	call   80104b20 <argint>
  if((argstr(0, &path)) < 0 ||
80105572:	83 c4 10             	add    $0x10,%esp
80105575:	85 c0                	test   %eax,%eax
80105577:	78 4f                	js     801055c8 <sys_mknod+0x88>
     argint(2, &minor) < 0 ||
80105579:	83 ec 08             	sub    $0x8,%esp
8010557c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010557f:	50                   	push   %eax
80105580:	6a 02                	push   $0x2
80105582:	e8 99 f5 ff ff       	call   80104b20 <argint>
     argint(1, &major) < 0 ||
80105587:	83 c4 10             	add    $0x10,%esp
8010558a:	85 c0                	test   %eax,%eax
8010558c:	78 3a                	js     801055c8 <sys_mknod+0x88>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010558e:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105592:	83 ec 0c             	sub    $0xc,%esp
80105595:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105599:	ba 03 00 00 00       	mov    $0x3,%edx
8010559e:	50                   	push   %eax
8010559f:	8b 45 ec             	mov    -0x14(%ebp),%eax
801055a2:	e8 d9 f6 ff ff       	call   80104c80 <create>
     argint(2, &minor) < 0 ||
801055a7:	83 c4 10             	add    $0x10,%esp
801055aa:	85 c0                	test   %eax,%eax
801055ac:	74 1a                	je     801055c8 <sys_mknod+0x88>
    end_op();
    return -1;
  }
  iunlockput(ip);
801055ae:	83 ec 0c             	sub    $0xc,%esp
801055b1:	50                   	push   %eax
801055b2:	e8 49 c4 ff ff       	call   80101a00 <iunlockput>
  end_op();
801055b7:	e8 44 d8 ff ff       	call   80102e00 <end_op>
  return 0;
801055bc:	83 c4 10             	add    $0x10,%esp
801055bf:	31 c0                	xor    %eax,%eax
}
801055c1:	c9                   	leave  
801055c2:	c3                   	ret    
801055c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801055c7:	90                   	nop
    end_op();
801055c8:	e8 33 d8 ff ff       	call   80102e00 <end_op>
    return -1;
801055cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055d2:	c9                   	leave  
801055d3:	c3                   	ret    
801055d4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801055df:	90                   	nop

801055e0 <sys_chdir>:

int
sys_chdir(void)
{
801055e0:	f3 0f 1e fb          	endbr32 
801055e4:	55                   	push   %ebp
801055e5:	89 e5                	mov    %esp,%ebp
801055e7:	56                   	push   %esi
801055e8:	53                   	push   %ebx
801055e9:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801055ec:	e8 bf e3 ff ff       	call   801039b0 <myproc>
801055f1:	89 c6                	mov    %eax,%esi
  
  begin_op();
801055f3:	e8 98 d7 ff ff       	call   80102d90 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801055f8:	83 ec 08             	sub    $0x8,%esp
801055fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055fe:	50                   	push   %eax
801055ff:	6a 00                	push   $0x0
80105601:	e8 ca f5 ff ff       	call   80104bd0 <argstr>
80105606:	83 c4 10             	add    $0x10,%esp
80105609:	85 c0                	test   %eax,%eax
8010560b:	78 73                	js     80105680 <sys_chdir+0xa0>
8010560d:	83 ec 0c             	sub    $0xc,%esp
80105610:	ff 75 f4             	pushl  -0xc(%ebp)
80105613:	e8 18 ca ff ff       	call   80102030 <namei>
80105618:	83 c4 10             	add    $0x10,%esp
8010561b:	89 c3                	mov    %eax,%ebx
8010561d:	85 c0                	test   %eax,%eax
8010561f:	74 5f                	je     80105680 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105621:	83 ec 0c             	sub    $0xc,%esp
80105624:	50                   	push   %eax
80105625:	e8 36 c1 ff ff       	call   80101760 <ilock>
  if(ip->type != T_DIR){
8010562a:	83 c4 10             	add    $0x10,%esp
8010562d:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105632:	75 2c                	jne    80105660 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105634:	83 ec 0c             	sub    $0xc,%esp
80105637:	53                   	push   %ebx
80105638:	e8 03 c2 ff ff       	call   80101840 <iunlock>
  iput(curproc->cwd);
8010563d:	58                   	pop    %eax
8010563e:	ff 76 6c             	pushl  0x6c(%esi)
80105641:	e8 4a c2 ff ff       	call   80101890 <iput>
  end_op();
80105646:	e8 b5 d7 ff ff       	call   80102e00 <end_op>
  curproc->cwd = ip;
8010564b:	89 5e 6c             	mov    %ebx,0x6c(%esi)
  return 0;
8010564e:	83 c4 10             	add    $0x10,%esp
80105651:	31 c0                	xor    %eax,%eax
}
80105653:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105656:	5b                   	pop    %ebx
80105657:	5e                   	pop    %esi
80105658:	5d                   	pop    %ebp
80105659:	c3                   	ret    
8010565a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105660:	83 ec 0c             	sub    $0xc,%esp
80105663:	53                   	push   %ebx
80105664:	e8 97 c3 ff ff       	call   80101a00 <iunlockput>
    end_op();
80105669:	e8 92 d7 ff ff       	call   80102e00 <end_op>
    return -1;
8010566e:	83 c4 10             	add    $0x10,%esp
80105671:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105676:	eb db                	jmp    80105653 <sys_chdir+0x73>
80105678:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010567f:	90                   	nop
    end_op();
80105680:	e8 7b d7 ff ff       	call   80102e00 <end_op>
    return -1;
80105685:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010568a:	eb c7                	jmp    80105653 <sys_chdir+0x73>
8010568c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105690 <sys_exec>:

int
sys_exec(void)
{
80105690:	f3 0f 1e fb          	endbr32 
80105694:	55                   	push   %ebp
80105695:	89 e5                	mov    %esp,%ebp
80105697:	57                   	push   %edi
80105698:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105699:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010569f:	53                   	push   %ebx
801056a0:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801056a6:	50                   	push   %eax
801056a7:	6a 00                	push   $0x0
801056a9:	e8 22 f5 ff ff       	call   80104bd0 <argstr>
801056ae:	83 c4 10             	add    $0x10,%esp
801056b1:	85 c0                	test   %eax,%eax
801056b3:	0f 88 8b 00 00 00    	js     80105744 <sys_exec+0xb4>
801056b9:	83 ec 08             	sub    $0x8,%esp
801056bc:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801056c2:	50                   	push   %eax
801056c3:	6a 01                	push   $0x1
801056c5:	e8 56 f4 ff ff       	call   80104b20 <argint>
801056ca:	83 c4 10             	add    $0x10,%esp
801056cd:	85 c0                	test   %eax,%eax
801056cf:	78 73                	js     80105744 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801056d1:	83 ec 04             	sub    $0x4,%esp
801056d4:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
801056da:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801056dc:	68 80 00 00 00       	push   $0x80
801056e1:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801056e7:	6a 00                	push   $0x0
801056e9:	50                   	push   %eax
801056ea:	e8 51 f1 ff ff       	call   80104840 <memset>
801056ef:	83 c4 10             	add    $0x10,%esp
801056f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801056f8:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801056fe:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105705:	83 ec 08             	sub    $0x8,%esp
80105708:	57                   	push   %edi
80105709:	01 f0                	add    %esi,%eax
8010570b:	50                   	push   %eax
8010570c:	e8 6f f3 ff ff       	call   80104a80 <fetchint>
80105711:	83 c4 10             	add    $0x10,%esp
80105714:	85 c0                	test   %eax,%eax
80105716:	78 2c                	js     80105744 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
80105718:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010571e:	85 c0                	test   %eax,%eax
80105720:	74 36                	je     80105758 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105722:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105728:	83 ec 08             	sub    $0x8,%esp
8010572b:	8d 14 31             	lea    (%ecx,%esi,1),%edx
8010572e:	52                   	push   %edx
8010572f:	50                   	push   %eax
80105730:	e8 8b f3 ff ff       	call   80104ac0 <fetchstr>
80105735:	83 c4 10             	add    $0x10,%esp
80105738:	85 c0                	test   %eax,%eax
8010573a:	78 08                	js     80105744 <sys_exec+0xb4>
  for(i=0;; i++){
8010573c:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
8010573f:	83 fb 20             	cmp    $0x20,%ebx
80105742:	75 b4                	jne    801056f8 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
80105744:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105747:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010574c:	5b                   	pop    %ebx
8010574d:	5e                   	pop    %esi
8010574e:	5f                   	pop    %edi
8010574f:	5d                   	pop    %ebp
80105750:	c3                   	ret    
80105751:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105758:	83 ec 08             	sub    $0x8,%esp
8010575b:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80105761:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105768:	00 00 00 00 
  return exec(path, argv);
8010576c:	50                   	push   %eax
8010576d:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105773:	e8 08 b3 ff ff       	call   80100a80 <exec>
80105778:	83 c4 10             	add    $0x10,%esp
}
8010577b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010577e:	5b                   	pop    %ebx
8010577f:	5e                   	pop    %esi
80105780:	5f                   	pop    %edi
80105781:	5d                   	pop    %ebp
80105782:	c3                   	ret    
80105783:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010578a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105790 <sys_pipe>:

int
sys_pipe(void)
{
80105790:	f3 0f 1e fb          	endbr32 
80105794:	55                   	push   %ebp
80105795:	89 e5                	mov    %esp,%ebp
80105797:	57                   	push   %edi
80105798:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105799:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
8010579c:	53                   	push   %ebx
8010579d:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801057a0:	6a 08                	push   $0x8
801057a2:	50                   	push   %eax
801057a3:	6a 00                	push   $0x0
801057a5:	e8 c6 f3 ff ff       	call   80104b70 <argptr>
801057aa:	83 c4 10             	add    $0x10,%esp
801057ad:	85 c0                	test   %eax,%eax
801057af:	78 4e                	js     801057ff <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801057b1:	83 ec 08             	sub    $0x8,%esp
801057b4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801057b7:	50                   	push   %eax
801057b8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801057bb:	50                   	push   %eax
801057bc:	e8 8f dc ff ff       	call   80103450 <pipealloc>
801057c1:	83 c4 10             	add    $0x10,%esp
801057c4:	85 c0                	test   %eax,%eax
801057c6:	78 37                	js     801057ff <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801057c8:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801057cb:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801057cd:	e8 de e1 ff ff       	call   801039b0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801057d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
801057d8:	8b 74 98 2c          	mov    0x2c(%eax,%ebx,4),%esi
801057dc:	85 f6                	test   %esi,%esi
801057de:	74 30                	je     80105810 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
801057e0:	83 c3 01             	add    $0x1,%ebx
801057e3:	83 fb 10             	cmp    $0x10,%ebx
801057e6:	75 f0                	jne    801057d8 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
801057e8:	83 ec 0c             	sub    $0xc,%esp
801057eb:	ff 75 e0             	pushl  -0x20(%ebp)
801057ee:	e8 cd b6 ff ff       	call   80100ec0 <fileclose>
    fileclose(wf);
801057f3:	58                   	pop    %eax
801057f4:	ff 75 e4             	pushl  -0x1c(%ebp)
801057f7:	e8 c4 b6 ff ff       	call   80100ec0 <fileclose>
    return -1;
801057fc:	83 c4 10             	add    $0x10,%esp
801057ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105804:	eb 5b                	jmp    80105861 <sys_pipe+0xd1>
80105806:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010580d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105810:	8d 73 08             	lea    0x8(%ebx),%esi
80105813:	89 7c b0 0c          	mov    %edi,0xc(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105817:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010581a:	e8 91 e1 ff ff       	call   801039b0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010581f:	31 d2                	xor    %edx,%edx
80105821:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105828:	8b 4c 90 2c          	mov    0x2c(%eax,%edx,4),%ecx
8010582c:	85 c9                	test   %ecx,%ecx
8010582e:	74 20                	je     80105850 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80105830:	83 c2 01             	add    $0x1,%edx
80105833:	83 fa 10             	cmp    $0x10,%edx
80105836:	75 f0                	jne    80105828 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80105838:	e8 73 e1 ff ff       	call   801039b0 <myproc>
8010583d:	c7 44 b0 0c 00 00 00 	movl   $0x0,0xc(%eax,%esi,4)
80105844:	00 
80105845:	eb a1                	jmp    801057e8 <sys_pipe+0x58>
80105847:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010584e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105850:	89 7c 90 2c          	mov    %edi,0x2c(%eax,%edx,4)
  }
  fd[0] = fd0;
80105854:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105857:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105859:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010585c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010585f:	31 c0                	xor    %eax,%eax
}
80105861:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105864:	5b                   	pop    %ebx
80105865:	5e                   	pop    %esi
80105866:	5f                   	pop    %edi
80105867:	5d                   	pop    %ebp
80105868:	c3                   	ret    
80105869:	66 90                	xchg   %ax,%ax
8010586b:	66 90                	xchg   %ax,%ax
8010586d:	66 90                	xchg   %ax,%ax
8010586f:	90                   	nop

80105870 <sys_getNumFreePages>:
#include "proc.h"


int
sys_getNumFreePages(void)
{
80105870:	f3 0f 1e fb          	endbr32 
  return num_of_FreePages();  
80105874:	e9 57 ce ff ff       	jmp    801026d0 <num_of_FreePages>
80105879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105880 <sys_getrss>:
}

int 
sys_getrss()
{
80105880:	f3 0f 1e fb          	endbr32 
80105884:	55                   	push   %ebp
80105885:	89 e5                	mov    %esp,%ebp
80105887:	83 ec 08             	sub    $0x8,%esp
  print_rss();
8010588a:	e8 01 e4 ff ff       	call   80103c90 <print_rss>
  return 0;
}
8010588f:	31 c0                	xor    %eax,%eax
80105891:	c9                   	leave  
80105892:	c3                   	ret    
80105893:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010589a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801058a0 <sys_fork>:

int
sys_fork(void)
{
801058a0:	f3 0f 1e fb          	endbr32 
  return fork();
801058a4:	e9 b7 e2 ff ff       	jmp    80103b60 <fork>
801058a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801058b0 <sys_exit>:
}

int
sys_exit(void)
{
801058b0:	f3 0f 1e fb          	endbr32 
801058b4:	55                   	push   %ebp
801058b5:	89 e5                	mov    %esp,%ebp
801058b7:	83 ec 08             	sub    $0x8,%esp
  exit();
801058ba:	e8 21 e6 ff ff       	call   80103ee0 <exit>
  return 0;  // not reached
}
801058bf:	31 c0                	xor    %eax,%eax
801058c1:	c9                   	leave  
801058c2:	c3                   	ret    
801058c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801058d0 <sys_wait>:

int
sys_wait(void)
{
801058d0:	f3 0f 1e fb          	endbr32 
  return wait();
801058d4:	e9 c7 e8 ff ff       	jmp    801041a0 <wait>
801058d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801058e0 <sys_kill>:
}

int
sys_kill(void)
{
801058e0:	f3 0f 1e fb          	endbr32 
801058e4:	55                   	push   %ebp
801058e5:	89 e5                	mov    %esp,%ebp
801058e7:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801058ea:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058ed:	50                   	push   %eax
801058ee:	6a 00                	push   $0x0
801058f0:	e8 2b f2 ff ff       	call   80104b20 <argint>
801058f5:	83 c4 10             	add    $0x10,%esp
801058f8:	85 c0                	test   %eax,%eax
801058fa:	78 14                	js     80105910 <sys_kill+0x30>
    return -1;
  return kill(pid);
801058fc:	83 ec 0c             	sub    $0xc,%esp
801058ff:	ff 75 f4             	pushl  -0xc(%ebp)
80105902:	e8 09 ea ff ff       	call   80104310 <kill>
80105907:	83 c4 10             	add    $0x10,%esp
}
8010590a:	c9                   	leave  
8010590b:	c3                   	ret    
8010590c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105910:	c9                   	leave  
    return -1;
80105911:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105916:	c3                   	ret    
80105917:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010591e:	66 90                	xchg   %ax,%ax

80105920 <sys_getpid>:

int
sys_getpid(void)
{
80105920:	f3 0f 1e fb          	endbr32 
80105924:	55                   	push   %ebp
80105925:	89 e5                	mov    %esp,%ebp
80105927:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
8010592a:	e8 81 e0 ff ff       	call   801039b0 <myproc>
8010592f:	8b 40 14             	mov    0x14(%eax),%eax
}
80105932:	c9                   	leave  
80105933:	c3                   	ret    
80105934:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010593b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010593f:	90                   	nop

80105940 <sys_sbrk>:

int
sys_sbrk(void)
{
80105940:	f3 0f 1e fb          	endbr32 
80105944:	55                   	push   %ebp
80105945:	89 e5                	mov    %esp,%ebp
80105947:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105948:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
8010594b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010594e:	50                   	push   %eax
8010594f:	6a 00                	push   $0x0
80105951:	e8 ca f1 ff ff       	call   80104b20 <argint>
80105956:	83 c4 10             	add    $0x10,%esp
80105959:	85 c0                	test   %eax,%eax
8010595b:	78 23                	js     80105980 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
8010595d:	e8 4e e0 ff ff       	call   801039b0 <myproc>
  if(growproc(n) < 0)
80105962:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105965:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105967:	ff 75 f4             	pushl  -0xc(%ebp)
8010596a:	e8 71 e1 ff ff       	call   80103ae0 <growproc>
8010596f:	83 c4 10             	add    $0x10,%esp
80105972:	85 c0                	test   %eax,%eax
80105974:	78 0a                	js     80105980 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105976:	89 d8                	mov    %ebx,%eax
80105978:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010597b:	c9                   	leave  
8010597c:	c3                   	ret    
8010597d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105980:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105985:	eb ef                	jmp    80105976 <sys_sbrk+0x36>
80105987:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010598e:	66 90                	xchg   %ax,%ax

80105990 <sys_sleep>:

int
sys_sleep(void)
{
80105990:	f3 0f 1e fb          	endbr32 
80105994:	55                   	push   %ebp
80105995:	89 e5                	mov    %esp,%ebp
80105997:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105998:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
8010599b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010599e:	50                   	push   %eax
8010599f:	6a 00                	push   $0x0
801059a1:	e8 7a f1 ff ff       	call   80104b20 <argint>
801059a6:	83 c4 10             	add    $0x10,%esp
801059a9:	85 c0                	test   %eax,%eax
801059ab:	0f 88 86 00 00 00    	js     80105a37 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801059b1:	83 ec 0c             	sub    $0xc,%esp
801059b4:	68 a0 58 11 80       	push   $0x801158a0
801059b9:	e8 72 ed ff ff       	call   80104730 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801059be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
801059c1:	8b 1d e0 60 11 80    	mov    0x801160e0,%ebx
  while(ticks - ticks0 < n){
801059c7:	83 c4 10             	add    $0x10,%esp
801059ca:	85 d2                	test   %edx,%edx
801059cc:	75 23                	jne    801059f1 <sys_sleep+0x61>
801059ce:	eb 50                	jmp    80105a20 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801059d0:	83 ec 08             	sub    $0x8,%esp
801059d3:	68 a0 58 11 80       	push   $0x801158a0
801059d8:	68 e0 60 11 80       	push   $0x801160e0
801059dd:	e8 fe e6 ff ff       	call   801040e0 <sleep>
  while(ticks - ticks0 < n){
801059e2:	a1 e0 60 11 80       	mov    0x801160e0,%eax
801059e7:	83 c4 10             	add    $0x10,%esp
801059ea:	29 d8                	sub    %ebx,%eax
801059ec:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801059ef:	73 2f                	jae    80105a20 <sys_sleep+0x90>
    if(myproc()->killed){
801059f1:	e8 ba df ff ff       	call   801039b0 <myproc>
801059f6:	8b 40 28             	mov    0x28(%eax),%eax
801059f9:	85 c0                	test   %eax,%eax
801059fb:	74 d3                	je     801059d0 <sys_sleep+0x40>
      release(&tickslock);
801059fd:	83 ec 0c             	sub    $0xc,%esp
80105a00:	68 a0 58 11 80       	push   $0x801158a0
80105a05:	e8 e6 ed ff ff       	call   801047f0 <release>
  }
  release(&tickslock);
  return 0;
}
80105a0a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80105a0d:	83 c4 10             	add    $0x10,%esp
80105a10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a15:	c9                   	leave  
80105a16:	c3                   	ret    
80105a17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a1e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105a20:	83 ec 0c             	sub    $0xc,%esp
80105a23:	68 a0 58 11 80       	push   $0x801158a0
80105a28:	e8 c3 ed ff ff       	call   801047f0 <release>
  return 0;
80105a2d:	83 c4 10             	add    $0x10,%esp
80105a30:	31 c0                	xor    %eax,%eax
}
80105a32:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a35:	c9                   	leave  
80105a36:	c3                   	ret    
    return -1;
80105a37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a3c:	eb f4                	jmp    80105a32 <sys_sleep+0xa2>
80105a3e:	66 90                	xchg   %ax,%ax

80105a40 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105a40:	f3 0f 1e fb          	endbr32 
80105a44:	55                   	push   %ebp
80105a45:	89 e5                	mov    %esp,%ebp
80105a47:	53                   	push   %ebx
80105a48:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105a4b:	68 a0 58 11 80       	push   $0x801158a0
80105a50:	e8 db ec ff ff       	call   80104730 <acquire>
  xticks = ticks;
80105a55:	8b 1d e0 60 11 80    	mov    0x801160e0,%ebx
  release(&tickslock);
80105a5b:	c7 04 24 a0 58 11 80 	movl   $0x801158a0,(%esp)
80105a62:	e8 89 ed ff ff       	call   801047f0 <release>
  return xticks;
}
80105a67:	89 d8                	mov    %ebx,%eax
80105a69:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a6c:	c9                   	leave  
80105a6d:	c3                   	ret    

80105a6e <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105a6e:	1e                   	push   %ds
  pushl %es
80105a6f:	06                   	push   %es
  pushl %fs
80105a70:	0f a0                	push   %fs
  pushl %gs
80105a72:	0f a8                	push   %gs
  pushal
80105a74:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105a75:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105a79:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105a7b:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105a7d:	54                   	push   %esp
  call trap
80105a7e:	e8 cd 00 00 00       	call   80105b50 <trap>
  addl $4, %esp
80105a83:	83 c4 04             	add    $0x4,%esp

80105a86 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105a86:	61                   	popa   
  popl %gs
80105a87:	0f a9                	pop    %gs
  popl %fs
80105a89:	0f a1                	pop    %fs
  popl %es
80105a8b:	07                   	pop    %es
  popl %ds
80105a8c:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105a8d:	83 c4 08             	add    $0x8,%esp
  iret
80105a90:	cf                   	iret   
80105a91:	66 90                	xchg   %ax,%ax
80105a93:	66 90                	xchg   %ax,%ax
80105a95:	66 90                	xchg   %ax,%ax
80105a97:	66 90                	xchg   %ax,%ax
80105a99:	66 90                	xchg   %ax,%ax
80105a9b:	66 90                	xchg   %ax,%ax
80105a9d:	66 90                	xchg   %ax,%ax
80105a9f:	90                   	nop

80105aa0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105aa0:	f3 0f 1e fb          	endbr32 
80105aa4:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105aa5:	31 c0                	xor    %eax,%eax
{
80105aa7:	89 e5                	mov    %esp,%ebp
80105aa9:	83 ec 08             	sub    $0x8,%esp
80105aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105ab0:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105ab7:	c7 04 c5 e2 58 11 80 	movl   $0x8e000008,-0x7feea71e(,%eax,8)
80105abe:	08 00 00 8e 
80105ac2:	66 89 14 c5 e0 58 11 	mov    %dx,-0x7feea720(,%eax,8)
80105ac9:	80 
80105aca:	c1 ea 10             	shr    $0x10,%edx
80105acd:	66 89 14 c5 e6 58 11 	mov    %dx,-0x7feea71a(,%eax,8)
80105ad4:	80 
  for(i = 0; i < 256; i++)
80105ad5:	83 c0 01             	add    $0x1,%eax
80105ad8:	3d 00 01 00 00       	cmp    $0x100,%eax
80105add:	75 d1                	jne    80105ab0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105adf:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105ae2:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80105ae7:	c7 05 e2 5a 11 80 08 	movl   $0xef000008,0x80115ae2
80105aee:	00 00 ef 
  initlock(&tickslock, "time");
80105af1:	68 e1 7f 10 80       	push   $0x80107fe1
80105af6:	68 a0 58 11 80       	push   $0x801158a0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105afb:	66 a3 e0 5a 11 80    	mov    %ax,0x80115ae0
80105b01:	c1 e8 10             	shr    $0x10,%eax
80105b04:	66 a3 e6 5a 11 80    	mov    %ax,0x80115ae6
  initlock(&tickslock, "time");
80105b0a:	e8 a1 ea ff ff       	call   801045b0 <initlock>
}
80105b0f:	83 c4 10             	add    $0x10,%esp
80105b12:	c9                   	leave  
80105b13:	c3                   	ret    
80105b14:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b1f:	90                   	nop

80105b20 <idtinit>:

void
idtinit(void)
{
80105b20:	f3 0f 1e fb          	endbr32 
80105b24:	55                   	push   %ebp
  pd[0] = size-1;
80105b25:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105b2a:	89 e5                	mov    %esp,%ebp
80105b2c:	83 ec 10             	sub    $0x10,%esp
80105b2f:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105b33:	b8 e0 58 11 80       	mov    $0x801158e0,%eax
80105b38:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105b3c:	c1 e8 10             	shr    $0x10,%eax
80105b3f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105b43:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105b46:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105b49:	c9                   	leave  
80105b4a:	c3                   	ret    
80105b4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b4f:	90                   	nop

80105b50 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105b50:	f3 0f 1e fb          	endbr32 
80105b54:	55                   	push   %ebp
80105b55:	89 e5                	mov    %esp,%ebp
80105b57:	57                   	push   %edi
80105b58:	56                   	push   %esi
80105b59:	53                   	push   %ebx
80105b5a:	83 ec 1c             	sub    $0x1c,%esp
80105b5d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105b60:	8b 43 30             	mov    0x30(%ebx),%eax
80105b63:	83 f8 40             	cmp    $0x40,%eax
80105b66:	0f 84 cc 01 00 00    	je     80105d38 <trap+0x1e8>
    if(myproc()->killed)
      exit();
    return;
  }

  if(tf->trapno == T_PGFLT) {
80105b6c:	83 f8 0e             	cmp    $0xe,%eax
80105b6f:	0f 84 fb 01 00 00    	je     80105d70 <trap+0x220>
    handle_page_fault();
    return;
  }

  switch(tf->trapno){
80105b75:	83 e8 20             	sub    $0x20,%eax
80105b78:	83 f8 1f             	cmp    $0x1f,%eax
80105b7b:	77 08                	ja     80105b85 <trap+0x35>
80105b7d:	3e ff 24 85 88 80 10 	notrack jmp *-0x7fef7f78(,%eax,4)
80105b84:	80 
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105b85:	e8 26 de ff ff       	call   801039b0 <myproc>
80105b8a:	8b 7b 38             	mov    0x38(%ebx),%edi
80105b8d:	85 c0                	test   %eax,%eax
80105b8f:	0f 84 02 02 00 00    	je     80105d97 <trap+0x247>
80105b95:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105b99:	0f 84 f8 01 00 00    	je     80105d97 <trap+0x247>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105b9f:	0f 20 d1             	mov    %cr2,%ecx
80105ba2:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ba5:	e8 e6 dd ff ff       	call   80103990 <cpuid>
80105baa:	8b 73 30             	mov    0x30(%ebx),%esi
80105bad:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105bb0:	8b 43 34             	mov    0x34(%ebx),%eax
80105bb3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105bb6:	e8 f5 dd ff ff       	call   801039b0 <myproc>
80105bbb:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105bbe:	e8 ed dd ff ff       	call   801039b0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105bc3:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105bc6:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105bc9:	51                   	push   %ecx
80105bca:	57                   	push   %edi
80105bcb:	52                   	push   %edx
80105bcc:	ff 75 e4             	pushl  -0x1c(%ebp)
80105bcf:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105bd0:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105bd3:	83 c6 70             	add    $0x70,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105bd6:	56                   	push   %esi
80105bd7:	ff 70 14             	pushl  0x14(%eax)
80105bda:	68 44 80 10 80       	push   $0x80108044
80105bdf:	e8 cc aa ff ff       	call   801006b0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105be4:	83 c4 20             	add    $0x20,%esp
80105be7:	e8 c4 dd ff ff       	call   801039b0 <myproc>
80105bec:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105bf3:	e8 b8 dd ff ff       	call   801039b0 <myproc>
80105bf8:	85 c0                	test   %eax,%eax
80105bfa:	74 1d                	je     80105c19 <trap+0xc9>
80105bfc:	e8 af dd ff ff       	call   801039b0 <myproc>
80105c01:	8b 50 28             	mov    0x28(%eax),%edx
80105c04:	85 d2                	test   %edx,%edx
80105c06:	74 11                	je     80105c19 <trap+0xc9>
80105c08:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105c0c:	83 e0 03             	and    $0x3,%eax
80105c0f:	66 83 f8 03          	cmp    $0x3,%ax
80105c13:	0f 84 67 01 00 00    	je     80105d80 <trap+0x230>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105c19:	e8 92 dd ff ff       	call   801039b0 <myproc>
80105c1e:	85 c0                	test   %eax,%eax
80105c20:	74 0f                	je     80105c31 <trap+0xe1>
80105c22:	e8 89 dd ff ff       	call   801039b0 <myproc>
80105c27:	83 78 10 04          	cmpl   $0x4,0x10(%eax)
80105c2b:	0f 84 ef 00 00 00    	je     80105d20 <trap+0x1d0>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c31:	e8 7a dd ff ff       	call   801039b0 <myproc>
80105c36:	85 c0                	test   %eax,%eax
80105c38:	74 1d                	je     80105c57 <trap+0x107>
80105c3a:	e8 71 dd ff ff       	call   801039b0 <myproc>
80105c3f:	8b 40 28             	mov    0x28(%eax),%eax
80105c42:	85 c0                	test   %eax,%eax
80105c44:	74 11                	je     80105c57 <trap+0x107>
80105c46:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105c4a:	83 e0 03             	and    $0x3,%eax
80105c4d:	66 83 f8 03          	cmp    $0x3,%ax
80105c51:	0f 84 0a 01 00 00    	je     80105d61 <trap+0x211>
    exit();
}
80105c57:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c5a:	5b                   	pop    %ebx
80105c5b:	5e                   	pop    %esi
80105c5c:	5f                   	pop    %edi
80105c5d:	5d                   	pop    %ebp
80105c5e:	c3                   	ret    
    ideintr();
80105c5f:	e8 7c c5 ff ff       	call   801021e0 <ideintr>
    lapiceoi();
80105c64:	e8 b7 cc ff ff       	call   80102920 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c69:	e8 42 dd ff ff       	call   801039b0 <myproc>
80105c6e:	85 c0                	test   %eax,%eax
80105c70:	75 8a                	jne    80105bfc <trap+0xac>
80105c72:	eb a5                	jmp    80105c19 <trap+0xc9>
    if(cpuid() == 0){
80105c74:	e8 17 dd ff ff       	call   80103990 <cpuid>
80105c79:	85 c0                	test   %eax,%eax
80105c7b:	75 e7                	jne    80105c64 <trap+0x114>
      acquire(&tickslock);
80105c7d:	83 ec 0c             	sub    $0xc,%esp
80105c80:	68 a0 58 11 80       	push   $0x801158a0
80105c85:	e8 a6 ea ff ff       	call   80104730 <acquire>
      wakeup(&ticks);
80105c8a:	c7 04 24 e0 60 11 80 	movl   $0x801160e0,(%esp)
      ticks++;
80105c91:	83 05 e0 60 11 80 01 	addl   $0x1,0x801160e0
      wakeup(&ticks);
80105c98:	e8 13 e6 ff ff       	call   801042b0 <wakeup>
      release(&tickslock);
80105c9d:	c7 04 24 a0 58 11 80 	movl   $0x801158a0,(%esp)
80105ca4:	e8 47 eb ff ff       	call   801047f0 <release>
80105ca9:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105cac:	eb b6                	jmp    80105c64 <trap+0x114>
    kbdintr();
80105cae:	e8 2d cb ff ff       	call   801027e0 <kbdintr>
    lapiceoi();
80105cb3:	e8 68 cc ff ff       	call   80102920 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105cb8:	e8 f3 dc ff ff       	call   801039b0 <myproc>
80105cbd:	85 c0                	test   %eax,%eax
80105cbf:	0f 85 37 ff ff ff    	jne    80105bfc <trap+0xac>
80105cc5:	e9 4f ff ff ff       	jmp    80105c19 <trap+0xc9>
    uartintr();
80105cca:	e8 61 02 00 00       	call   80105f30 <uartintr>
    lapiceoi();
80105ccf:	e8 4c cc ff ff       	call   80102920 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105cd4:	e8 d7 dc ff ff       	call   801039b0 <myproc>
80105cd9:	85 c0                	test   %eax,%eax
80105cdb:	0f 85 1b ff ff ff    	jne    80105bfc <trap+0xac>
80105ce1:	e9 33 ff ff ff       	jmp    80105c19 <trap+0xc9>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105ce6:	8b 7b 38             	mov    0x38(%ebx),%edi
80105ce9:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105ced:	e8 9e dc ff ff       	call   80103990 <cpuid>
80105cf2:	57                   	push   %edi
80105cf3:	56                   	push   %esi
80105cf4:	50                   	push   %eax
80105cf5:	68 ec 7f 10 80       	push   $0x80107fec
80105cfa:	e8 b1 a9 ff ff       	call   801006b0 <cprintf>
    lapiceoi();
80105cff:	e8 1c cc ff ff       	call   80102920 <lapiceoi>
    break;
80105d04:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d07:	e8 a4 dc ff ff       	call   801039b0 <myproc>
80105d0c:	85 c0                	test   %eax,%eax
80105d0e:	0f 85 e8 fe ff ff    	jne    80105bfc <trap+0xac>
80105d14:	e9 00 ff ff ff       	jmp    80105c19 <trap+0xc9>
80105d19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105d20:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105d24:	0f 85 07 ff ff ff    	jne    80105c31 <trap+0xe1>
    yield();
80105d2a:	e8 61 e3 ff ff       	call   80104090 <yield>
80105d2f:	e9 fd fe ff ff       	jmp    80105c31 <trap+0xe1>
80105d34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105d38:	e8 73 dc ff ff       	call   801039b0 <myproc>
80105d3d:	8b 70 28             	mov    0x28(%eax),%esi
80105d40:	85 f6                	test   %esi,%esi
80105d42:	75 4c                	jne    80105d90 <trap+0x240>
    myproc()->tf = tf;
80105d44:	e8 67 dc ff ff       	call   801039b0 <myproc>
80105d49:	89 58 1c             	mov    %ebx,0x1c(%eax)
    syscall();
80105d4c:	e8 bf ee ff ff       	call   80104c10 <syscall>
    if(myproc()->killed)
80105d51:	e8 5a dc ff ff       	call   801039b0 <myproc>
80105d56:	8b 48 28             	mov    0x28(%eax),%ecx
80105d59:	85 c9                	test   %ecx,%ecx
80105d5b:	0f 84 f6 fe ff ff    	je     80105c57 <trap+0x107>
}
80105d61:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d64:	5b                   	pop    %ebx
80105d65:	5e                   	pop    %esi
80105d66:	5f                   	pop    %edi
80105d67:	5d                   	pop    %ebp
      exit();
80105d68:	e9 73 e1 ff ff       	jmp    80103ee0 <exit>
80105d6d:	8d 76 00             	lea    0x0(%esi),%esi
}
80105d70:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d73:	5b                   	pop    %ebx
80105d74:	5e                   	pop    %esi
80105d75:	5f                   	pop    %edi
80105d76:	5d                   	pop    %ebp
    handle_page_fault();
80105d77:	e9 b4 18 00 00       	jmp    80107630 <handle_page_fault>
80105d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    exit();
80105d80:	e8 5b e1 ff ff       	call   80103ee0 <exit>
80105d85:	e9 8f fe ff ff       	jmp    80105c19 <trap+0xc9>
80105d8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105d90:	e8 4b e1 ff ff       	call   80103ee0 <exit>
80105d95:	eb ad                	jmp    80105d44 <trap+0x1f4>
80105d97:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105d9a:	e8 f1 db ff ff       	call   80103990 <cpuid>
80105d9f:	83 ec 0c             	sub    $0xc,%esp
80105da2:	56                   	push   %esi
80105da3:	57                   	push   %edi
80105da4:	50                   	push   %eax
80105da5:	ff 73 30             	pushl  0x30(%ebx)
80105da8:	68 10 80 10 80       	push   $0x80108010
80105dad:	e8 fe a8 ff ff       	call   801006b0 <cprintf>
      panic("trap");
80105db2:	83 c4 14             	add    $0x14,%esp
80105db5:	68 e6 7f 10 80       	push   $0x80107fe6
80105dba:	e8 d1 a5 ff ff       	call   80100390 <panic>
80105dbf:	90                   	nop

80105dc0 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80105dc0:	f3 0f 1e fb          	endbr32 
  if(!uart)
80105dc4:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
80105dc9:	85 c0                	test   %eax,%eax
80105dcb:	74 1b                	je     80105de8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105dcd:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105dd2:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105dd3:	a8 01                	test   $0x1,%al
80105dd5:	74 11                	je     80105de8 <uartgetc+0x28>
80105dd7:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ddc:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105ddd:	0f b6 c0             	movzbl %al,%eax
80105de0:	c3                   	ret    
80105de1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105de8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ded:	c3                   	ret    
80105dee:	66 90                	xchg   %ax,%ax

80105df0 <uartputc.part.0>:
uartputc(int c)
80105df0:	55                   	push   %ebp
80105df1:	89 e5                	mov    %esp,%ebp
80105df3:	57                   	push   %edi
80105df4:	89 c7                	mov    %eax,%edi
80105df6:	56                   	push   %esi
80105df7:	be fd 03 00 00       	mov    $0x3fd,%esi
80105dfc:	53                   	push   %ebx
80105dfd:	bb 80 00 00 00       	mov    $0x80,%ebx
80105e02:	83 ec 0c             	sub    $0xc,%esp
80105e05:	eb 1b                	jmp    80105e22 <uartputc.part.0+0x32>
80105e07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e0e:	66 90                	xchg   %ax,%ax
    microdelay(10);
80105e10:	83 ec 0c             	sub    $0xc,%esp
80105e13:	6a 0a                	push   $0xa
80105e15:	e8 26 cb ff ff       	call   80102940 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105e1a:	83 c4 10             	add    $0x10,%esp
80105e1d:	83 eb 01             	sub    $0x1,%ebx
80105e20:	74 07                	je     80105e29 <uartputc.part.0+0x39>
80105e22:	89 f2                	mov    %esi,%edx
80105e24:	ec                   	in     (%dx),%al
80105e25:	a8 20                	test   $0x20,%al
80105e27:	74 e7                	je     80105e10 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105e29:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e2e:	89 f8                	mov    %edi,%eax
80105e30:	ee                   	out    %al,(%dx)
}
80105e31:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e34:	5b                   	pop    %ebx
80105e35:	5e                   	pop    %esi
80105e36:	5f                   	pop    %edi
80105e37:	5d                   	pop    %ebp
80105e38:	c3                   	ret    
80105e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105e40 <uartinit>:
{
80105e40:	f3 0f 1e fb          	endbr32 
80105e44:	55                   	push   %ebp
80105e45:	31 c9                	xor    %ecx,%ecx
80105e47:	89 c8                	mov    %ecx,%eax
80105e49:	89 e5                	mov    %esp,%ebp
80105e4b:	57                   	push   %edi
80105e4c:	56                   	push   %esi
80105e4d:	53                   	push   %ebx
80105e4e:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105e53:	89 da                	mov    %ebx,%edx
80105e55:	83 ec 0c             	sub    $0xc,%esp
80105e58:	ee                   	out    %al,(%dx)
80105e59:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105e5e:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105e63:	89 fa                	mov    %edi,%edx
80105e65:	ee                   	out    %al,(%dx)
80105e66:	b8 0c 00 00 00       	mov    $0xc,%eax
80105e6b:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e70:	ee                   	out    %al,(%dx)
80105e71:	be f9 03 00 00       	mov    $0x3f9,%esi
80105e76:	89 c8                	mov    %ecx,%eax
80105e78:	89 f2                	mov    %esi,%edx
80105e7a:	ee                   	out    %al,(%dx)
80105e7b:	b8 03 00 00 00       	mov    $0x3,%eax
80105e80:	89 fa                	mov    %edi,%edx
80105e82:	ee                   	out    %al,(%dx)
80105e83:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105e88:	89 c8                	mov    %ecx,%eax
80105e8a:	ee                   	out    %al,(%dx)
80105e8b:	b8 01 00 00 00       	mov    $0x1,%eax
80105e90:	89 f2                	mov    %esi,%edx
80105e92:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105e93:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105e98:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105e99:	3c ff                	cmp    $0xff,%al
80105e9b:	74 52                	je     80105eef <uartinit+0xaf>
  uart = 1;
80105e9d:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
80105ea4:	00 00 00 
80105ea7:	89 da                	mov    %ebx,%edx
80105ea9:	ec                   	in     (%dx),%al
80105eaa:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105eaf:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105eb0:	83 ec 08             	sub    $0x8,%esp
80105eb3:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80105eb8:	bb 08 81 10 80       	mov    $0x80108108,%ebx
  ioapicenable(IRQ_COM1, 0);
80105ebd:	6a 00                	push   $0x0
80105ebf:	6a 04                	push   $0x4
80105ec1:	e8 6a c5 ff ff       	call   80102430 <ioapicenable>
80105ec6:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105ec9:	b8 78 00 00 00       	mov    $0x78,%eax
80105ece:	eb 04                	jmp    80105ed4 <uartinit+0x94>
80105ed0:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80105ed4:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
80105eda:	85 d2                	test   %edx,%edx
80105edc:	74 08                	je     80105ee6 <uartinit+0xa6>
    uartputc(*p);
80105ede:	0f be c0             	movsbl %al,%eax
80105ee1:	e8 0a ff ff ff       	call   80105df0 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80105ee6:	89 f0                	mov    %esi,%eax
80105ee8:	83 c3 01             	add    $0x1,%ebx
80105eeb:	84 c0                	test   %al,%al
80105eed:	75 e1                	jne    80105ed0 <uartinit+0x90>
}
80105eef:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ef2:	5b                   	pop    %ebx
80105ef3:	5e                   	pop    %esi
80105ef4:	5f                   	pop    %edi
80105ef5:	5d                   	pop    %ebp
80105ef6:	c3                   	ret    
80105ef7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105efe:	66 90                	xchg   %ax,%ax

80105f00 <uartputc>:
{
80105f00:	f3 0f 1e fb          	endbr32 
80105f04:	55                   	push   %ebp
  if(!uart)
80105f05:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
{
80105f0b:	89 e5                	mov    %esp,%ebp
80105f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80105f10:	85 d2                	test   %edx,%edx
80105f12:	74 0c                	je     80105f20 <uartputc+0x20>
}
80105f14:	5d                   	pop    %ebp
80105f15:	e9 d6 fe ff ff       	jmp    80105df0 <uartputc.part.0>
80105f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105f20:	5d                   	pop    %ebp
80105f21:	c3                   	ret    
80105f22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105f30 <uartintr>:

void
uartintr(void)
{
80105f30:	f3 0f 1e fb          	endbr32 
80105f34:	55                   	push   %ebp
80105f35:	89 e5                	mov    %esp,%ebp
80105f37:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105f3a:	68 c0 5d 10 80       	push   $0x80105dc0
80105f3f:	e8 1c a9 ff ff       	call   80100860 <consoleintr>
}
80105f44:	83 c4 10             	add    $0x10,%esp
80105f47:	c9                   	leave  
80105f48:	c3                   	ret    

80105f49 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105f49:	6a 00                	push   $0x0
  pushl $0
80105f4b:	6a 00                	push   $0x0
  jmp alltraps
80105f4d:	e9 1c fb ff ff       	jmp    80105a6e <alltraps>

80105f52 <vector1>:
.globl vector1
vector1:
  pushl $0
80105f52:	6a 00                	push   $0x0
  pushl $1
80105f54:	6a 01                	push   $0x1
  jmp alltraps
80105f56:	e9 13 fb ff ff       	jmp    80105a6e <alltraps>

80105f5b <vector2>:
.globl vector2
vector2:
  pushl $0
80105f5b:	6a 00                	push   $0x0
  pushl $2
80105f5d:	6a 02                	push   $0x2
  jmp alltraps
80105f5f:	e9 0a fb ff ff       	jmp    80105a6e <alltraps>

80105f64 <vector3>:
.globl vector3
vector3:
  pushl $0
80105f64:	6a 00                	push   $0x0
  pushl $3
80105f66:	6a 03                	push   $0x3
  jmp alltraps
80105f68:	e9 01 fb ff ff       	jmp    80105a6e <alltraps>

80105f6d <vector4>:
.globl vector4
vector4:
  pushl $0
80105f6d:	6a 00                	push   $0x0
  pushl $4
80105f6f:	6a 04                	push   $0x4
  jmp alltraps
80105f71:	e9 f8 fa ff ff       	jmp    80105a6e <alltraps>

80105f76 <vector5>:
.globl vector5
vector5:
  pushl $0
80105f76:	6a 00                	push   $0x0
  pushl $5
80105f78:	6a 05                	push   $0x5
  jmp alltraps
80105f7a:	e9 ef fa ff ff       	jmp    80105a6e <alltraps>

80105f7f <vector6>:
.globl vector6
vector6:
  pushl $0
80105f7f:	6a 00                	push   $0x0
  pushl $6
80105f81:	6a 06                	push   $0x6
  jmp alltraps
80105f83:	e9 e6 fa ff ff       	jmp    80105a6e <alltraps>

80105f88 <vector7>:
.globl vector7
vector7:
  pushl $0
80105f88:	6a 00                	push   $0x0
  pushl $7
80105f8a:	6a 07                	push   $0x7
  jmp alltraps
80105f8c:	e9 dd fa ff ff       	jmp    80105a6e <alltraps>

80105f91 <vector8>:
.globl vector8
vector8:
  pushl $8
80105f91:	6a 08                	push   $0x8
  jmp alltraps
80105f93:	e9 d6 fa ff ff       	jmp    80105a6e <alltraps>

80105f98 <vector9>:
.globl vector9
vector9:
  pushl $0
80105f98:	6a 00                	push   $0x0
  pushl $9
80105f9a:	6a 09                	push   $0x9
  jmp alltraps
80105f9c:	e9 cd fa ff ff       	jmp    80105a6e <alltraps>

80105fa1 <vector10>:
.globl vector10
vector10:
  pushl $10
80105fa1:	6a 0a                	push   $0xa
  jmp alltraps
80105fa3:	e9 c6 fa ff ff       	jmp    80105a6e <alltraps>

80105fa8 <vector11>:
.globl vector11
vector11:
  pushl $11
80105fa8:	6a 0b                	push   $0xb
  jmp alltraps
80105faa:	e9 bf fa ff ff       	jmp    80105a6e <alltraps>

80105faf <vector12>:
.globl vector12
vector12:
  pushl $12
80105faf:	6a 0c                	push   $0xc
  jmp alltraps
80105fb1:	e9 b8 fa ff ff       	jmp    80105a6e <alltraps>

80105fb6 <vector13>:
.globl vector13
vector13:
  pushl $13
80105fb6:	6a 0d                	push   $0xd
  jmp alltraps
80105fb8:	e9 b1 fa ff ff       	jmp    80105a6e <alltraps>

80105fbd <vector14>:
.globl vector14
vector14:
  pushl $14
80105fbd:	6a 0e                	push   $0xe
  jmp alltraps
80105fbf:	e9 aa fa ff ff       	jmp    80105a6e <alltraps>

80105fc4 <vector15>:
.globl vector15
vector15:
  pushl $0
80105fc4:	6a 00                	push   $0x0
  pushl $15
80105fc6:	6a 0f                	push   $0xf
  jmp alltraps
80105fc8:	e9 a1 fa ff ff       	jmp    80105a6e <alltraps>

80105fcd <vector16>:
.globl vector16
vector16:
  pushl $0
80105fcd:	6a 00                	push   $0x0
  pushl $16
80105fcf:	6a 10                	push   $0x10
  jmp alltraps
80105fd1:	e9 98 fa ff ff       	jmp    80105a6e <alltraps>

80105fd6 <vector17>:
.globl vector17
vector17:
  pushl $17
80105fd6:	6a 11                	push   $0x11
  jmp alltraps
80105fd8:	e9 91 fa ff ff       	jmp    80105a6e <alltraps>

80105fdd <vector18>:
.globl vector18
vector18:
  pushl $0
80105fdd:	6a 00                	push   $0x0
  pushl $18
80105fdf:	6a 12                	push   $0x12
  jmp alltraps
80105fe1:	e9 88 fa ff ff       	jmp    80105a6e <alltraps>

80105fe6 <vector19>:
.globl vector19
vector19:
  pushl $0
80105fe6:	6a 00                	push   $0x0
  pushl $19
80105fe8:	6a 13                	push   $0x13
  jmp alltraps
80105fea:	e9 7f fa ff ff       	jmp    80105a6e <alltraps>

80105fef <vector20>:
.globl vector20
vector20:
  pushl $0
80105fef:	6a 00                	push   $0x0
  pushl $20
80105ff1:	6a 14                	push   $0x14
  jmp alltraps
80105ff3:	e9 76 fa ff ff       	jmp    80105a6e <alltraps>

80105ff8 <vector21>:
.globl vector21
vector21:
  pushl $0
80105ff8:	6a 00                	push   $0x0
  pushl $21
80105ffa:	6a 15                	push   $0x15
  jmp alltraps
80105ffc:	e9 6d fa ff ff       	jmp    80105a6e <alltraps>

80106001 <vector22>:
.globl vector22
vector22:
  pushl $0
80106001:	6a 00                	push   $0x0
  pushl $22
80106003:	6a 16                	push   $0x16
  jmp alltraps
80106005:	e9 64 fa ff ff       	jmp    80105a6e <alltraps>

8010600a <vector23>:
.globl vector23
vector23:
  pushl $0
8010600a:	6a 00                	push   $0x0
  pushl $23
8010600c:	6a 17                	push   $0x17
  jmp alltraps
8010600e:	e9 5b fa ff ff       	jmp    80105a6e <alltraps>

80106013 <vector24>:
.globl vector24
vector24:
  pushl $0
80106013:	6a 00                	push   $0x0
  pushl $24
80106015:	6a 18                	push   $0x18
  jmp alltraps
80106017:	e9 52 fa ff ff       	jmp    80105a6e <alltraps>

8010601c <vector25>:
.globl vector25
vector25:
  pushl $0
8010601c:	6a 00                	push   $0x0
  pushl $25
8010601e:	6a 19                	push   $0x19
  jmp alltraps
80106020:	e9 49 fa ff ff       	jmp    80105a6e <alltraps>

80106025 <vector26>:
.globl vector26
vector26:
  pushl $0
80106025:	6a 00                	push   $0x0
  pushl $26
80106027:	6a 1a                	push   $0x1a
  jmp alltraps
80106029:	e9 40 fa ff ff       	jmp    80105a6e <alltraps>

8010602e <vector27>:
.globl vector27
vector27:
  pushl $0
8010602e:	6a 00                	push   $0x0
  pushl $27
80106030:	6a 1b                	push   $0x1b
  jmp alltraps
80106032:	e9 37 fa ff ff       	jmp    80105a6e <alltraps>

80106037 <vector28>:
.globl vector28
vector28:
  pushl $0
80106037:	6a 00                	push   $0x0
  pushl $28
80106039:	6a 1c                	push   $0x1c
  jmp alltraps
8010603b:	e9 2e fa ff ff       	jmp    80105a6e <alltraps>

80106040 <vector29>:
.globl vector29
vector29:
  pushl $0
80106040:	6a 00                	push   $0x0
  pushl $29
80106042:	6a 1d                	push   $0x1d
  jmp alltraps
80106044:	e9 25 fa ff ff       	jmp    80105a6e <alltraps>

80106049 <vector30>:
.globl vector30
vector30:
  pushl $0
80106049:	6a 00                	push   $0x0
  pushl $30
8010604b:	6a 1e                	push   $0x1e
  jmp alltraps
8010604d:	e9 1c fa ff ff       	jmp    80105a6e <alltraps>

80106052 <vector31>:
.globl vector31
vector31:
  pushl $0
80106052:	6a 00                	push   $0x0
  pushl $31
80106054:	6a 1f                	push   $0x1f
  jmp alltraps
80106056:	e9 13 fa ff ff       	jmp    80105a6e <alltraps>

8010605b <vector32>:
.globl vector32
vector32:
  pushl $0
8010605b:	6a 00                	push   $0x0
  pushl $32
8010605d:	6a 20                	push   $0x20
  jmp alltraps
8010605f:	e9 0a fa ff ff       	jmp    80105a6e <alltraps>

80106064 <vector33>:
.globl vector33
vector33:
  pushl $0
80106064:	6a 00                	push   $0x0
  pushl $33
80106066:	6a 21                	push   $0x21
  jmp alltraps
80106068:	e9 01 fa ff ff       	jmp    80105a6e <alltraps>

8010606d <vector34>:
.globl vector34
vector34:
  pushl $0
8010606d:	6a 00                	push   $0x0
  pushl $34
8010606f:	6a 22                	push   $0x22
  jmp alltraps
80106071:	e9 f8 f9 ff ff       	jmp    80105a6e <alltraps>

80106076 <vector35>:
.globl vector35
vector35:
  pushl $0
80106076:	6a 00                	push   $0x0
  pushl $35
80106078:	6a 23                	push   $0x23
  jmp alltraps
8010607a:	e9 ef f9 ff ff       	jmp    80105a6e <alltraps>

8010607f <vector36>:
.globl vector36
vector36:
  pushl $0
8010607f:	6a 00                	push   $0x0
  pushl $36
80106081:	6a 24                	push   $0x24
  jmp alltraps
80106083:	e9 e6 f9 ff ff       	jmp    80105a6e <alltraps>

80106088 <vector37>:
.globl vector37
vector37:
  pushl $0
80106088:	6a 00                	push   $0x0
  pushl $37
8010608a:	6a 25                	push   $0x25
  jmp alltraps
8010608c:	e9 dd f9 ff ff       	jmp    80105a6e <alltraps>

80106091 <vector38>:
.globl vector38
vector38:
  pushl $0
80106091:	6a 00                	push   $0x0
  pushl $38
80106093:	6a 26                	push   $0x26
  jmp alltraps
80106095:	e9 d4 f9 ff ff       	jmp    80105a6e <alltraps>

8010609a <vector39>:
.globl vector39
vector39:
  pushl $0
8010609a:	6a 00                	push   $0x0
  pushl $39
8010609c:	6a 27                	push   $0x27
  jmp alltraps
8010609e:	e9 cb f9 ff ff       	jmp    80105a6e <alltraps>

801060a3 <vector40>:
.globl vector40
vector40:
  pushl $0
801060a3:	6a 00                	push   $0x0
  pushl $40
801060a5:	6a 28                	push   $0x28
  jmp alltraps
801060a7:	e9 c2 f9 ff ff       	jmp    80105a6e <alltraps>

801060ac <vector41>:
.globl vector41
vector41:
  pushl $0
801060ac:	6a 00                	push   $0x0
  pushl $41
801060ae:	6a 29                	push   $0x29
  jmp alltraps
801060b0:	e9 b9 f9 ff ff       	jmp    80105a6e <alltraps>

801060b5 <vector42>:
.globl vector42
vector42:
  pushl $0
801060b5:	6a 00                	push   $0x0
  pushl $42
801060b7:	6a 2a                	push   $0x2a
  jmp alltraps
801060b9:	e9 b0 f9 ff ff       	jmp    80105a6e <alltraps>

801060be <vector43>:
.globl vector43
vector43:
  pushl $0
801060be:	6a 00                	push   $0x0
  pushl $43
801060c0:	6a 2b                	push   $0x2b
  jmp alltraps
801060c2:	e9 a7 f9 ff ff       	jmp    80105a6e <alltraps>

801060c7 <vector44>:
.globl vector44
vector44:
  pushl $0
801060c7:	6a 00                	push   $0x0
  pushl $44
801060c9:	6a 2c                	push   $0x2c
  jmp alltraps
801060cb:	e9 9e f9 ff ff       	jmp    80105a6e <alltraps>

801060d0 <vector45>:
.globl vector45
vector45:
  pushl $0
801060d0:	6a 00                	push   $0x0
  pushl $45
801060d2:	6a 2d                	push   $0x2d
  jmp alltraps
801060d4:	e9 95 f9 ff ff       	jmp    80105a6e <alltraps>

801060d9 <vector46>:
.globl vector46
vector46:
  pushl $0
801060d9:	6a 00                	push   $0x0
  pushl $46
801060db:	6a 2e                	push   $0x2e
  jmp alltraps
801060dd:	e9 8c f9 ff ff       	jmp    80105a6e <alltraps>

801060e2 <vector47>:
.globl vector47
vector47:
  pushl $0
801060e2:	6a 00                	push   $0x0
  pushl $47
801060e4:	6a 2f                	push   $0x2f
  jmp alltraps
801060e6:	e9 83 f9 ff ff       	jmp    80105a6e <alltraps>

801060eb <vector48>:
.globl vector48
vector48:
  pushl $0
801060eb:	6a 00                	push   $0x0
  pushl $48
801060ed:	6a 30                	push   $0x30
  jmp alltraps
801060ef:	e9 7a f9 ff ff       	jmp    80105a6e <alltraps>

801060f4 <vector49>:
.globl vector49
vector49:
  pushl $0
801060f4:	6a 00                	push   $0x0
  pushl $49
801060f6:	6a 31                	push   $0x31
  jmp alltraps
801060f8:	e9 71 f9 ff ff       	jmp    80105a6e <alltraps>

801060fd <vector50>:
.globl vector50
vector50:
  pushl $0
801060fd:	6a 00                	push   $0x0
  pushl $50
801060ff:	6a 32                	push   $0x32
  jmp alltraps
80106101:	e9 68 f9 ff ff       	jmp    80105a6e <alltraps>

80106106 <vector51>:
.globl vector51
vector51:
  pushl $0
80106106:	6a 00                	push   $0x0
  pushl $51
80106108:	6a 33                	push   $0x33
  jmp alltraps
8010610a:	e9 5f f9 ff ff       	jmp    80105a6e <alltraps>

8010610f <vector52>:
.globl vector52
vector52:
  pushl $0
8010610f:	6a 00                	push   $0x0
  pushl $52
80106111:	6a 34                	push   $0x34
  jmp alltraps
80106113:	e9 56 f9 ff ff       	jmp    80105a6e <alltraps>

80106118 <vector53>:
.globl vector53
vector53:
  pushl $0
80106118:	6a 00                	push   $0x0
  pushl $53
8010611a:	6a 35                	push   $0x35
  jmp alltraps
8010611c:	e9 4d f9 ff ff       	jmp    80105a6e <alltraps>

80106121 <vector54>:
.globl vector54
vector54:
  pushl $0
80106121:	6a 00                	push   $0x0
  pushl $54
80106123:	6a 36                	push   $0x36
  jmp alltraps
80106125:	e9 44 f9 ff ff       	jmp    80105a6e <alltraps>

8010612a <vector55>:
.globl vector55
vector55:
  pushl $0
8010612a:	6a 00                	push   $0x0
  pushl $55
8010612c:	6a 37                	push   $0x37
  jmp alltraps
8010612e:	e9 3b f9 ff ff       	jmp    80105a6e <alltraps>

80106133 <vector56>:
.globl vector56
vector56:
  pushl $0
80106133:	6a 00                	push   $0x0
  pushl $56
80106135:	6a 38                	push   $0x38
  jmp alltraps
80106137:	e9 32 f9 ff ff       	jmp    80105a6e <alltraps>

8010613c <vector57>:
.globl vector57
vector57:
  pushl $0
8010613c:	6a 00                	push   $0x0
  pushl $57
8010613e:	6a 39                	push   $0x39
  jmp alltraps
80106140:	e9 29 f9 ff ff       	jmp    80105a6e <alltraps>

80106145 <vector58>:
.globl vector58
vector58:
  pushl $0
80106145:	6a 00                	push   $0x0
  pushl $58
80106147:	6a 3a                	push   $0x3a
  jmp alltraps
80106149:	e9 20 f9 ff ff       	jmp    80105a6e <alltraps>

8010614e <vector59>:
.globl vector59
vector59:
  pushl $0
8010614e:	6a 00                	push   $0x0
  pushl $59
80106150:	6a 3b                	push   $0x3b
  jmp alltraps
80106152:	e9 17 f9 ff ff       	jmp    80105a6e <alltraps>

80106157 <vector60>:
.globl vector60
vector60:
  pushl $0
80106157:	6a 00                	push   $0x0
  pushl $60
80106159:	6a 3c                	push   $0x3c
  jmp alltraps
8010615b:	e9 0e f9 ff ff       	jmp    80105a6e <alltraps>

80106160 <vector61>:
.globl vector61
vector61:
  pushl $0
80106160:	6a 00                	push   $0x0
  pushl $61
80106162:	6a 3d                	push   $0x3d
  jmp alltraps
80106164:	e9 05 f9 ff ff       	jmp    80105a6e <alltraps>

80106169 <vector62>:
.globl vector62
vector62:
  pushl $0
80106169:	6a 00                	push   $0x0
  pushl $62
8010616b:	6a 3e                	push   $0x3e
  jmp alltraps
8010616d:	e9 fc f8 ff ff       	jmp    80105a6e <alltraps>

80106172 <vector63>:
.globl vector63
vector63:
  pushl $0
80106172:	6a 00                	push   $0x0
  pushl $63
80106174:	6a 3f                	push   $0x3f
  jmp alltraps
80106176:	e9 f3 f8 ff ff       	jmp    80105a6e <alltraps>

8010617b <vector64>:
.globl vector64
vector64:
  pushl $0
8010617b:	6a 00                	push   $0x0
  pushl $64
8010617d:	6a 40                	push   $0x40
  jmp alltraps
8010617f:	e9 ea f8 ff ff       	jmp    80105a6e <alltraps>

80106184 <vector65>:
.globl vector65
vector65:
  pushl $0
80106184:	6a 00                	push   $0x0
  pushl $65
80106186:	6a 41                	push   $0x41
  jmp alltraps
80106188:	e9 e1 f8 ff ff       	jmp    80105a6e <alltraps>

8010618d <vector66>:
.globl vector66
vector66:
  pushl $0
8010618d:	6a 00                	push   $0x0
  pushl $66
8010618f:	6a 42                	push   $0x42
  jmp alltraps
80106191:	e9 d8 f8 ff ff       	jmp    80105a6e <alltraps>

80106196 <vector67>:
.globl vector67
vector67:
  pushl $0
80106196:	6a 00                	push   $0x0
  pushl $67
80106198:	6a 43                	push   $0x43
  jmp alltraps
8010619a:	e9 cf f8 ff ff       	jmp    80105a6e <alltraps>

8010619f <vector68>:
.globl vector68
vector68:
  pushl $0
8010619f:	6a 00                	push   $0x0
  pushl $68
801061a1:	6a 44                	push   $0x44
  jmp alltraps
801061a3:	e9 c6 f8 ff ff       	jmp    80105a6e <alltraps>

801061a8 <vector69>:
.globl vector69
vector69:
  pushl $0
801061a8:	6a 00                	push   $0x0
  pushl $69
801061aa:	6a 45                	push   $0x45
  jmp alltraps
801061ac:	e9 bd f8 ff ff       	jmp    80105a6e <alltraps>

801061b1 <vector70>:
.globl vector70
vector70:
  pushl $0
801061b1:	6a 00                	push   $0x0
  pushl $70
801061b3:	6a 46                	push   $0x46
  jmp alltraps
801061b5:	e9 b4 f8 ff ff       	jmp    80105a6e <alltraps>

801061ba <vector71>:
.globl vector71
vector71:
  pushl $0
801061ba:	6a 00                	push   $0x0
  pushl $71
801061bc:	6a 47                	push   $0x47
  jmp alltraps
801061be:	e9 ab f8 ff ff       	jmp    80105a6e <alltraps>

801061c3 <vector72>:
.globl vector72
vector72:
  pushl $0
801061c3:	6a 00                	push   $0x0
  pushl $72
801061c5:	6a 48                	push   $0x48
  jmp alltraps
801061c7:	e9 a2 f8 ff ff       	jmp    80105a6e <alltraps>

801061cc <vector73>:
.globl vector73
vector73:
  pushl $0
801061cc:	6a 00                	push   $0x0
  pushl $73
801061ce:	6a 49                	push   $0x49
  jmp alltraps
801061d0:	e9 99 f8 ff ff       	jmp    80105a6e <alltraps>

801061d5 <vector74>:
.globl vector74
vector74:
  pushl $0
801061d5:	6a 00                	push   $0x0
  pushl $74
801061d7:	6a 4a                	push   $0x4a
  jmp alltraps
801061d9:	e9 90 f8 ff ff       	jmp    80105a6e <alltraps>

801061de <vector75>:
.globl vector75
vector75:
  pushl $0
801061de:	6a 00                	push   $0x0
  pushl $75
801061e0:	6a 4b                	push   $0x4b
  jmp alltraps
801061e2:	e9 87 f8 ff ff       	jmp    80105a6e <alltraps>

801061e7 <vector76>:
.globl vector76
vector76:
  pushl $0
801061e7:	6a 00                	push   $0x0
  pushl $76
801061e9:	6a 4c                	push   $0x4c
  jmp alltraps
801061eb:	e9 7e f8 ff ff       	jmp    80105a6e <alltraps>

801061f0 <vector77>:
.globl vector77
vector77:
  pushl $0
801061f0:	6a 00                	push   $0x0
  pushl $77
801061f2:	6a 4d                	push   $0x4d
  jmp alltraps
801061f4:	e9 75 f8 ff ff       	jmp    80105a6e <alltraps>

801061f9 <vector78>:
.globl vector78
vector78:
  pushl $0
801061f9:	6a 00                	push   $0x0
  pushl $78
801061fb:	6a 4e                	push   $0x4e
  jmp alltraps
801061fd:	e9 6c f8 ff ff       	jmp    80105a6e <alltraps>

80106202 <vector79>:
.globl vector79
vector79:
  pushl $0
80106202:	6a 00                	push   $0x0
  pushl $79
80106204:	6a 4f                	push   $0x4f
  jmp alltraps
80106206:	e9 63 f8 ff ff       	jmp    80105a6e <alltraps>

8010620b <vector80>:
.globl vector80
vector80:
  pushl $0
8010620b:	6a 00                	push   $0x0
  pushl $80
8010620d:	6a 50                	push   $0x50
  jmp alltraps
8010620f:	e9 5a f8 ff ff       	jmp    80105a6e <alltraps>

80106214 <vector81>:
.globl vector81
vector81:
  pushl $0
80106214:	6a 00                	push   $0x0
  pushl $81
80106216:	6a 51                	push   $0x51
  jmp alltraps
80106218:	e9 51 f8 ff ff       	jmp    80105a6e <alltraps>

8010621d <vector82>:
.globl vector82
vector82:
  pushl $0
8010621d:	6a 00                	push   $0x0
  pushl $82
8010621f:	6a 52                	push   $0x52
  jmp alltraps
80106221:	e9 48 f8 ff ff       	jmp    80105a6e <alltraps>

80106226 <vector83>:
.globl vector83
vector83:
  pushl $0
80106226:	6a 00                	push   $0x0
  pushl $83
80106228:	6a 53                	push   $0x53
  jmp alltraps
8010622a:	e9 3f f8 ff ff       	jmp    80105a6e <alltraps>

8010622f <vector84>:
.globl vector84
vector84:
  pushl $0
8010622f:	6a 00                	push   $0x0
  pushl $84
80106231:	6a 54                	push   $0x54
  jmp alltraps
80106233:	e9 36 f8 ff ff       	jmp    80105a6e <alltraps>

80106238 <vector85>:
.globl vector85
vector85:
  pushl $0
80106238:	6a 00                	push   $0x0
  pushl $85
8010623a:	6a 55                	push   $0x55
  jmp alltraps
8010623c:	e9 2d f8 ff ff       	jmp    80105a6e <alltraps>

80106241 <vector86>:
.globl vector86
vector86:
  pushl $0
80106241:	6a 00                	push   $0x0
  pushl $86
80106243:	6a 56                	push   $0x56
  jmp alltraps
80106245:	e9 24 f8 ff ff       	jmp    80105a6e <alltraps>

8010624a <vector87>:
.globl vector87
vector87:
  pushl $0
8010624a:	6a 00                	push   $0x0
  pushl $87
8010624c:	6a 57                	push   $0x57
  jmp alltraps
8010624e:	e9 1b f8 ff ff       	jmp    80105a6e <alltraps>

80106253 <vector88>:
.globl vector88
vector88:
  pushl $0
80106253:	6a 00                	push   $0x0
  pushl $88
80106255:	6a 58                	push   $0x58
  jmp alltraps
80106257:	e9 12 f8 ff ff       	jmp    80105a6e <alltraps>

8010625c <vector89>:
.globl vector89
vector89:
  pushl $0
8010625c:	6a 00                	push   $0x0
  pushl $89
8010625e:	6a 59                	push   $0x59
  jmp alltraps
80106260:	e9 09 f8 ff ff       	jmp    80105a6e <alltraps>

80106265 <vector90>:
.globl vector90
vector90:
  pushl $0
80106265:	6a 00                	push   $0x0
  pushl $90
80106267:	6a 5a                	push   $0x5a
  jmp alltraps
80106269:	e9 00 f8 ff ff       	jmp    80105a6e <alltraps>

8010626e <vector91>:
.globl vector91
vector91:
  pushl $0
8010626e:	6a 00                	push   $0x0
  pushl $91
80106270:	6a 5b                	push   $0x5b
  jmp alltraps
80106272:	e9 f7 f7 ff ff       	jmp    80105a6e <alltraps>

80106277 <vector92>:
.globl vector92
vector92:
  pushl $0
80106277:	6a 00                	push   $0x0
  pushl $92
80106279:	6a 5c                	push   $0x5c
  jmp alltraps
8010627b:	e9 ee f7 ff ff       	jmp    80105a6e <alltraps>

80106280 <vector93>:
.globl vector93
vector93:
  pushl $0
80106280:	6a 00                	push   $0x0
  pushl $93
80106282:	6a 5d                	push   $0x5d
  jmp alltraps
80106284:	e9 e5 f7 ff ff       	jmp    80105a6e <alltraps>

80106289 <vector94>:
.globl vector94
vector94:
  pushl $0
80106289:	6a 00                	push   $0x0
  pushl $94
8010628b:	6a 5e                	push   $0x5e
  jmp alltraps
8010628d:	e9 dc f7 ff ff       	jmp    80105a6e <alltraps>

80106292 <vector95>:
.globl vector95
vector95:
  pushl $0
80106292:	6a 00                	push   $0x0
  pushl $95
80106294:	6a 5f                	push   $0x5f
  jmp alltraps
80106296:	e9 d3 f7 ff ff       	jmp    80105a6e <alltraps>

8010629b <vector96>:
.globl vector96
vector96:
  pushl $0
8010629b:	6a 00                	push   $0x0
  pushl $96
8010629d:	6a 60                	push   $0x60
  jmp alltraps
8010629f:	e9 ca f7 ff ff       	jmp    80105a6e <alltraps>

801062a4 <vector97>:
.globl vector97
vector97:
  pushl $0
801062a4:	6a 00                	push   $0x0
  pushl $97
801062a6:	6a 61                	push   $0x61
  jmp alltraps
801062a8:	e9 c1 f7 ff ff       	jmp    80105a6e <alltraps>

801062ad <vector98>:
.globl vector98
vector98:
  pushl $0
801062ad:	6a 00                	push   $0x0
  pushl $98
801062af:	6a 62                	push   $0x62
  jmp alltraps
801062b1:	e9 b8 f7 ff ff       	jmp    80105a6e <alltraps>

801062b6 <vector99>:
.globl vector99
vector99:
  pushl $0
801062b6:	6a 00                	push   $0x0
  pushl $99
801062b8:	6a 63                	push   $0x63
  jmp alltraps
801062ba:	e9 af f7 ff ff       	jmp    80105a6e <alltraps>

801062bf <vector100>:
.globl vector100
vector100:
  pushl $0
801062bf:	6a 00                	push   $0x0
  pushl $100
801062c1:	6a 64                	push   $0x64
  jmp alltraps
801062c3:	e9 a6 f7 ff ff       	jmp    80105a6e <alltraps>

801062c8 <vector101>:
.globl vector101
vector101:
  pushl $0
801062c8:	6a 00                	push   $0x0
  pushl $101
801062ca:	6a 65                	push   $0x65
  jmp alltraps
801062cc:	e9 9d f7 ff ff       	jmp    80105a6e <alltraps>

801062d1 <vector102>:
.globl vector102
vector102:
  pushl $0
801062d1:	6a 00                	push   $0x0
  pushl $102
801062d3:	6a 66                	push   $0x66
  jmp alltraps
801062d5:	e9 94 f7 ff ff       	jmp    80105a6e <alltraps>

801062da <vector103>:
.globl vector103
vector103:
  pushl $0
801062da:	6a 00                	push   $0x0
  pushl $103
801062dc:	6a 67                	push   $0x67
  jmp alltraps
801062de:	e9 8b f7 ff ff       	jmp    80105a6e <alltraps>

801062e3 <vector104>:
.globl vector104
vector104:
  pushl $0
801062e3:	6a 00                	push   $0x0
  pushl $104
801062e5:	6a 68                	push   $0x68
  jmp alltraps
801062e7:	e9 82 f7 ff ff       	jmp    80105a6e <alltraps>

801062ec <vector105>:
.globl vector105
vector105:
  pushl $0
801062ec:	6a 00                	push   $0x0
  pushl $105
801062ee:	6a 69                	push   $0x69
  jmp alltraps
801062f0:	e9 79 f7 ff ff       	jmp    80105a6e <alltraps>

801062f5 <vector106>:
.globl vector106
vector106:
  pushl $0
801062f5:	6a 00                	push   $0x0
  pushl $106
801062f7:	6a 6a                	push   $0x6a
  jmp alltraps
801062f9:	e9 70 f7 ff ff       	jmp    80105a6e <alltraps>

801062fe <vector107>:
.globl vector107
vector107:
  pushl $0
801062fe:	6a 00                	push   $0x0
  pushl $107
80106300:	6a 6b                	push   $0x6b
  jmp alltraps
80106302:	e9 67 f7 ff ff       	jmp    80105a6e <alltraps>

80106307 <vector108>:
.globl vector108
vector108:
  pushl $0
80106307:	6a 00                	push   $0x0
  pushl $108
80106309:	6a 6c                	push   $0x6c
  jmp alltraps
8010630b:	e9 5e f7 ff ff       	jmp    80105a6e <alltraps>

80106310 <vector109>:
.globl vector109
vector109:
  pushl $0
80106310:	6a 00                	push   $0x0
  pushl $109
80106312:	6a 6d                	push   $0x6d
  jmp alltraps
80106314:	e9 55 f7 ff ff       	jmp    80105a6e <alltraps>

80106319 <vector110>:
.globl vector110
vector110:
  pushl $0
80106319:	6a 00                	push   $0x0
  pushl $110
8010631b:	6a 6e                	push   $0x6e
  jmp alltraps
8010631d:	e9 4c f7 ff ff       	jmp    80105a6e <alltraps>

80106322 <vector111>:
.globl vector111
vector111:
  pushl $0
80106322:	6a 00                	push   $0x0
  pushl $111
80106324:	6a 6f                	push   $0x6f
  jmp alltraps
80106326:	e9 43 f7 ff ff       	jmp    80105a6e <alltraps>

8010632b <vector112>:
.globl vector112
vector112:
  pushl $0
8010632b:	6a 00                	push   $0x0
  pushl $112
8010632d:	6a 70                	push   $0x70
  jmp alltraps
8010632f:	e9 3a f7 ff ff       	jmp    80105a6e <alltraps>

80106334 <vector113>:
.globl vector113
vector113:
  pushl $0
80106334:	6a 00                	push   $0x0
  pushl $113
80106336:	6a 71                	push   $0x71
  jmp alltraps
80106338:	e9 31 f7 ff ff       	jmp    80105a6e <alltraps>

8010633d <vector114>:
.globl vector114
vector114:
  pushl $0
8010633d:	6a 00                	push   $0x0
  pushl $114
8010633f:	6a 72                	push   $0x72
  jmp alltraps
80106341:	e9 28 f7 ff ff       	jmp    80105a6e <alltraps>

80106346 <vector115>:
.globl vector115
vector115:
  pushl $0
80106346:	6a 00                	push   $0x0
  pushl $115
80106348:	6a 73                	push   $0x73
  jmp alltraps
8010634a:	e9 1f f7 ff ff       	jmp    80105a6e <alltraps>

8010634f <vector116>:
.globl vector116
vector116:
  pushl $0
8010634f:	6a 00                	push   $0x0
  pushl $116
80106351:	6a 74                	push   $0x74
  jmp alltraps
80106353:	e9 16 f7 ff ff       	jmp    80105a6e <alltraps>

80106358 <vector117>:
.globl vector117
vector117:
  pushl $0
80106358:	6a 00                	push   $0x0
  pushl $117
8010635a:	6a 75                	push   $0x75
  jmp alltraps
8010635c:	e9 0d f7 ff ff       	jmp    80105a6e <alltraps>

80106361 <vector118>:
.globl vector118
vector118:
  pushl $0
80106361:	6a 00                	push   $0x0
  pushl $118
80106363:	6a 76                	push   $0x76
  jmp alltraps
80106365:	e9 04 f7 ff ff       	jmp    80105a6e <alltraps>

8010636a <vector119>:
.globl vector119
vector119:
  pushl $0
8010636a:	6a 00                	push   $0x0
  pushl $119
8010636c:	6a 77                	push   $0x77
  jmp alltraps
8010636e:	e9 fb f6 ff ff       	jmp    80105a6e <alltraps>

80106373 <vector120>:
.globl vector120
vector120:
  pushl $0
80106373:	6a 00                	push   $0x0
  pushl $120
80106375:	6a 78                	push   $0x78
  jmp alltraps
80106377:	e9 f2 f6 ff ff       	jmp    80105a6e <alltraps>

8010637c <vector121>:
.globl vector121
vector121:
  pushl $0
8010637c:	6a 00                	push   $0x0
  pushl $121
8010637e:	6a 79                	push   $0x79
  jmp alltraps
80106380:	e9 e9 f6 ff ff       	jmp    80105a6e <alltraps>

80106385 <vector122>:
.globl vector122
vector122:
  pushl $0
80106385:	6a 00                	push   $0x0
  pushl $122
80106387:	6a 7a                	push   $0x7a
  jmp alltraps
80106389:	e9 e0 f6 ff ff       	jmp    80105a6e <alltraps>

8010638e <vector123>:
.globl vector123
vector123:
  pushl $0
8010638e:	6a 00                	push   $0x0
  pushl $123
80106390:	6a 7b                	push   $0x7b
  jmp alltraps
80106392:	e9 d7 f6 ff ff       	jmp    80105a6e <alltraps>

80106397 <vector124>:
.globl vector124
vector124:
  pushl $0
80106397:	6a 00                	push   $0x0
  pushl $124
80106399:	6a 7c                	push   $0x7c
  jmp alltraps
8010639b:	e9 ce f6 ff ff       	jmp    80105a6e <alltraps>

801063a0 <vector125>:
.globl vector125
vector125:
  pushl $0
801063a0:	6a 00                	push   $0x0
  pushl $125
801063a2:	6a 7d                	push   $0x7d
  jmp alltraps
801063a4:	e9 c5 f6 ff ff       	jmp    80105a6e <alltraps>

801063a9 <vector126>:
.globl vector126
vector126:
  pushl $0
801063a9:	6a 00                	push   $0x0
  pushl $126
801063ab:	6a 7e                	push   $0x7e
  jmp alltraps
801063ad:	e9 bc f6 ff ff       	jmp    80105a6e <alltraps>

801063b2 <vector127>:
.globl vector127
vector127:
  pushl $0
801063b2:	6a 00                	push   $0x0
  pushl $127
801063b4:	6a 7f                	push   $0x7f
  jmp alltraps
801063b6:	e9 b3 f6 ff ff       	jmp    80105a6e <alltraps>

801063bb <vector128>:
.globl vector128
vector128:
  pushl $0
801063bb:	6a 00                	push   $0x0
  pushl $128
801063bd:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801063c2:	e9 a7 f6 ff ff       	jmp    80105a6e <alltraps>

801063c7 <vector129>:
.globl vector129
vector129:
  pushl $0
801063c7:	6a 00                	push   $0x0
  pushl $129
801063c9:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801063ce:	e9 9b f6 ff ff       	jmp    80105a6e <alltraps>

801063d3 <vector130>:
.globl vector130
vector130:
  pushl $0
801063d3:	6a 00                	push   $0x0
  pushl $130
801063d5:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801063da:	e9 8f f6 ff ff       	jmp    80105a6e <alltraps>

801063df <vector131>:
.globl vector131
vector131:
  pushl $0
801063df:	6a 00                	push   $0x0
  pushl $131
801063e1:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801063e6:	e9 83 f6 ff ff       	jmp    80105a6e <alltraps>

801063eb <vector132>:
.globl vector132
vector132:
  pushl $0
801063eb:	6a 00                	push   $0x0
  pushl $132
801063ed:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801063f2:	e9 77 f6 ff ff       	jmp    80105a6e <alltraps>

801063f7 <vector133>:
.globl vector133
vector133:
  pushl $0
801063f7:	6a 00                	push   $0x0
  pushl $133
801063f9:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801063fe:	e9 6b f6 ff ff       	jmp    80105a6e <alltraps>

80106403 <vector134>:
.globl vector134
vector134:
  pushl $0
80106403:	6a 00                	push   $0x0
  pushl $134
80106405:	68 86 00 00 00       	push   $0x86
  jmp alltraps
8010640a:	e9 5f f6 ff ff       	jmp    80105a6e <alltraps>

8010640f <vector135>:
.globl vector135
vector135:
  pushl $0
8010640f:	6a 00                	push   $0x0
  pushl $135
80106411:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106416:	e9 53 f6 ff ff       	jmp    80105a6e <alltraps>

8010641b <vector136>:
.globl vector136
vector136:
  pushl $0
8010641b:	6a 00                	push   $0x0
  pushl $136
8010641d:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106422:	e9 47 f6 ff ff       	jmp    80105a6e <alltraps>

80106427 <vector137>:
.globl vector137
vector137:
  pushl $0
80106427:	6a 00                	push   $0x0
  pushl $137
80106429:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010642e:	e9 3b f6 ff ff       	jmp    80105a6e <alltraps>

80106433 <vector138>:
.globl vector138
vector138:
  pushl $0
80106433:	6a 00                	push   $0x0
  pushl $138
80106435:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
8010643a:	e9 2f f6 ff ff       	jmp    80105a6e <alltraps>

8010643f <vector139>:
.globl vector139
vector139:
  pushl $0
8010643f:	6a 00                	push   $0x0
  pushl $139
80106441:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106446:	e9 23 f6 ff ff       	jmp    80105a6e <alltraps>

8010644b <vector140>:
.globl vector140
vector140:
  pushl $0
8010644b:	6a 00                	push   $0x0
  pushl $140
8010644d:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106452:	e9 17 f6 ff ff       	jmp    80105a6e <alltraps>

80106457 <vector141>:
.globl vector141
vector141:
  pushl $0
80106457:	6a 00                	push   $0x0
  pushl $141
80106459:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010645e:	e9 0b f6 ff ff       	jmp    80105a6e <alltraps>

80106463 <vector142>:
.globl vector142
vector142:
  pushl $0
80106463:	6a 00                	push   $0x0
  pushl $142
80106465:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
8010646a:	e9 ff f5 ff ff       	jmp    80105a6e <alltraps>

8010646f <vector143>:
.globl vector143
vector143:
  pushl $0
8010646f:	6a 00                	push   $0x0
  pushl $143
80106471:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106476:	e9 f3 f5 ff ff       	jmp    80105a6e <alltraps>

8010647b <vector144>:
.globl vector144
vector144:
  pushl $0
8010647b:	6a 00                	push   $0x0
  pushl $144
8010647d:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106482:	e9 e7 f5 ff ff       	jmp    80105a6e <alltraps>

80106487 <vector145>:
.globl vector145
vector145:
  pushl $0
80106487:	6a 00                	push   $0x0
  pushl $145
80106489:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010648e:	e9 db f5 ff ff       	jmp    80105a6e <alltraps>

80106493 <vector146>:
.globl vector146
vector146:
  pushl $0
80106493:	6a 00                	push   $0x0
  pushl $146
80106495:	68 92 00 00 00       	push   $0x92
  jmp alltraps
8010649a:	e9 cf f5 ff ff       	jmp    80105a6e <alltraps>

8010649f <vector147>:
.globl vector147
vector147:
  pushl $0
8010649f:	6a 00                	push   $0x0
  pushl $147
801064a1:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801064a6:	e9 c3 f5 ff ff       	jmp    80105a6e <alltraps>

801064ab <vector148>:
.globl vector148
vector148:
  pushl $0
801064ab:	6a 00                	push   $0x0
  pushl $148
801064ad:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801064b2:	e9 b7 f5 ff ff       	jmp    80105a6e <alltraps>

801064b7 <vector149>:
.globl vector149
vector149:
  pushl $0
801064b7:	6a 00                	push   $0x0
  pushl $149
801064b9:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801064be:	e9 ab f5 ff ff       	jmp    80105a6e <alltraps>

801064c3 <vector150>:
.globl vector150
vector150:
  pushl $0
801064c3:	6a 00                	push   $0x0
  pushl $150
801064c5:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801064ca:	e9 9f f5 ff ff       	jmp    80105a6e <alltraps>

801064cf <vector151>:
.globl vector151
vector151:
  pushl $0
801064cf:	6a 00                	push   $0x0
  pushl $151
801064d1:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801064d6:	e9 93 f5 ff ff       	jmp    80105a6e <alltraps>

801064db <vector152>:
.globl vector152
vector152:
  pushl $0
801064db:	6a 00                	push   $0x0
  pushl $152
801064dd:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801064e2:	e9 87 f5 ff ff       	jmp    80105a6e <alltraps>

801064e7 <vector153>:
.globl vector153
vector153:
  pushl $0
801064e7:	6a 00                	push   $0x0
  pushl $153
801064e9:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801064ee:	e9 7b f5 ff ff       	jmp    80105a6e <alltraps>

801064f3 <vector154>:
.globl vector154
vector154:
  pushl $0
801064f3:	6a 00                	push   $0x0
  pushl $154
801064f5:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801064fa:	e9 6f f5 ff ff       	jmp    80105a6e <alltraps>

801064ff <vector155>:
.globl vector155
vector155:
  pushl $0
801064ff:	6a 00                	push   $0x0
  pushl $155
80106501:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106506:	e9 63 f5 ff ff       	jmp    80105a6e <alltraps>

8010650b <vector156>:
.globl vector156
vector156:
  pushl $0
8010650b:	6a 00                	push   $0x0
  pushl $156
8010650d:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106512:	e9 57 f5 ff ff       	jmp    80105a6e <alltraps>

80106517 <vector157>:
.globl vector157
vector157:
  pushl $0
80106517:	6a 00                	push   $0x0
  pushl $157
80106519:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010651e:	e9 4b f5 ff ff       	jmp    80105a6e <alltraps>

80106523 <vector158>:
.globl vector158
vector158:
  pushl $0
80106523:	6a 00                	push   $0x0
  pushl $158
80106525:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
8010652a:	e9 3f f5 ff ff       	jmp    80105a6e <alltraps>

8010652f <vector159>:
.globl vector159
vector159:
  pushl $0
8010652f:	6a 00                	push   $0x0
  pushl $159
80106531:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106536:	e9 33 f5 ff ff       	jmp    80105a6e <alltraps>

8010653b <vector160>:
.globl vector160
vector160:
  pushl $0
8010653b:	6a 00                	push   $0x0
  pushl $160
8010653d:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106542:	e9 27 f5 ff ff       	jmp    80105a6e <alltraps>

80106547 <vector161>:
.globl vector161
vector161:
  pushl $0
80106547:	6a 00                	push   $0x0
  pushl $161
80106549:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010654e:	e9 1b f5 ff ff       	jmp    80105a6e <alltraps>

80106553 <vector162>:
.globl vector162
vector162:
  pushl $0
80106553:	6a 00                	push   $0x0
  pushl $162
80106555:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
8010655a:	e9 0f f5 ff ff       	jmp    80105a6e <alltraps>

8010655f <vector163>:
.globl vector163
vector163:
  pushl $0
8010655f:	6a 00                	push   $0x0
  pushl $163
80106561:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106566:	e9 03 f5 ff ff       	jmp    80105a6e <alltraps>

8010656b <vector164>:
.globl vector164
vector164:
  pushl $0
8010656b:	6a 00                	push   $0x0
  pushl $164
8010656d:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106572:	e9 f7 f4 ff ff       	jmp    80105a6e <alltraps>

80106577 <vector165>:
.globl vector165
vector165:
  pushl $0
80106577:	6a 00                	push   $0x0
  pushl $165
80106579:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010657e:	e9 eb f4 ff ff       	jmp    80105a6e <alltraps>

80106583 <vector166>:
.globl vector166
vector166:
  pushl $0
80106583:	6a 00                	push   $0x0
  pushl $166
80106585:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
8010658a:	e9 df f4 ff ff       	jmp    80105a6e <alltraps>

8010658f <vector167>:
.globl vector167
vector167:
  pushl $0
8010658f:	6a 00                	push   $0x0
  pushl $167
80106591:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106596:	e9 d3 f4 ff ff       	jmp    80105a6e <alltraps>

8010659b <vector168>:
.globl vector168
vector168:
  pushl $0
8010659b:	6a 00                	push   $0x0
  pushl $168
8010659d:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801065a2:	e9 c7 f4 ff ff       	jmp    80105a6e <alltraps>

801065a7 <vector169>:
.globl vector169
vector169:
  pushl $0
801065a7:	6a 00                	push   $0x0
  pushl $169
801065a9:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801065ae:	e9 bb f4 ff ff       	jmp    80105a6e <alltraps>

801065b3 <vector170>:
.globl vector170
vector170:
  pushl $0
801065b3:	6a 00                	push   $0x0
  pushl $170
801065b5:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801065ba:	e9 af f4 ff ff       	jmp    80105a6e <alltraps>

801065bf <vector171>:
.globl vector171
vector171:
  pushl $0
801065bf:	6a 00                	push   $0x0
  pushl $171
801065c1:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801065c6:	e9 a3 f4 ff ff       	jmp    80105a6e <alltraps>

801065cb <vector172>:
.globl vector172
vector172:
  pushl $0
801065cb:	6a 00                	push   $0x0
  pushl $172
801065cd:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801065d2:	e9 97 f4 ff ff       	jmp    80105a6e <alltraps>

801065d7 <vector173>:
.globl vector173
vector173:
  pushl $0
801065d7:	6a 00                	push   $0x0
  pushl $173
801065d9:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801065de:	e9 8b f4 ff ff       	jmp    80105a6e <alltraps>

801065e3 <vector174>:
.globl vector174
vector174:
  pushl $0
801065e3:	6a 00                	push   $0x0
  pushl $174
801065e5:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801065ea:	e9 7f f4 ff ff       	jmp    80105a6e <alltraps>

801065ef <vector175>:
.globl vector175
vector175:
  pushl $0
801065ef:	6a 00                	push   $0x0
  pushl $175
801065f1:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801065f6:	e9 73 f4 ff ff       	jmp    80105a6e <alltraps>

801065fb <vector176>:
.globl vector176
vector176:
  pushl $0
801065fb:	6a 00                	push   $0x0
  pushl $176
801065fd:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106602:	e9 67 f4 ff ff       	jmp    80105a6e <alltraps>

80106607 <vector177>:
.globl vector177
vector177:
  pushl $0
80106607:	6a 00                	push   $0x0
  pushl $177
80106609:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010660e:	e9 5b f4 ff ff       	jmp    80105a6e <alltraps>

80106613 <vector178>:
.globl vector178
vector178:
  pushl $0
80106613:	6a 00                	push   $0x0
  pushl $178
80106615:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
8010661a:	e9 4f f4 ff ff       	jmp    80105a6e <alltraps>

8010661f <vector179>:
.globl vector179
vector179:
  pushl $0
8010661f:	6a 00                	push   $0x0
  pushl $179
80106621:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106626:	e9 43 f4 ff ff       	jmp    80105a6e <alltraps>

8010662b <vector180>:
.globl vector180
vector180:
  pushl $0
8010662b:	6a 00                	push   $0x0
  pushl $180
8010662d:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106632:	e9 37 f4 ff ff       	jmp    80105a6e <alltraps>

80106637 <vector181>:
.globl vector181
vector181:
  pushl $0
80106637:	6a 00                	push   $0x0
  pushl $181
80106639:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010663e:	e9 2b f4 ff ff       	jmp    80105a6e <alltraps>

80106643 <vector182>:
.globl vector182
vector182:
  pushl $0
80106643:	6a 00                	push   $0x0
  pushl $182
80106645:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
8010664a:	e9 1f f4 ff ff       	jmp    80105a6e <alltraps>

8010664f <vector183>:
.globl vector183
vector183:
  pushl $0
8010664f:	6a 00                	push   $0x0
  pushl $183
80106651:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106656:	e9 13 f4 ff ff       	jmp    80105a6e <alltraps>

8010665b <vector184>:
.globl vector184
vector184:
  pushl $0
8010665b:	6a 00                	push   $0x0
  pushl $184
8010665d:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106662:	e9 07 f4 ff ff       	jmp    80105a6e <alltraps>

80106667 <vector185>:
.globl vector185
vector185:
  pushl $0
80106667:	6a 00                	push   $0x0
  pushl $185
80106669:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010666e:	e9 fb f3 ff ff       	jmp    80105a6e <alltraps>

80106673 <vector186>:
.globl vector186
vector186:
  pushl $0
80106673:	6a 00                	push   $0x0
  pushl $186
80106675:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
8010667a:	e9 ef f3 ff ff       	jmp    80105a6e <alltraps>

8010667f <vector187>:
.globl vector187
vector187:
  pushl $0
8010667f:	6a 00                	push   $0x0
  pushl $187
80106681:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106686:	e9 e3 f3 ff ff       	jmp    80105a6e <alltraps>

8010668b <vector188>:
.globl vector188
vector188:
  pushl $0
8010668b:	6a 00                	push   $0x0
  pushl $188
8010668d:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106692:	e9 d7 f3 ff ff       	jmp    80105a6e <alltraps>

80106697 <vector189>:
.globl vector189
vector189:
  pushl $0
80106697:	6a 00                	push   $0x0
  pushl $189
80106699:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010669e:	e9 cb f3 ff ff       	jmp    80105a6e <alltraps>

801066a3 <vector190>:
.globl vector190
vector190:
  pushl $0
801066a3:	6a 00                	push   $0x0
  pushl $190
801066a5:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801066aa:	e9 bf f3 ff ff       	jmp    80105a6e <alltraps>

801066af <vector191>:
.globl vector191
vector191:
  pushl $0
801066af:	6a 00                	push   $0x0
  pushl $191
801066b1:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801066b6:	e9 b3 f3 ff ff       	jmp    80105a6e <alltraps>

801066bb <vector192>:
.globl vector192
vector192:
  pushl $0
801066bb:	6a 00                	push   $0x0
  pushl $192
801066bd:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801066c2:	e9 a7 f3 ff ff       	jmp    80105a6e <alltraps>

801066c7 <vector193>:
.globl vector193
vector193:
  pushl $0
801066c7:	6a 00                	push   $0x0
  pushl $193
801066c9:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801066ce:	e9 9b f3 ff ff       	jmp    80105a6e <alltraps>

801066d3 <vector194>:
.globl vector194
vector194:
  pushl $0
801066d3:	6a 00                	push   $0x0
  pushl $194
801066d5:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801066da:	e9 8f f3 ff ff       	jmp    80105a6e <alltraps>

801066df <vector195>:
.globl vector195
vector195:
  pushl $0
801066df:	6a 00                	push   $0x0
  pushl $195
801066e1:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801066e6:	e9 83 f3 ff ff       	jmp    80105a6e <alltraps>

801066eb <vector196>:
.globl vector196
vector196:
  pushl $0
801066eb:	6a 00                	push   $0x0
  pushl $196
801066ed:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801066f2:	e9 77 f3 ff ff       	jmp    80105a6e <alltraps>

801066f7 <vector197>:
.globl vector197
vector197:
  pushl $0
801066f7:	6a 00                	push   $0x0
  pushl $197
801066f9:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801066fe:	e9 6b f3 ff ff       	jmp    80105a6e <alltraps>

80106703 <vector198>:
.globl vector198
vector198:
  pushl $0
80106703:	6a 00                	push   $0x0
  pushl $198
80106705:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
8010670a:	e9 5f f3 ff ff       	jmp    80105a6e <alltraps>

8010670f <vector199>:
.globl vector199
vector199:
  pushl $0
8010670f:	6a 00                	push   $0x0
  pushl $199
80106711:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106716:	e9 53 f3 ff ff       	jmp    80105a6e <alltraps>

8010671b <vector200>:
.globl vector200
vector200:
  pushl $0
8010671b:	6a 00                	push   $0x0
  pushl $200
8010671d:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106722:	e9 47 f3 ff ff       	jmp    80105a6e <alltraps>

80106727 <vector201>:
.globl vector201
vector201:
  pushl $0
80106727:	6a 00                	push   $0x0
  pushl $201
80106729:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010672e:	e9 3b f3 ff ff       	jmp    80105a6e <alltraps>

80106733 <vector202>:
.globl vector202
vector202:
  pushl $0
80106733:	6a 00                	push   $0x0
  pushl $202
80106735:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
8010673a:	e9 2f f3 ff ff       	jmp    80105a6e <alltraps>

8010673f <vector203>:
.globl vector203
vector203:
  pushl $0
8010673f:	6a 00                	push   $0x0
  pushl $203
80106741:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106746:	e9 23 f3 ff ff       	jmp    80105a6e <alltraps>

8010674b <vector204>:
.globl vector204
vector204:
  pushl $0
8010674b:	6a 00                	push   $0x0
  pushl $204
8010674d:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106752:	e9 17 f3 ff ff       	jmp    80105a6e <alltraps>

80106757 <vector205>:
.globl vector205
vector205:
  pushl $0
80106757:	6a 00                	push   $0x0
  pushl $205
80106759:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010675e:	e9 0b f3 ff ff       	jmp    80105a6e <alltraps>

80106763 <vector206>:
.globl vector206
vector206:
  pushl $0
80106763:	6a 00                	push   $0x0
  pushl $206
80106765:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
8010676a:	e9 ff f2 ff ff       	jmp    80105a6e <alltraps>

8010676f <vector207>:
.globl vector207
vector207:
  pushl $0
8010676f:	6a 00                	push   $0x0
  pushl $207
80106771:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106776:	e9 f3 f2 ff ff       	jmp    80105a6e <alltraps>

8010677b <vector208>:
.globl vector208
vector208:
  pushl $0
8010677b:	6a 00                	push   $0x0
  pushl $208
8010677d:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106782:	e9 e7 f2 ff ff       	jmp    80105a6e <alltraps>

80106787 <vector209>:
.globl vector209
vector209:
  pushl $0
80106787:	6a 00                	push   $0x0
  pushl $209
80106789:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010678e:	e9 db f2 ff ff       	jmp    80105a6e <alltraps>

80106793 <vector210>:
.globl vector210
vector210:
  pushl $0
80106793:	6a 00                	push   $0x0
  pushl $210
80106795:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
8010679a:	e9 cf f2 ff ff       	jmp    80105a6e <alltraps>

8010679f <vector211>:
.globl vector211
vector211:
  pushl $0
8010679f:	6a 00                	push   $0x0
  pushl $211
801067a1:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801067a6:	e9 c3 f2 ff ff       	jmp    80105a6e <alltraps>

801067ab <vector212>:
.globl vector212
vector212:
  pushl $0
801067ab:	6a 00                	push   $0x0
  pushl $212
801067ad:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801067b2:	e9 b7 f2 ff ff       	jmp    80105a6e <alltraps>

801067b7 <vector213>:
.globl vector213
vector213:
  pushl $0
801067b7:	6a 00                	push   $0x0
  pushl $213
801067b9:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801067be:	e9 ab f2 ff ff       	jmp    80105a6e <alltraps>

801067c3 <vector214>:
.globl vector214
vector214:
  pushl $0
801067c3:	6a 00                	push   $0x0
  pushl $214
801067c5:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801067ca:	e9 9f f2 ff ff       	jmp    80105a6e <alltraps>

801067cf <vector215>:
.globl vector215
vector215:
  pushl $0
801067cf:	6a 00                	push   $0x0
  pushl $215
801067d1:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801067d6:	e9 93 f2 ff ff       	jmp    80105a6e <alltraps>

801067db <vector216>:
.globl vector216
vector216:
  pushl $0
801067db:	6a 00                	push   $0x0
  pushl $216
801067dd:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801067e2:	e9 87 f2 ff ff       	jmp    80105a6e <alltraps>

801067e7 <vector217>:
.globl vector217
vector217:
  pushl $0
801067e7:	6a 00                	push   $0x0
  pushl $217
801067e9:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801067ee:	e9 7b f2 ff ff       	jmp    80105a6e <alltraps>

801067f3 <vector218>:
.globl vector218
vector218:
  pushl $0
801067f3:	6a 00                	push   $0x0
  pushl $218
801067f5:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801067fa:	e9 6f f2 ff ff       	jmp    80105a6e <alltraps>

801067ff <vector219>:
.globl vector219
vector219:
  pushl $0
801067ff:	6a 00                	push   $0x0
  pushl $219
80106801:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106806:	e9 63 f2 ff ff       	jmp    80105a6e <alltraps>

8010680b <vector220>:
.globl vector220
vector220:
  pushl $0
8010680b:	6a 00                	push   $0x0
  pushl $220
8010680d:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106812:	e9 57 f2 ff ff       	jmp    80105a6e <alltraps>

80106817 <vector221>:
.globl vector221
vector221:
  pushl $0
80106817:	6a 00                	push   $0x0
  pushl $221
80106819:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010681e:	e9 4b f2 ff ff       	jmp    80105a6e <alltraps>

80106823 <vector222>:
.globl vector222
vector222:
  pushl $0
80106823:	6a 00                	push   $0x0
  pushl $222
80106825:	68 de 00 00 00       	push   $0xde
  jmp alltraps
8010682a:	e9 3f f2 ff ff       	jmp    80105a6e <alltraps>

8010682f <vector223>:
.globl vector223
vector223:
  pushl $0
8010682f:	6a 00                	push   $0x0
  pushl $223
80106831:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106836:	e9 33 f2 ff ff       	jmp    80105a6e <alltraps>

8010683b <vector224>:
.globl vector224
vector224:
  pushl $0
8010683b:	6a 00                	push   $0x0
  pushl $224
8010683d:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106842:	e9 27 f2 ff ff       	jmp    80105a6e <alltraps>

80106847 <vector225>:
.globl vector225
vector225:
  pushl $0
80106847:	6a 00                	push   $0x0
  pushl $225
80106849:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010684e:	e9 1b f2 ff ff       	jmp    80105a6e <alltraps>

80106853 <vector226>:
.globl vector226
vector226:
  pushl $0
80106853:	6a 00                	push   $0x0
  pushl $226
80106855:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
8010685a:	e9 0f f2 ff ff       	jmp    80105a6e <alltraps>

8010685f <vector227>:
.globl vector227
vector227:
  pushl $0
8010685f:	6a 00                	push   $0x0
  pushl $227
80106861:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106866:	e9 03 f2 ff ff       	jmp    80105a6e <alltraps>

8010686b <vector228>:
.globl vector228
vector228:
  pushl $0
8010686b:	6a 00                	push   $0x0
  pushl $228
8010686d:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106872:	e9 f7 f1 ff ff       	jmp    80105a6e <alltraps>

80106877 <vector229>:
.globl vector229
vector229:
  pushl $0
80106877:	6a 00                	push   $0x0
  pushl $229
80106879:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010687e:	e9 eb f1 ff ff       	jmp    80105a6e <alltraps>

80106883 <vector230>:
.globl vector230
vector230:
  pushl $0
80106883:	6a 00                	push   $0x0
  pushl $230
80106885:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
8010688a:	e9 df f1 ff ff       	jmp    80105a6e <alltraps>

8010688f <vector231>:
.globl vector231
vector231:
  pushl $0
8010688f:	6a 00                	push   $0x0
  pushl $231
80106891:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106896:	e9 d3 f1 ff ff       	jmp    80105a6e <alltraps>

8010689b <vector232>:
.globl vector232
vector232:
  pushl $0
8010689b:	6a 00                	push   $0x0
  pushl $232
8010689d:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801068a2:	e9 c7 f1 ff ff       	jmp    80105a6e <alltraps>

801068a7 <vector233>:
.globl vector233
vector233:
  pushl $0
801068a7:	6a 00                	push   $0x0
  pushl $233
801068a9:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801068ae:	e9 bb f1 ff ff       	jmp    80105a6e <alltraps>

801068b3 <vector234>:
.globl vector234
vector234:
  pushl $0
801068b3:	6a 00                	push   $0x0
  pushl $234
801068b5:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801068ba:	e9 af f1 ff ff       	jmp    80105a6e <alltraps>

801068bf <vector235>:
.globl vector235
vector235:
  pushl $0
801068bf:	6a 00                	push   $0x0
  pushl $235
801068c1:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801068c6:	e9 a3 f1 ff ff       	jmp    80105a6e <alltraps>

801068cb <vector236>:
.globl vector236
vector236:
  pushl $0
801068cb:	6a 00                	push   $0x0
  pushl $236
801068cd:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801068d2:	e9 97 f1 ff ff       	jmp    80105a6e <alltraps>

801068d7 <vector237>:
.globl vector237
vector237:
  pushl $0
801068d7:	6a 00                	push   $0x0
  pushl $237
801068d9:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801068de:	e9 8b f1 ff ff       	jmp    80105a6e <alltraps>

801068e3 <vector238>:
.globl vector238
vector238:
  pushl $0
801068e3:	6a 00                	push   $0x0
  pushl $238
801068e5:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801068ea:	e9 7f f1 ff ff       	jmp    80105a6e <alltraps>

801068ef <vector239>:
.globl vector239
vector239:
  pushl $0
801068ef:	6a 00                	push   $0x0
  pushl $239
801068f1:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801068f6:	e9 73 f1 ff ff       	jmp    80105a6e <alltraps>

801068fb <vector240>:
.globl vector240
vector240:
  pushl $0
801068fb:	6a 00                	push   $0x0
  pushl $240
801068fd:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106902:	e9 67 f1 ff ff       	jmp    80105a6e <alltraps>

80106907 <vector241>:
.globl vector241
vector241:
  pushl $0
80106907:	6a 00                	push   $0x0
  pushl $241
80106909:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010690e:	e9 5b f1 ff ff       	jmp    80105a6e <alltraps>

80106913 <vector242>:
.globl vector242
vector242:
  pushl $0
80106913:	6a 00                	push   $0x0
  pushl $242
80106915:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
8010691a:	e9 4f f1 ff ff       	jmp    80105a6e <alltraps>

8010691f <vector243>:
.globl vector243
vector243:
  pushl $0
8010691f:	6a 00                	push   $0x0
  pushl $243
80106921:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106926:	e9 43 f1 ff ff       	jmp    80105a6e <alltraps>

8010692b <vector244>:
.globl vector244
vector244:
  pushl $0
8010692b:	6a 00                	push   $0x0
  pushl $244
8010692d:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106932:	e9 37 f1 ff ff       	jmp    80105a6e <alltraps>

80106937 <vector245>:
.globl vector245
vector245:
  pushl $0
80106937:	6a 00                	push   $0x0
  pushl $245
80106939:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010693e:	e9 2b f1 ff ff       	jmp    80105a6e <alltraps>

80106943 <vector246>:
.globl vector246
vector246:
  pushl $0
80106943:	6a 00                	push   $0x0
  pushl $246
80106945:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
8010694a:	e9 1f f1 ff ff       	jmp    80105a6e <alltraps>

8010694f <vector247>:
.globl vector247
vector247:
  pushl $0
8010694f:	6a 00                	push   $0x0
  pushl $247
80106951:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106956:	e9 13 f1 ff ff       	jmp    80105a6e <alltraps>

8010695b <vector248>:
.globl vector248
vector248:
  pushl $0
8010695b:	6a 00                	push   $0x0
  pushl $248
8010695d:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106962:	e9 07 f1 ff ff       	jmp    80105a6e <alltraps>

80106967 <vector249>:
.globl vector249
vector249:
  pushl $0
80106967:	6a 00                	push   $0x0
  pushl $249
80106969:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010696e:	e9 fb f0 ff ff       	jmp    80105a6e <alltraps>

80106973 <vector250>:
.globl vector250
vector250:
  pushl $0
80106973:	6a 00                	push   $0x0
  pushl $250
80106975:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
8010697a:	e9 ef f0 ff ff       	jmp    80105a6e <alltraps>

8010697f <vector251>:
.globl vector251
vector251:
  pushl $0
8010697f:	6a 00                	push   $0x0
  pushl $251
80106981:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106986:	e9 e3 f0 ff ff       	jmp    80105a6e <alltraps>

8010698b <vector252>:
.globl vector252
vector252:
  pushl $0
8010698b:	6a 00                	push   $0x0
  pushl $252
8010698d:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106992:	e9 d7 f0 ff ff       	jmp    80105a6e <alltraps>

80106997 <vector253>:
.globl vector253
vector253:
  pushl $0
80106997:	6a 00                	push   $0x0
  pushl $253
80106999:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010699e:	e9 cb f0 ff ff       	jmp    80105a6e <alltraps>

801069a3 <vector254>:
.globl vector254
vector254:
  pushl $0
801069a3:	6a 00                	push   $0x0
  pushl $254
801069a5:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801069aa:	e9 bf f0 ff ff       	jmp    80105a6e <alltraps>

801069af <vector255>:
.globl vector255
vector255:
  pushl $0
801069af:	6a 00                	push   $0x0
  pushl $255
801069b1:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801069b6:	e9 b3 f0 ff ff       	jmp    80105a6e <alltraps>
801069bb:	66 90                	xchg   %ax,%ax
801069bd:	66 90                	xchg   %ax,%ax
801069bf:	90                   	nop

801069c0 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
801069c0:	f3 0f 1e fb          	endbr32 
801069c4:	55                   	push   %ebp
801069c5:	89 e5                	mov    %esp,%ebp
801069c7:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
801069ca:	e8 c1 cf ff ff       	call   80103990 <cpuid>
  pd[0] = size-1;
801069cf:	ba 2f 00 00 00       	mov    $0x2f,%edx
801069d4:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801069da:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801069de:	c7 80 18 38 11 80 ff 	movl   $0xffff,-0x7feec7e8(%eax)
801069e5:	ff 00 00 
801069e8:	c7 80 1c 38 11 80 00 	movl   $0xcf9a00,-0x7feec7e4(%eax)
801069ef:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801069f2:	c7 80 20 38 11 80 ff 	movl   $0xffff,-0x7feec7e0(%eax)
801069f9:	ff 00 00 
801069fc:	c7 80 24 38 11 80 00 	movl   $0xcf9200,-0x7feec7dc(%eax)
80106a03:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106a06:	c7 80 28 38 11 80 ff 	movl   $0xffff,-0x7feec7d8(%eax)
80106a0d:	ff 00 00 
80106a10:	c7 80 2c 38 11 80 00 	movl   $0xcffa00,-0x7feec7d4(%eax)
80106a17:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106a1a:	c7 80 30 38 11 80 ff 	movl   $0xffff,-0x7feec7d0(%eax)
80106a21:	ff 00 00 
80106a24:	c7 80 34 38 11 80 00 	movl   $0xcff200,-0x7feec7cc(%eax)
80106a2b:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106a2e:	05 10 38 11 80       	add    $0x80113810,%eax
  pd[1] = (uint)p;
80106a33:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106a37:	c1 e8 10             	shr    $0x10,%eax
80106a3a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106a3e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106a41:	0f 01 10             	lgdtl  (%eax)
}
80106a44:	c9                   	leave  
80106a45:	c3                   	ret    
80106a46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a4d:	8d 76 00             	lea    0x0(%esi),%esi

80106a50 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106a50:	f3 0f 1e fb          	endbr32 
80106a54:	55                   	push   %ebp
80106a55:	89 e5                	mov    %esp,%ebp
80106a57:	57                   	push   %edi
80106a58:	56                   	push   %esi
80106a59:	53                   	push   %ebx
80106a5a:	83 ec 0c             	sub    $0xc,%esp
80106a5d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106a60:	8b 55 08             	mov    0x8(%ebp),%edx
80106a63:	89 fe                	mov    %edi,%esi
80106a65:	c1 ee 16             	shr    $0x16,%esi
80106a68:	8d 34 b2             	lea    (%edx,%esi,4),%esi
  if(*pde & PTE_P){
80106a6b:	8b 1e                	mov    (%esi),%ebx
80106a6d:	f6 c3 01             	test   $0x1,%bl
80106a70:	74 26                	je     80106a98 <walkpgdir+0x48>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106a72:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80106a78:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106a7e:	89 f8                	mov    %edi,%eax
}
80106a80:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106a83:	c1 e8 0a             	shr    $0xa,%eax
80106a86:	25 fc 0f 00 00       	and    $0xffc,%eax
80106a8b:	01 d8                	add    %ebx,%eax
}
80106a8d:	5b                   	pop    %ebx
80106a8e:	5e                   	pop    %esi
80106a8f:	5f                   	pop    %edi
80106a90:	5d                   	pop    %ebp
80106a91:	c3                   	ret    
80106a92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106a98:	8b 45 10             	mov    0x10(%ebp),%eax
80106a9b:	85 c0                	test   %eax,%eax
80106a9d:	74 31                	je     80106ad0 <walkpgdir+0x80>
80106a9f:	e8 9c bb ff ff       	call   80102640 <kalloc>
80106aa4:	89 c3                	mov    %eax,%ebx
80106aa6:	85 c0                	test   %eax,%eax
80106aa8:	74 26                	je     80106ad0 <walkpgdir+0x80>
    memset(pgtab, 0, PGSIZE);
80106aaa:	83 ec 04             	sub    $0x4,%esp
80106aad:	68 00 10 00 00       	push   $0x1000
80106ab2:	6a 00                	push   $0x0
80106ab4:	50                   	push   %eax
80106ab5:	e8 86 dd ff ff       	call   80104840 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106aba:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106ac0:	83 c4 10             	add    $0x10,%esp
80106ac3:	83 c8 07             	or     $0x7,%eax
80106ac6:	89 06                	mov    %eax,(%esi)
80106ac8:	eb b4                	jmp    80106a7e <walkpgdir+0x2e>
80106aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
80106ad0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106ad3:	31 c0                	xor    %eax,%eax
}
80106ad5:	5b                   	pop    %ebx
80106ad6:	5e                   	pop    %esi
80106ad7:	5f                   	pop    %edi
80106ad8:	5d                   	pop    %ebp
80106ad9:	c3                   	ret    
80106ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106ae0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106ae0:	55                   	push   %ebp
80106ae1:	89 e5                	mov    %esp,%ebp
80106ae3:	57                   	push   %edi
80106ae4:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106ae6:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
80106aea:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106aeb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
80106af0:	89 d6                	mov    %edx,%esi
{
80106af2:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106af3:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
80106af9:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106afc:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106aff:	8b 45 08             	mov    0x8(%ebp),%eax
80106b02:	29 f0                	sub    %esi,%eax
80106b04:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106b07:	eb 1f                	jmp    80106b28 <mappages+0x48>
80106b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106b10:	f6 00 01             	testb  $0x1,(%eax)
80106b13:	75 45                	jne    80106b5a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106b15:	0b 5d 0c             	or     0xc(%ebp),%ebx
80106b18:	83 cb 01             	or     $0x1,%ebx
80106b1b:	89 18                	mov    %ebx,(%eax)
    if(a == last)
80106b1d:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80106b20:	74 2e                	je     80106b50 <mappages+0x70>
      break;
    a += PGSIZE;
80106b22:	81 c6 00 10 00 00    	add    $0x1000,%esi
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106b28:	83 ec 04             	sub    $0x4,%esp
80106b2b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106b2e:	6a 01                	push   $0x1
80106b30:	56                   	push   %esi
80106b31:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80106b34:	57                   	push   %edi
80106b35:	e8 16 ff ff ff       	call   80106a50 <walkpgdir>
80106b3a:	83 c4 10             	add    $0x10,%esp
80106b3d:	85 c0                	test   %eax,%eax
80106b3f:	75 cf                	jne    80106b10 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106b41:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106b44:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106b49:	5b                   	pop    %ebx
80106b4a:	5e                   	pop    %esi
80106b4b:	5f                   	pop    %edi
80106b4c:	5d                   	pop    %ebp
80106b4d:	c3                   	ret    
80106b4e:	66 90                	xchg   %ax,%ax
80106b50:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106b53:	31 c0                	xor    %eax,%eax
}
80106b55:	5b                   	pop    %ebx
80106b56:	5e                   	pop    %esi
80106b57:	5f                   	pop    %edi
80106b58:	5d                   	pop    %ebp
80106b59:	c3                   	ret    
      panic("remap");
80106b5a:	83 ec 0c             	sub    $0xc,%esp
80106b5d:	68 10 81 10 80       	push   $0x80108110
80106b62:	e8 29 98 ff ff       	call   80100390 <panic>
80106b67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b6e:	66 90                	xchg   %ax,%ax

80106b70 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106b70:	55                   	push   %ebp
80106b71:	89 e5                	mov    %esp,%ebp
80106b73:	57                   	push   %edi
80106b74:	89 c7                	mov    %eax,%edi
80106b76:	56                   	push   %esi
80106b77:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106b78:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106b7e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106b84:	83 ec 1c             	sub    $0x1c,%esp
80106b87:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106b8a:	39 d3                	cmp    %edx,%ebx
80106b8c:	73 77                	jae    80106c05 <deallocuvm.part.0+0x95>
80106b8e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80106b91:	eb 10                	jmp    80106ba3 <deallocuvm.part.0+0x33>
80106b93:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106b97:	90                   	nop
80106b98:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106b9e:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
80106ba1:	76 62                	jbe    80106c05 <deallocuvm.part.0+0x95>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106ba3:	83 ec 04             	sub    $0x4,%esp
80106ba6:	6a 00                	push   $0x0
80106ba8:	53                   	push   %ebx
80106ba9:	57                   	push   %edi
80106baa:	e8 a1 fe ff ff       	call   80106a50 <walkpgdir>
    if(!pte)
80106baf:	83 c4 10             	add    $0x10,%esp
    pte = walkpgdir(pgdir, (char*)a, 0);
80106bb2:	89 c6                	mov    %eax,%esi
    if(!pte)
80106bb4:	85 c0                	test   %eax,%eax
80106bb6:	74 58                	je     80106c10 <deallocuvm.part.0+0xa0>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106bb8:	8b 00                	mov    (%eax),%eax
80106bba:	a8 01                	test   $0x1,%al
80106bbc:	74 da                	je     80106b98 <deallocuvm.part.0+0x28>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106bbe:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106bc3:	74 6f                	je     80106c34 <deallocuvm.part.0+0xc4>
        panic("kfree");
      char *v = P2V(pa);

        int left=share_remove(pa,pte);
80106bc5:	83 ec 08             	sub    $0x8,%esp
80106bc8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106bcb:	56                   	push   %esi
80106bcc:	50                   	push   %eax
80106bcd:	e8 0e 09 00 00       	call   801074e0 <share_remove>
        if(left==0) kfree(v); 
80106bd2:	83 c4 10             	add    $0x10,%esp
80106bd5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80106bd8:	85 c0                	test   %eax,%eax
80106bda:	74 44                	je     80106c20 <deallocuvm.part.0+0xb0>
      
      
      *pte = 0;
80106bdc:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
      if(myproc()->rss>0) myproc()->rss-=PGSIZE;
80106be2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106be8:	e8 c3 cd ff ff       	call   801039b0 <myproc>
80106bed:	8b 40 04             	mov    0x4(%eax),%eax
80106bf0:	85 c0                	test   %eax,%eax
80106bf2:	74 aa                	je     80106b9e <deallocuvm.part.0+0x2e>
80106bf4:	e8 b7 cd ff ff       	call   801039b0 <myproc>
80106bf9:	81 68 04 00 10 00 00 	subl   $0x1000,0x4(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106c00:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
80106c03:	77 9e                	ja     80106ba3 <deallocuvm.part.0+0x33>
    }
  }
  return newsz;
}
80106c05:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106c08:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c0b:	5b                   	pop    %ebx
80106c0c:	5e                   	pop    %esi
80106c0d:	5f                   	pop    %edi
80106c0e:	5d                   	pop    %ebp
80106c0f:	c3                   	ret    
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106c10:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106c16:	81 c3 00 00 40 00    	add    $0x400000,%ebx
80106c1c:	eb 80                	jmp    80106b9e <deallocuvm.part.0+0x2e>
80106c1e:	66 90                	xchg   %ax,%ax
        if(left==0) kfree(v); 
80106c20:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106c23:	8d 81 00 00 00 80    	lea    -0x80000000(%ecx),%eax
        if(left==0) kfree(v); 
80106c29:	50                   	push   %eax
80106c2a:	e8 41 b8 ff ff       	call   80102470 <kfree>
80106c2f:	83 c4 10             	add    $0x10,%esp
80106c32:	eb a8                	jmp    80106bdc <deallocuvm.part.0+0x6c>
        panic("kfree");
80106c34:	83 ec 0c             	sub    $0xc,%esp
80106c37:	68 a6 79 10 80       	push   $0x801079a6
80106c3c:	e8 4f 97 ff ff       	call   80100390 <panic>
80106c41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c4f:	90                   	nop

80106c50 <switchkvm>:
{
80106c50:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106c54:	a1 e4 60 11 80       	mov    0x801160e4,%eax
80106c59:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106c5e:	0f 22 d8             	mov    %eax,%cr3
}
80106c61:	c3                   	ret    
80106c62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106c70 <switchuvm>:
{
80106c70:	f3 0f 1e fb          	endbr32 
80106c74:	55                   	push   %ebp
80106c75:	89 e5                	mov    %esp,%ebp
80106c77:	57                   	push   %edi
80106c78:	56                   	push   %esi
80106c79:	53                   	push   %ebx
80106c7a:	83 ec 1c             	sub    $0x1c,%esp
80106c7d:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106c80:	85 f6                	test   %esi,%esi
80106c82:	0f 84 cb 00 00 00    	je     80106d53 <switchuvm+0xe3>
  if(p->kstack == 0)
80106c88:	8b 46 0c             	mov    0xc(%esi),%eax
80106c8b:	85 c0                	test   %eax,%eax
80106c8d:	0f 84 da 00 00 00    	je     80106d6d <switchuvm+0xfd>
  if(p->pgdir == 0)
80106c93:	8b 46 08             	mov    0x8(%esi),%eax
80106c96:	85 c0                	test   %eax,%eax
80106c98:	0f 84 c2 00 00 00    	je     80106d60 <switchuvm+0xf0>
  pushcli();
80106c9e:	e8 8d d9 ff ff       	call   80104630 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106ca3:	e8 88 cc ff ff       	call   80103930 <mycpu>
80106ca8:	89 c3                	mov    %eax,%ebx
80106caa:	e8 81 cc ff ff       	call   80103930 <mycpu>
80106caf:	89 c7                	mov    %eax,%edi
80106cb1:	e8 7a cc ff ff       	call   80103930 <mycpu>
80106cb6:	83 c7 08             	add    $0x8,%edi
80106cb9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106cbc:	e8 6f cc ff ff       	call   80103930 <mycpu>
80106cc1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106cc4:	ba 67 00 00 00       	mov    $0x67,%edx
80106cc9:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106cd0:	83 c0 08             	add    $0x8,%eax
80106cd3:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106cda:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106cdf:	83 c1 08             	add    $0x8,%ecx
80106ce2:	c1 e8 18             	shr    $0x18,%eax
80106ce5:	c1 e9 10             	shr    $0x10,%ecx
80106ce8:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106cee:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106cf4:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106cf9:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106d00:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106d05:	e8 26 cc ff ff       	call   80103930 <mycpu>
80106d0a:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106d11:	e8 1a cc ff ff       	call   80103930 <mycpu>
80106d16:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106d1a:	8b 5e 0c             	mov    0xc(%esi),%ebx
80106d1d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106d23:	e8 08 cc ff ff       	call   80103930 <mycpu>
80106d28:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106d2b:	e8 00 cc ff ff       	call   80103930 <mycpu>
80106d30:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106d34:	b8 28 00 00 00       	mov    $0x28,%eax
80106d39:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106d3c:	8b 46 08             	mov    0x8(%esi),%eax
80106d3f:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106d44:	0f 22 d8             	mov    %eax,%cr3
}
80106d47:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d4a:	5b                   	pop    %ebx
80106d4b:	5e                   	pop    %esi
80106d4c:	5f                   	pop    %edi
80106d4d:	5d                   	pop    %ebp
  popcli();
80106d4e:	e9 2d d9 ff ff       	jmp    80104680 <popcli>
    panic("switchuvm: no process");
80106d53:	83 ec 0c             	sub    $0xc,%esp
80106d56:	68 16 81 10 80       	push   $0x80108116
80106d5b:	e8 30 96 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80106d60:	83 ec 0c             	sub    $0xc,%esp
80106d63:	68 41 81 10 80       	push   $0x80108141
80106d68:	e8 23 96 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80106d6d:	83 ec 0c             	sub    $0xc,%esp
80106d70:	68 2c 81 10 80       	push   $0x8010812c
80106d75:	e8 16 96 ff ff       	call   80100390 <panic>
80106d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106d80 <inituvm>:
{
80106d80:	f3 0f 1e fb          	endbr32 
80106d84:	55                   	push   %ebp
80106d85:	89 e5                	mov    %esp,%ebp
80106d87:	57                   	push   %edi
80106d88:	56                   	push   %esi
80106d89:	53                   	push   %ebx
80106d8a:	83 ec 1c             	sub    $0x1c,%esp
80106d8d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d90:	8b 75 10             	mov    0x10(%ebp),%esi
80106d93:	8b 7d 08             	mov    0x8(%ebp),%edi
80106d96:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106d99:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106d9f:	0f 87 80 00 00 00    	ja     80106e25 <inituvm+0xa5>
  mem = kalloc();
80106da5:	e8 96 b8 ff ff       	call   80102640 <kalloc>
  memset(mem, 0, PGSIZE);
80106daa:	83 ec 04             	sub    $0x4,%esp
80106dad:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106db2:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106db4:	6a 00                	push   $0x0
80106db6:	50                   	push   %eax
80106db7:	e8 84 da ff ff       	call   80104840 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106dbc:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106dc2:	5a                   	pop    %edx
80106dc3:	59                   	pop    %ecx
80106dc4:	6a 06                	push   $0x6
80106dc6:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106dcb:	31 d2                	xor    %edx,%edx
80106dcd:	50                   	push   %eax
80106dce:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106dd1:	89 f8                	mov    %edi,%eax
80106dd3:	e8 08 fd ff ff       	call   80106ae0 <mappages>
  memmove(mem, init, sz);
80106dd8:	83 c4 0c             	add    $0xc,%esp
80106ddb:	56                   	push   %esi
80106ddc:	ff 75 e4             	pushl  -0x1c(%ebp)
80106ddf:	53                   	push   %ebx
80106de0:	e8 fb da ff ff       	call   801048e0 <memmove>
  if(*pde & PTE_P){
80106de5:	8b 07                	mov    (%edi),%eax
80106de7:	83 c4 10             	add    $0x10,%esp
80106dea:	a8 01                	test   $0x1,%al
80106dec:	74 2a                	je     80106e18 <inituvm+0x98>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106dee:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106df3:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  if(pte==0){
80106df9:	3d 00 00 00 80       	cmp    $0x80000000,%eax
80106dfe:	74 18                	je     80106e18 <inituvm+0x98>
  share_add(V2P(mem),pte);
80106e00:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106e03:	89 55 0c             	mov    %edx,0xc(%ebp)
80106e06:	89 45 08             	mov    %eax,0x8(%ebp)
}
80106e09:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e0c:	5b                   	pop    %ebx
80106e0d:	5e                   	pop    %esi
80106e0e:	5f                   	pop    %edi
80106e0f:	5d                   	pop    %ebp
  share_add(V2P(mem),pte);
80106e10:	e9 3b 06 00 00       	jmp    80107450 <share_add>
80106e15:	8d 76 00             	lea    0x0(%esi),%esi
    panic("Page Table in inituvm is not present");
80106e18:	83 ec 0c             	sub    $0xc,%esp
80106e1b:	68 10 82 10 80       	push   $0x80108210
80106e20:	e8 6b 95 ff ff       	call   80100390 <panic>
    panic("inituvm: more than a page");
80106e25:	83 ec 0c             	sub    $0xc,%esp
80106e28:	68 55 81 10 80       	push   $0x80108155
80106e2d:	e8 5e 95 ff ff       	call   80100390 <panic>
80106e32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106e40 <loaduvm>:
{
80106e40:	f3 0f 1e fb          	endbr32 
80106e44:	55                   	push   %ebp
80106e45:	89 e5                	mov    %esp,%ebp
80106e47:	57                   	push   %edi
80106e48:	56                   	push   %esi
80106e49:	53                   	push   %ebx
80106e4a:	83 ec 1c             	sub    $0x1c,%esp
80106e4d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e50:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80106e53:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106e58:	0f 85 99 00 00 00    	jne    80106ef7 <loaduvm+0xb7>
  for(i = 0; i < sz; i += PGSIZE){
80106e5e:	01 f0                	add    %esi,%eax
80106e60:	89 f3                	mov    %esi,%ebx
80106e62:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106e65:	8b 45 14             	mov    0x14(%ebp),%eax
80106e68:	01 f0                	add    %esi,%eax
80106e6a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80106e6d:	85 f6                	test   %esi,%esi
80106e6f:	75 15                	jne    80106e86 <loaduvm+0x46>
80106e71:	eb 6d                	jmp    80106ee0 <loaduvm+0xa0>
80106e73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106e77:	90                   	nop
80106e78:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80106e7e:	89 f0                	mov    %esi,%eax
80106e80:	29 d8                	sub    %ebx,%eax
80106e82:	39 c6                	cmp    %eax,%esi
80106e84:	76 5a                	jbe    80106ee0 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106e86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e89:	83 ec 04             	sub    $0x4,%esp
80106e8c:	6a 00                	push   $0x0
80106e8e:	29 d8                	sub    %ebx,%eax
80106e90:	50                   	push   %eax
80106e91:	ff 75 08             	pushl  0x8(%ebp)
80106e94:	e8 b7 fb ff ff       	call   80106a50 <walkpgdir>
80106e99:	83 c4 10             	add    $0x10,%esp
80106e9c:	85 c0                	test   %eax,%eax
80106e9e:	74 4a                	je     80106eea <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
80106ea0:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106ea2:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80106ea5:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106eaa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106eaf:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80106eb5:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106eb8:	29 d9                	sub    %ebx,%ecx
80106eba:	05 00 00 00 80       	add    $0x80000000,%eax
80106ebf:	57                   	push   %edi
80106ec0:	51                   	push   %ecx
80106ec1:	50                   	push   %eax
80106ec2:	ff 75 10             	pushl  0x10(%ebp)
80106ec5:	e8 96 ab ff ff       	call   80101a60 <readi>
80106eca:	83 c4 10             	add    $0x10,%esp
80106ecd:	39 f8                	cmp    %edi,%eax
80106ecf:	74 a7                	je     80106e78 <loaduvm+0x38>
}
80106ed1:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106ed4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106ed9:	5b                   	pop    %ebx
80106eda:	5e                   	pop    %esi
80106edb:	5f                   	pop    %edi
80106edc:	5d                   	pop    %ebp
80106edd:	c3                   	ret    
80106ede:	66 90                	xchg   %ax,%ax
80106ee0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106ee3:	31 c0                	xor    %eax,%eax
}
80106ee5:	5b                   	pop    %ebx
80106ee6:	5e                   	pop    %esi
80106ee7:	5f                   	pop    %edi
80106ee8:	5d                   	pop    %ebp
80106ee9:	c3                   	ret    
      panic("loaduvm: address should exist");
80106eea:	83 ec 0c             	sub    $0xc,%esp
80106eed:	68 6f 81 10 80       	push   $0x8010816f
80106ef2:	e8 99 94 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80106ef7:	83 ec 0c             	sub    $0xc,%esp
80106efa:	68 38 82 10 80       	push   $0x80108238
80106eff:	e8 8c 94 ff ff       	call   80100390 <panic>
80106f04:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106f0f:	90                   	nop

80106f10 <allocuvm>:
{
80106f10:	f3 0f 1e fb          	endbr32 
80106f14:	55                   	push   %ebp
80106f15:	89 e5                	mov    %esp,%ebp
80106f17:	57                   	push   %edi
80106f18:	56                   	push   %esi
80106f19:	53                   	push   %ebx
80106f1a:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106f1d:	8b 45 10             	mov    0x10(%ebp),%eax
80106f20:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106f23:	85 c0                	test   %eax,%eax
80106f25:	0f 88 f5 00 00 00    	js     80107020 <allocuvm+0x110>
  if(newsz < oldsz)
80106f2b:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80106f2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80106f31:	0f 82 d9 00 00 00    	jb     80107010 <allocuvm+0x100>
  a = PGROUNDUP(oldsz);
80106f37:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80106f3d:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80106f43:	39 75 10             	cmp    %esi,0x10(%ebp)
80106f46:	77 7c                	ja     80106fc4 <allocuvm+0xb4>
80106f48:	e9 c6 00 00 00       	jmp    80107013 <allocuvm+0x103>
80106f4d:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80106f50:	83 ec 04             	sub    $0x4,%esp
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106f53:	8d bb 00 00 00 80    	lea    -0x80000000(%ebx),%edi
    memset(mem, 0, PGSIZE);
80106f59:	68 00 10 00 00       	push   $0x1000
80106f5e:	6a 00                	push   $0x0
80106f60:	50                   	push   %eax
80106f61:	e8 da d8 ff ff       	call   80104840 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106f66:	58                   	pop    %eax
80106f67:	5a                   	pop    %edx
80106f68:	6a 06                	push   $0x6
80106f6a:	57                   	push   %edi
80106f6b:	8b 45 08             	mov    0x8(%ebp),%eax
80106f6e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106f73:	89 f2                	mov    %esi,%edx
80106f75:	e8 66 fb ff ff       	call   80106ae0 <mappages>
80106f7a:	83 c4 10             	add    $0x10,%esp
80106f7d:	85 c0                	test   %eax,%eax
80106f7f:	0f 88 b3 00 00 00    	js     80107038 <allocuvm+0x128>
    pte_t* pte = walkpgdir(pgdir,(char*) a, 0);
80106f85:	83 ec 04             	sub    $0x4,%esp
80106f88:	6a 00                	push   $0x0
80106f8a:	56                   	push   %esi
80106f8b:	ff 75 08             	pushl  0x8(%ebp)
80106f8e:	e8 bd fa ff ff       	call   80106a50 <walkpgdir>
    if(pte==0){
80106f93:	83 c4 10             	add    $0x10,%esp
    pte_t* pte = walkpgdir(pgdir,(char*) a, 0);
80106f96:	89 c3                	mov    %eax,%ebx
    if(pte==0){
80106f98:	85 c0                	test   %eax,%eax
80106f9a:	0f 84 db 00 00 00    	je     8010707b <allocuvm+0x16b>
    myproc()->rss+=PGSIZE;
80106fa0:	e8 0b ca ff ff       	call   801039b0 <myproc>
    share_add(V2P(mem),pte);
80106fa5:	83 ec 08             	sub    $0x8,%esp
  for(; a < newsz; a += PGSIZE){
80106fa8:	81 c6 00 10 00 00    	add    $0x1000,%esi
    myproc()->rss+=PGSIZE;
80106fae:	81 40 04 00 10 00 00 	addl   $0x1000,0x4(%eax)
    share_add(V2P(mem),pte);
80106fb5:	53                   	push   %ebx
80106fb6:	57                   	push   %edi
80106fb7:	e8 94 04 00 00       	call   80107450 <share_add>
  for(; a < newsz; a += PGSIZE){
80106fbc:	83 c4 10             	add    $0x10,%esp
80106fbf:	39 75 10             	cmp    %esi,0x10(%ebp)
80106fc2:	76 4f                	jbe    80107013 <allocuvm+0x103>
    mem = kalloc();
80106fc4:	e8 77 b6 ff ff       	call   80102640 <kalloc>
80106fc9:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80106fcb:	85 c0                	test   %eax,%eax
80106fcd:	75 81                	jne    80106f50 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106fcf:	83 ec 0c             	sub    $0xc,%esp
80106fd2:	68 8d 81 10 80       	push   $0x8010818d
80106fd7:	e8 d4 96 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106fdc:	8b 45 0c             	mov    0xc(%ebp),%eax
80106fdf:	83 c4 10             	add    $0x10,%esp
80106fe2:	39 45 10             	cmp    %eax,0x10(%ebp)
80106fe5:	74 39                	je     80107020 <allocuvm+0x110>
80106fe7:	8b 55 10             	mov    0x10(%ebp),%edx
80106fea:	89 c1                	mov    %eax,%ecx
80106fec:	8b 45 08             	mov    0x8(%ebp),%eax
80106fef:	e8 7c fb ff ff       	call   80106b70 <deallocuvm.part.0>
      return 0;
80106ff4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106ffb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106ffe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107001:	5b                   	pop    %ebx
80107002:	5e                   	pop    %esi
80107003:	5f                   	pop    %edi
80107004:	5d                   	pop    %ebp
80107005:	c3                   	ret    
80107006:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010700d:	8d 76 00             	lea    0x0(%esi),%esi
    return oldsz;
80107010:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107013:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107016:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107019:	5b                   	pop    %ebx
8010701a:	5e                   	pop    %esi
8010701b:	5f                   	pop    %edi
8010701c:	5d                   	pop    %ebp
8010701d:	c3                   	ret    
8010701e:	66 90                	xchg   %ax,%ax
    return 0;
80107020:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107027:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010702a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010702d:	5b                   	pop    %ebx
8010702e:	5e                   	pop    %esi
8010702f:	5f                   	pop    %edi
80107030:	5d                   	pop    %ebp
80107031:	c3                   	ret    
80107032:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107038:	83 ec 0c             	sub    $0xc,%esp
8010703b:	68 a5 81 10 80       	push   $0x801081a5
80107040:	e8 6b 96 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80107045:	8b 45 0c             	mov    0xc(%ebp),%eax
80107048:	83 c4 10             	add    $0x10,%esp
8010704b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010704e:	74 0d                	je     8010705d <allocuvm+0x14d>
80107050:	89 c1                	mov    %eax,%ecx
80107052:	8b 55 10             	mov    0x10(%ebp),%edx
80107055:	8b 45 08             	mov    0x8(%ebp),%eax
80107058:	e8 13 fb ff ff       	call   80106b70 <deallocuvm.part.0>
      kfree(mem);
8010705d:	83 ec 0c             	sub    $0xc,%esp
80107060:	53                   	push   %ebx
80107061:	e8 0a b4 ff ff       	call   80102470 <kfree>
      return 0;
80107066:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010706d:	83 c4 10             	add    $0x10,%esp
}
80107070:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107073:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107076:	5b                   	pop    %ebx
80107077:	5e                   	pop    %esi
80107078:	5f                   	pop    %edi
80107079:	5d                   	pop    %ebp
8010707a:	c3                   	ret    
      panic("Page Table of Child is not present");
8010707b:	83 ec 0c             	sub    $0xc,%esp
8010707e:	68 5c 82 10 80       	push   $0x8010825c
80107083:	e8 08 93 ff ff       	call   80100390 <panic>
80107088:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010708f:	90                   	nop

80107090 <deallocuvm>:
{
80107090:	f3 0f 1e fb          	endbr32 
80107094:	55                   	push   %ebp
80107095:	89 e5                	mov    %esp,%ebp
80107097:	8b 55 0c             	mov    0xc(%ebp),%edx
8010709a:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010709d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801070a0:	39 d1                	cmp    %edx,%ecx
801070a2:	73 0c                	jae    801070b0 <deallocuvm+0x20>
}
801070a4:	5d                   	pop    %ebp
801070a5:	e9 c6 fa ff ff       	jmp    80106b70 <deallocuvm.part.0>
801070aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801070b0:	89 d0                	mov    %edx,%eax
801070b2:	5d                   	pop    %ebp
801070b3:	c3                   	ret    
801070b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801070bf:	90                   	nop

801070c0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801070c0:	f3 0f 1e fb          	endbr32 
801070c4:	55                   	push   %ebp
801070c5:	89 e5                	mov    %esp,%ebp
801070c7:	57                   	push   %edi
801070c8:	56                   	push   %esi
801070c9:	53                   	push   %ebx
801070ca:	83 ec 0c             	sub    $0xc,%esp
801070cd:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801070d0:	85 f6                	test   %esi,%esi
801070d2:	74 55                	je     80107129 <freevm+0x69>
  if(newsz >= oldsz)
801070d4:	31 c9                	xor    %ecx,%ecx
801070d6:	ba 00 00 00 80       	mov    $0x80000000,%edx
801070db:	89 f0                	mov    %esi,%eax
801070dd:	89 f3                	mov    %esi,%ebx
801070df:	e8 8c fa ff ff       	call   80106b70 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801070e4:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801070ea:	eb 0b                	jmp    801070f7 <freevm+0x37>
801070ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801070f0:	83 c3 04             	add    $0x4,%ebx
801070f3:	39 df                	cmp    %ebx,%edi
801070f5:	74 23                	je     8010711a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801070f7:	8b 03                	mov    (%ebx),%eax
801070f9:	a8 01                	test   $0x1,%al
801070fb:	74 f3                	je     801070f0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801070fd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107102:	83 ec 0c             	sub    $0xc,%esp
80107105:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107108:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010710d:	50                   	push   %eax
8010710e:	e8 5d b3 ff ff       	call   80102470 <kfree>
80107113:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107116:	39 df                	cmp    %ebx,%edi
80107118:	75 dd                	jne    801070f7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010711a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010711d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107120:	5b                   	pop    %ebx
80107121:	5e                   	pop    %esi
80107122:	5f                   	pop    %edi
80107123:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107124:	e9 47 b3 ff ff       	jmp    80102470 <kfree>
    panic("freevm: no pgdir");
80107129:	83 ec 0c             	sub    $0xc,%esp
8010712c:	68 c1 81 10 80       	push   $0x801081c1
80107131:	e8 5a 92 ff ff       	call   80100390 <panic>
80107136:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010713d:	8d 76 00             	lea    0x0(%esi),%esi

80107140 <setupkvm>:
{
80107140:	f3 0f 1e fb          	endbr32 
80107144:	55                   	push   %ebp
80107145:	89 e5                	mov    %esp,%ebp
80107147:	56                   	push   %esi
80107148:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107149:	e8 f2 b4 ff ff       	call   80102640 <kalloc>
8010714e:	89 c6                	mov    %eax,%esi
80107150:	85 c0                	test   %eax,%eax
80107152:	74 42                	je     80107196 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
80107154:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107157:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
8010715c:	68 00 10 00 00       	push   $0x1000
80107161:	6a 00                	push   $0x0
80107163:	50                   	push   %eax
80107164:	e8 d7 d6 ff ff       	call   80104840 <memset>
80107169:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
8010716c:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010716f:	83 ec 08             	sub    $0x8,%esp
80107172:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107175:	ff 73 0c             	pushl  0xc(%ebx)
80107178:	8b 13                	mov    (%ebx),%edx
8010717a:	50                   	push   %eax
8010717b:	29 c1                	sub    %eax,%ecx
8010717d:	89 f0                	mov    %esi,%eax
8010717f:	e8 5c f9 ff ff       	call   80106ae0 <mappages>
80107184:	83 c4 10             	add    $0x10,%esp
80107187:	85 c0                	test   %eax,%eax
80107189:	78 15                	js     801071a0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010718b:	83 c3 10             	add    $0x10,%ebx
8010718e:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107194:	75 d6                	jne    8010716c <setupkvm+0x2c>
}
80107196:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107199:	89 f0                	mov    %esi,%eax
8010719b:	5b                   	pop    %ebx
8010719c:	5e                   	pop    %esi
8010719d:	5d                   	pop    %ebp
8010719e:	c3                   	ret    
8010719f:	90                   	nop
      freevm(pgdir);
801071a0:	83 ec 0c             	sub    $0xc,%esp
801071a3:	56                   	push   %esi
      return 0;
801071a4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801071a6:	e8 15 ff ff ff       	call   801070c0 <freevm>
      return 0;
801071ab:	83 c4 10             	add    $0x10,%esp
}
801071ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801071b1:	89 f0                	mov    %esi,%eax
801071b3:	5b                   	pop    %ebx
801071b4:	5e                   	pop    %esi
801071b5:	5d                   	pop    %ebp
801071b6:	c3                   	ret    
801071b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071be:	66 90                	xchg   %ax,%ax

801071c0 <kvmalloc>:
{
801071c0:	f3 0f 1e fb          	endbr32 
801071c4:	55                   	push   %ebp
801071c5:	89 e5                	mov    %esp,%ebp
801071c7:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801071ca:	e8 71 ff ff ff       	call   80107140 <setupkvm>
801071cf:	a3 e4 60 11 80       	mov    %eax,0x801160e4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801071d4:	05 00 00 00 80       	add    $0x80000000,%eax
801071d9:	0f 22 d8             	mov    %eax,%cr3
}
801071dc:	c9                   	leave  
801071dd:	c3                   	ret    
801071de:	66 90                	xchg   %ax,%ax

801071e0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801071e0:	f3 0f 1e fb          	endbr32 
801071e4:	55                   	push   %ebp
801071e5:	89 e5                	mov    %esp,%ebp
801071e7:	83 ec 0c             	sub    $0xc,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801071ea:	6a 00                	push   $0x0
801071ec:	ff 75 0c             	pushl  0xc(%ebp)
801071ef:	ff 75 08             	pushl  0x8(%ebp)
801071f2:	e8 59 f8 ff ff       	call   80106a50 <walkpgdir>
  if(pte == 0)
801071f7:	83 c4 10             	add    $0x10,%esp
801071fa:	85 c0                	test   %eax,%eax
801071fc:	74 05                	je     80107203 <clearpteu+0x23>
    panic("clearpteu");
  *pte &= ~PTE_U;
801071fe:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80107201:	c9                   	leave  
80107202:	c3                   	ret    
    panic("clearpteu");
80107203:	83 ec 0c             	sub    $0xc,%esp
80107206:	68 d2 81 10 80       	push   $0x801081d2
8010720b:	e8 80 91 ff ff       	call   80100390 <panic>

80107210 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz, uint pid)
{
80107210:	f3 0f 1e fb          	endbr32 
80107214:	55                   	push   %ebp
80107215:	89 e5                	mov    %esp,%ebp
80107217:	57                   	push   %edi
80107218:	56                   	push   %esi
80107219:	53                   	push   %ebx
8010721a:	83 ec 0c             	sub    $0xc,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
8010721d:	e8 1e ff ff ff       	call   80107140 <setupkvm>
80107222:	89 c7                	mov    %eax,%edi
80107224:	85 c0                	test   %eax,%eax
80107226:	0f 84 a0 00 00 00    	je     801072cc <copyuvm+0xbc>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
8010722c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010722f:	85 c0                	test   %eax,%eax
80107231:	0f 84 a9 00 00 00    	je     801072e0 <copyuvm+0xd0>
80107237:	31 db                	xor    %ebx,%ebx
80107239:	eb 34                	jmp    8010726f <copyuvm+0x5f>
8010723b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010723f:	90                   	nop
    // No need to allocate new pages
    // Just copy page table with same address
    if(mappages(d, (void*)i, PGSIZE, pa, flags) < 0) {
      goto bad;
    }
    pte_t* pte_child = walkpgdir(d,(char*) i, 0);
80107240:	83 ec 04             	sub    $0x4,%esp
80107243:	6a 00                	push   $0x0
80107245:	53                   	push   %ebx
80107246:	57                   	push   %edi
80107247:	e8 04 f8 ff ff       	call   80106a50 <walkpgdir>
    if(pte_child==0){
8010724c:	83 c4 10             	add    $0x10,%esp
8010724f:	85 c0                	test   %eax,%eax
80107251:	0f 84 9e 00 00 00    	je     801072f5 <copyuvm+0xe5>
      panic("Page Table of Child is not present");
    }
    // Page table entry pte_child stores address pa of shared page
    // cprintf("share_add (copyuvm) %d is pa and %d is pte\n",pa, pte_child);
    share_add(pa,pte_child);
80107257:	83 ec 08             	sub    $0x8,%esp
  for(i = 0; i < sz; i += PGSIZE){
8010725a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    share_add(pa,pte_child);
80107260:	50                   	push   %eax
80107261:	56                   	push   %esi
80107262:	e8 e9 01 00 00       	call   80107450 <share_add>
  for(i = 0; i < sz; i += PGSIZE){
80107267:	83 c4 10             	add    $0x10,%esp
8010726a:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
8010726d:	76 71                	jbe    801072e0 <copyuvm+0xd0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
8010726f:	83 ec 04             	sub    $0x4,%esp
80107272:	6a 00                	push   $0x0
80107274:	53                   	push   %ebx
80107275:	ff 75 08             	pushl  0x8(%ebp)
80107278:	e8 d3 f7 ff ff       	call   80106a50 <walkpgdir>
8010727d:	83 c4 10             	add    $0x10,%esp
80107280:	85 c0                	test   %eax,%eax
80107282:	0f 84 87 00 00 00    	je     8010730f <copyuvm+0xff>
    if(!(*pte & PTE_P))
80107288:	8b 10                	mov    (%eax),%edx
8010728a:	f6 c2 01             	test   $0x1,%dl
8010728d:	74 73                	je     80107302 <copyuvm+0xf2>
    pa = PTE_ADDR(*pte);
8010728f:	89 d6                	mov    %edx,%esi
    *pte &= ~PTE_W;
80107291:	89 d1                	mov    %edx,%ecx
    if(mappages(d, (void*)i, PGSIZE, pa, flags) < 0) {
80107293:	83 ec 08             	sub    $0x8,%esp
    flags = PTE_FLAGS(*pte);
80107296:	81 e2 fd 0f 00 00    	and    $0xffd,%edx
    *pte &= ~PTE_W;
8010729c:	83 e1 fd             	and    $0xfffffffd,%ecx
    pa = PTE_ADDR(*pte);
8010729f:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    *pte &= ~PTE_W;
801072a5:	89 08                	mov    %ecx,(%eax)
    if(mappages(d, (void*)i, PGSIZE, pa, flags) < 0) {
801072a7:	b9 00 10 00 00       	mov    $0x1000,%ecx
801072ac:	89 f8                	mov    %edi,%eax
801072ae:	52                   	push   %edx
801072af:	89 da                	mov    %ebx,%edx
801072b1:	56                   	push   %esi
801072b2:	e8 29 f8 ff ff       	call   80106ae0 <mappages>
801072b7:	83 c4 10             	add    $0x10,%esp
801072ba:	85 c0                	test   %eax,%eax
801072bc:	79 82                	jns    80107240 <copyuvm+0x30>
  }
  lcr3(V2P(pgdir));
  return d;

bad:
  freevm(d);
801072be:	83 ec 0c             	sub    $0xc,%esp
801072c1:	57                   	push   %edi
  return 0;
801072c2:	31 ff                	xor    %edi,%edi
  freevm(d);
801072c4:	e8 f7 fd ff ff       	call   801070c0 <freevm>
  return 0;
801072c9:	83 c4 10             	add    $0x10,%esp
}
801072cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072cf:	89 f8                	mov    %edi,%eax
801072d1:	5b                   	pop    %ebx
801072d2:	5e                   	pop    %esi
801072d3:	5f                   	pop    %edi
801072d4:	5d                   	pop    %ebp
801072d5:	c3                   	ret    
801072d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072dd:	8d 76 00             	lea    0x0(%esi),%esi
  lcr3(V2P(pgdir));
801072e0:	8b 45 08             	mov    0x8(%ebp),%eax
801072e3:	05 00 00 00 80       	add    $0x80000000,%eax
801072e8:	0f 22 d8             	mov    %eax,%cr3
}
801072eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072ee:	89 f8                	mov    %edi,%eax
801072f0:	5b                   	pop    %ebx
801072f1:	5e                   	pop    %esi
801072f2:	5f                   	pop    %edi
801072f3:	5d                   	pop    %ebp
801072f4:	c3                   	ret    
      panic("Page Table of Child is not present");
801072f5:	83 ec 0c             	sub    $0xc,%esp
801072f8:	68 5c 82 10 80       	push   $0x8010825c
801072fd:	e8 8e 90 ff ff       	call   80100390 <panic>
      panic("copyuvm: page not present");
80107302:	83 ec 0c             	sub    $0xc,%esp
80107305:	68 f6 81 10 80       	push   $0x801081f6
8010730a:	e8 81 90 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
8010730f:	83 ec 0c             	sub    $0xc,%esp
80107312:	68 dc 81 10 80       	push   $0x801081dc
80107317:	e8 74 90 ff ff       	call   80100390 <panic>
8010731c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107320 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107320:	f3 0f 1e fb          	endbr32 
80107324:	55                   	push   %ebp
80107325:	89 e5                	mov    %esp,%ebp
80107327:	83 ec 0c             	sub    $0xc,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010732a:	6a 00                	push   $0x0
8010732c:	ff 75 0c             	pushl  0xc(%ebp)
8010732f:	ff 75 08             	pushl  0x8(%ebp)
80107332:	e8 19 f7 ff ff       	call   80106a50 <walkpgdir>
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
80107337:	83 c4 10             	add    $0x10,%esp
  if((*pte & PTE_P) == 0)
8010733a:	8b 00                	mov    (%eax),%eax
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
8010733c:	c9                   	leave  
  if((*pte & PTE_U) == 0)
8010733d:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010733f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107344:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107347:	05 00 00 00 80       	add    $0x80000000,%eax
8010734c:	83 fa 05             	cmp    $0x5,%edx
8010734f:	ba 00 00 00 00       	mov    $0x0,%edx
80107354:	0f 45 c2             	cmovne %edx,%eax
}
80107357:	c3                   	ret    
80107358:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010735f:	90                   	nop

80107360 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107360:	f3 0f 1e fb          	endbr32 
80107364:	55                   	push   %ebp
80107365:	89 e5                	mov    %esp,%ebp
80107367:	57                   	push   %edi
80107368:	56                   	push   %esi
80107369:	53                   	push   %ebx
8010736a:	83 ec 0c             	sub    $0xc,%esp
8010736d:	8b 75 14             	mov    0x14(%ebp),%esi
80107370:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107373:	85 f6                	test   %esi,%esi
80107375:	75 3c                	jne    801073b3 <copyout+0x53>
80107377:	eb 67                	jmp    801073e0 <copyout+0x80>
80107379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107380:	8b 55 0c             	mov    0xc(%ebp),%edx
80107383:	89 fb                	mov    %edi,%ebx
80107385:	29 d3                	sub    %edx,%ebx
80107387:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
8010738d:	39 f3                	cmp    %esi,%ebx
8010738f:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107392:	29 fa                	sub    %edi,%edx
80107394:	83 ec 04             	sub    $0x4,%esp
80107397:	01 c2                	add    %eax,%edx
80107399:	53                   	push   %ebx
8010739a:	ff 75 10             	pushl  0x10(%ebp)
8010739d:	52                   	push   %edx
8010739e:	e8 3d d5 ff ff       	call   801048e0 <memmove>
    len -= n;
    buf += n;
801073a3:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
801073a6:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
801073ac:	83 c4 10             	add    $0x10,%esp
801073af:	29 de                	sub    %ebx,%esi
801073b1:	74 2d                	je     801073e0 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
801073b3:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
801073b5:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
801073b8:	89 55 0c             	mov    %edx,0xc(%ebp)
801073bb:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
801073c1:	57                   	push   %edi
801073c2:	ff 75 08             	pushl  0x8(%ebp)
801073c5:	e8 56 ff ff ff       	call   80107320 <uva2ka>
    if(pa0 == 0)
801073ca:	83 c4 10             	add    $0x10,%esp
801073cd:	85 c0                	test   %eax,%eax
801073cf:	75 af                	jne    80107380 <copyout+0x20>
  }
  return 0;
}
801073d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801073d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801073d9:	5b                   	pop    %ebx
801073da:	5e                   	pop    %esi
801073db:	5f                   	pop    %edi
801073dc:	5d                   	pop    %ebp
801073dd:	c3                   	ret    
801073de:	66 90                	xchg   %ax,%ax
801073e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801073e3:	31 c0                	xor    %eax,%eax
}
801073e5:	5b                   	pop    %ebx
801073e6:	5e                   	pop    %esi
801073e7:	5f                   	pop    %edi
801073e8:	5d                   	pop    %ebp
801073e9:	c3                   	ret    
801073ea:	66 90                	xchg   %ax,%ax
801073ec:	66 90                	xchg   %ax,%ax
801073ee:	66 90                	xchg   %ax,%ax

801073f0 <init_rmap>:

struct rmap allmap[PHYSTOP/PGSIZE];


// Initialize rmap 
void init_rmap(void){
801073f0:	f3 0f 1e fb          	endbr32 
801073f4:	55                   	push   %ebp
801073f5:	89 e5                	mov    %esp,%ebp
801073f7:	53                   	push   %ebx
801073f8:	bb 34 63 11 80       	mov    $0x80116334,%ebx
801073fd:	83 ec 04             	sub    $0x4,%esp
  uint sz= PHYSTOP/PGSIZE;
  for(uint i=0; i<sz; i++){
    initlock(&(allmap[i].lock), "rmap");
80107400:	83 ec 08             	sub    $0x8,%esp
80107403:	8d 83 cc fd ff ff    	lea    -0x234(%ebx),%eax
80107409:	68 7f 82 10 80       	push   $0x8010827f
8010740e:	50                   	push   %eax
8010740f:	e8 9c d1 ff ff       	call   801045b0 <initlock>
    (&allmap[i])->ref=0;
80107414:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
    for(uint j=0; j<NPROC; j++){
8010741a:	8d 83 00 ff ff ff    	lea    -0x100(%ebx),%eax
80107420:	83 c4 10             	add    $0x10,%esp
80107423:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107427:	90                   	nop
      (&allmap[i])->free[j]=1;
80107428:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    for(uint j=0; j<NPROC; j++){
8010742e:	83 c0 04             	add    $0x4,%eax
80107431:	39 d8                	cmp    %ebx,%eax
80107433:	75 f3                	jne    80107428 <init_rmap+0x38>
  for(uint i=0; i<sz; i++){
80107435:	8d 98 38 02 00 00    	lea    0x238(%eax),%ebx
8010743b:	3d fc 40 1a 80       	cmp    $0x801a40fc,%eax
80107440:	75 be                	jne    80107400 <init_rmap+0x10>
    }
  }
}
80107442:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107445:	c9                   	leave  
80107446:	c3                   	ret    
80107447:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010744e:	66 90                	xchg   %ax,%ax

80107450 <share_add>:


// Add pte_t* in rmap corresponding to physical page with address pa
void share_add(uint pa, pte_t* pte_child){
80107450:	f3 0f 1e fb          	endbr32 
80107454:	55                   	push   %ebp
80107455:	89 e5                	mov    %esp,%ebp
80107457:	57                   	push   %edi
80107458:	56                   	push   %esi
80107459:	53                   	push   %ebx
8010745a:	83 ec 28             	sub    $0x28,%esp
  // if(*pte_child & PTE_S) panic("page is in swap space");
  uint index= pa/PGSIZE;
8010745d:	8b 75 08             	mov    0x8(%ebp),%esi
void share_add(uint pa, pte_t* pte_child){
80107460:	8b 55 0c             	mov    0xc(%ebp),%edx
  uint index= pa/PGSIZE;
80107463:	c1 ee 0c             	shr    $0xc,%esi
void share_add(uint pa, pte_t* pte_child){
80107466:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80107469:	69 de 38 02 00 00    	imul   $0x238,%esi,%ebx
  struct rmap* cur= &allmap[index];
  acquire(&(cur->lock));
8010746f:	8d bb 00 61 11 80    	lea    -0x7fee9f00(%ebx),%edi
80107475:	57                   	push   %edi
80107476:	e8 b5 d2 ff ff       	call   80104730 <acquire>
  cur->ref++;
  uint i;
  for(i=0; i<NPROC; i++){
8010747b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  cur->ref++;
8010747e:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<NPROC; i++){
80107481:	31 c0                	xor    %eax,%eax
  cur->ref++;
80107483:	83 87 34 02 00 00 01 	addl   $0x1,0x234(%edi)
  for(i=0; i<NPROC; i++){
8010748a:	eb 0c                	jmp    80107498 <share_add+0x48>
8010748c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107490:	83 c0 01             	add    $0x1,%eax
80107493:	83 f8 40             	cmp    $0x40,%eax
80107496:	74 33                	je     801074cb <share_add+0x7b>
    if(cur->free[i]==1) break;
80107498:	83 bc 83 34 62 11 80 	cmpl   $0x1,-0x7fee9dcc(%ebx,%eax,4)
8010749f:	01 
801074a0:	75 ee                	jne    80107490 <share_add+0x40>
  }
  if(i==NPROC){
    panic("rmap filled");
  }
  cur->free[i]=0;
801074a2:	69 f6 8e 00 00 00    	imul   $0x8e,%esi,%esi
  cur->pl[i]= pte_child;
  release(&(cur->lock));
801074a8:	89 7d 08             	mov    %edi,0x8(%ebp)
  cur->free[i]=0;
801074ab:	01 f0                	add    %esi,%eax
801074ad:	c7 04 85 34 62 11 80 	movl   $0x0,-0x7fee9dcc(,%eax,4)
801074b4:	00 00 00 00 
  cur->pl[i]= pte_child;
801074b8:	89 14 85 34 61 11 80 	mov    %edx,-0x7fee9ecc(,%eax,4)
}
801074bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074c2:	5b                   	pop    %ebx
801074c3:	5e                   	pop    %esi
801074c4:	5f                   	pop    %edi
801074c5:	5d                   	pop    %ebp
  release(&(cur->lock));
801074c6:	e9 25 d3 ff ff       	jmp    801047f0 <release>
    panic("rmap filled");
801074cb:	83 ec 0c             	sub    $0xc,%esp
801074ce:	68 84 82 10 80       	push   $0x80108284
801074d3:	e8 b8 8e ff ff       	call   80100390 <panic>
801074d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074df:	90                   	nop

801074e0 <share_remove>:


// Remove pte_t* in rmap corresponding to physical page with address pa
int share_remove(uint pa, pte_t* pte_proc) {
801074e0:	f3 0f 1e fb          	endbr32 
801074e4:	55                   	push   %ebp
801074e5:	89 e5                	mov    %esp,%ebp
801074e7:	57                   	push   %edi
801074e8:	56                   	push   %esi
801074e9:	53                   	push   %ebx
801074ea:	83 ec 18             	sub    $0x18,%esp
  // if(*pte_proc & PTE_S) panic("page is in swap blocks");
  uint index = pa/PGSIZE;
801074ed:	8b 75 08             	mov    0x8(%ebp),%esi
801074f0:	c1 ee 0c             	shr    $0xc,%esi
  struct rmap* cur = &allmap[index];
  acquire(&(cur->lock));
801074f3:	69 de 38 02 00 00    	imul   $0x238,%esi,%ebx
801074f9:	8d bb 00 61 11 80    	lea    -0x7fee9f00(%ebx),%edi
801074ff:	57                   	push   %edi
80107500:	e8 2b d2 ff ff       	call   80104730 <acquire>
  uint i;
  for(i=0; i<NPROC; i++){
80107505:	8b 55 0c             	mov    0xc(%ebp),%edx
  acquire(&(cur->lock));
80107508:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<NPROC; i++){
8010750b:	31 c0                	xor    %eax,%eax
8010750d:	eb 0d                	jmp    8010751c <share_remove+0x3c>
8010750f:	90                   	nop
80107510:	83 c0 01             	add    $0x1,%eax
80107513:	83 f8 40             	cmp    $0x40,%eax
80107516:	0f 84 8c 00 00 00    	je     801075a8 <share_remove+0xc8>
    if(cur->pl[i]==pte_proc && cur->free[i]==0) break;
8010751c:	39 94 83 34 61 11 80 	cmp    %edx,-0x7fee9ecc(%ebx,%eax,4)
80107523:	75 eb                	jne    80107510 <share_remove+0x30>
80107525:	8b 8c 83 34 62 11 80 	mov    -0x7fee9dcc(%ebx,%eax,4),%ecx
8010752c:	85 c9                	test   %ecx,%ecx
8010752e:	75 e0                	jne    80107510 <share_remove+0x30>
  }
  if(i==NPROC) panic("Page table entry not found in rmap");
  cur->free[i]=1;
80107530:	69 d6 8e 00 00 00    	imul   $0x8e,%esi,%edx
80107536:	8d 44 10 4c          	lea    0x4c(%eax,%edx,1),%eax
  cur->ref--;
8010753a:	69 d6 38 02 00 00    	imul   $0x238,%esi,%edx
  cur->free[i]=1;
80107540:	c7 04 85 04 61 11 80 	movl   $0x1,-0x7fee9efc(,%eax,4)
80107547:	01 00 00 00 
  cur->ref--;
8010754b:	8b 82 34 63 11 80    	mov    -0x7fee9ccc(%edx),%eax
80107551:	83 e8 01             	sub    $0x1,%eax
80107554:	89 82 34 63 11 80    	mov    %eax,-0x7fee9ccc(%edx)
  if(cur->ref==1){
8010755a:	83 f8 01             	cmp    $0x1,%eax
8010755d:	74 21                	je     80107580 <share_remove+0xa0>
      if(cur->free[j]==0){
        *(cur->pl[j]) |= PTE_W;
      }
    }
  }
  release(&(cur->lock));
8010755f:	83 ec 0c             	sub    $0xc,%esp
  return cur->ref;
80107562:	69 f6 38 02 00 00    	imul   $0x238,%esi,%esi
  release(&(cur->lock));
80107568:	57                   	push   %edi
80107569:	e8 82 d2 ff ff       	call   801047f0 <release>
  return cur->ref;
8010756e:	8b 86 34 63 11 80    	mov    -0x7fee9ccc(%esi),%eax
}
80107574:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107577:	5b                   	pop    %ebx
80107578:	5e                   	pop    %esi
80107579:	5f                   	pop    %edi
8010757a:	5d                   	pop    %ebp
8010757b:	c3                   	ret    
8010757c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107580:	8d 83 34 61 11 80    	lea    -0x7fee9ecc(%ebx),%eax
80107586:	81 c3 34 62 11 80    	add    $0x80116234,%ebx
8010758c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(cur->free[j]==0){
80107590:	8b 90 00 01 00 00    	mov    0x100(%eax),%edx
80107596:	85 d2                	test   %edx,%edx
80107598:	75 05                	jne    8010759f <share_remove+0xbf>
        *(cur->pl[j]) |= PTE_W;
8010759a:	8b 10                	mov    (%eax),%edx
8010759c:	83 0a 02             	orl    $0x2,(%edx)
    for(uint j=0; j<NPROC; j++){
8010759f:	83 c0 04             	add    $0x4,%eax
801075a2:	39 d8                	cmp    %ebx,%eax
801075a4:	75 ea                	jne    80107590 <share_remove+0xb0>
801075a6:	eb b7                	jmp    8010755f <share_remove+0x7f>
  if(i==NPROC) panic("Page table entry not found in rmap");
801075a8:	83 ec 0c             	sub    $0xc,%esp
801075ab:	68 54 83 10 80       	push   $0x80108354
801075b0:	e8 db 8d ff ff       	call   80100390 <panic>
801075b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801075c0 <share_split>:


// Make separate page for pte_t* trying to write shared page
void share_split(uint pa, pte_t* pte_proc){
801075c0:	f3 0f 1e fb          	endbr32 
801075c4:	55                   	push   %ebp
801075c5:	89 e5                	mov    %esp,%ebp
801075c7:	57                   	push   %edi
801075c8:	56                   	push   %esi
801075c9:	53                   	push   %ebx
801075ca:	83 ec 24             	sub    $0x24,%esp
801075cd:	8b 7d 0c             	mov    0xc(%ebp),%edi
801075d0:	8b 55 08             	mov    0x8(%ebp),%edx
  uint flag= PTE_FLAGS(*pte_proc);
801075d3:	8b 37                	mov    (%edi),%esi
  flag |= PTE_W;
  share_remove(pa,pte_proc);
801075d5:	57                   	push   %edi
801075d6:	52                   	push   %edx
801075d7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  uint flag= PTE_FLAGS(*pte_proc);
801075da:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
  share_remove(pa,pte_proc);
801075e0:	e8 fb fe ff ff       	call   801074e0 <share_remove>
  char* mem= kalloc();
801075e5:	e8 56 b0 ff ff       	call   80102640 <kalloc>
  memmove(mem,(char*)P2V(pa),PGSIZE);
801075ea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801075ed:	83 c4 0c             	add    $0xc,%esp
801075f0:	68 00 10 00 00       	push   $0x1000
  char* mem= kalloc();
801075f5:	89 c3                	mov    %eax,%ebx
  memmove(mem,(char*)P2V(pa),PGSIZE);
801075f7:	81 c2 00 00 00 80    	add    $0x80000000,%edx
  *pte_proc = PTE_ADDR(V2P(mem)) | flag;
801075fd:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
  memmove(mem,(char*)P2V(pa),PGSIZE);
80107603:	52                   	push   %edx
80107604:	50                   	push   %eax
80107605:	e8 d6 d2 ff ff       	call   801048e0 <memmove>
  *pte_proc = PTE_ADDR(V2P(mem)) | flag;
8010760a:	89 d8                	mov    %ebx,%eax
  share_add(V2P(mem),pte_proc);
8010760c:	83 c4 10             	add    $0x10,%esp
  *pte_proc = PTE_ADDR(V2P(mem)) | flag;
8010760f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107614:	09 c6                	or     %eax,%esi
80107616:	83 ce 02             	or     $0x2,%esi
80107619:	89 37                	mov    %esi,(%edi)
  share_add(V2P(mem),pte_proc);
8010761b:	89 7d 0c             	mov    %edi,0xc(%ebp)
8010761e:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80107621:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107624:	5b                   	pop    %ebx
80107625:	5e                   	pop    %esi
80107626:	5f                   	pop    %edi
80107627:	5d                   	pop    %ebp
  share_add(V2P(mem),pte_proc);
80107628:	e9 23 fe ff ff       	jmp    80107450 <share_add>
8010762d:	8d 76 00             	lea    0x0(%esi),%esi

80107630 <handle_page_fault>:


void handle_page_fault()
{
80107630:	f3 0f 1e fb          	endbr32 
80107634:	55                   	push   %ebp
80107635:	89 e5                	mov    %esp,%ebp
80107637:	57                   	push   %edi
80107638:	56                   	push   %esi
80107639:	53                   	push   %ebx
8010763a:	83 ec 18             	sub    $0x18,%esp
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010763d:	0f 20 d7             	mov    %cr2,%edi
    uint va=rcr2();
    // va=PGROUNDDOWN(va);
    cprintf("Entered page fault\n");
80107640:	68 90 82 10 80       	push   $0x80108290
80107645:	e8 66 90 ff ff       	call   801006b0 <cprintf>
    pte_t *pte= walkpgdir(myproc()->pgdir,(char*) va, 0); // to check
8010764a:	e8 61 c3 ff ff       	call   801039b0 <myproc>
8010764f:	8b 58 08             	mov    0x8(%eax),%ebx
  cprintf("Entered walkpagedir\n");
80107652:	c7 04 24 a4 82 10 80 	movl   $0x801082a4,(%esp)
80107659:	e8 52 90 ff ff       	call   801006b0 <cprintf>
  pde = &pgdir[PDX(va)];
8010765e:	89 f8                	mov    %edi,%eax
  if(*pde & PTE_P) {
80107660:	83 c4 10             	add    $0x10,%esp
  pde = &pgdir[PDX(va)];
80107663:	c1 e8 16             	shr    $0x16,%eax
80107666:	8d 1c 83             	lea    (%ebx,%eax,4),%ebx
  if(*pde & PTE_P) {
80107669:	f6 03 01             	testb  $0x1,(%ebx)
8010766c:	0f 84 b4 00 00 00    	je     80107726 <handle_page_fault.cold>
    cprintf("Present\n");
80107672:	83 ec 0c             	sub    $0xc,%esp
  return &pgtab[PTX(va)];
80107675:	c1 ef 0a             	shr    $0xa,%edi
    cprintf("Present\n");
80107678:	68 b9 82 10 80       	push   $0x801082b9
  return &pgtab[PTX(va)];
8010767d:	81 e7 fc 0f 00 00    	and    $0xffc,%edi
    cprintf("Present\n");
80107683:	e8 28 90 ff ff       	call   801006b0 <cprintf>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107688:	8b 1b                	mov    (%ebx),%ebx
  cprintf("Returning from walkpagedir\n");
8010768a:	c7 04 24 c2 82 10 80 	movl   $0x801082c2,(%esp)
80107691:	e8 1a 90 ff ff       	call   801006b0 <cprintf>
    cprintf("returned walkpagedir %d\n", *pte);
80107696:	59                   	pop    %ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107697:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010769d:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
    cprintf("returned walkpagedir %d\n", *pte);
801076a3:	5b                   	pop    %ebx
  return &pgtab[PTX(va)];
801076a4:	01 fe                	add    %edi,%esi
    cprintf("returned walkpagedir %d\n", *pte);
801076a6:	ff 36                	pushl  (%esi)
801076a8:	68 de 82 10 80       	push   $0x801082de
801076ad:	e8 fe 8f ff ff       	call   801006b0 <cprintf>
    cprintf("see,%d\n",(*pte&PTE_W));
801076b2:	5f                   	pop    %edi
801076b3:	58                   	pop    %eax
801076b4:	8b 06                	mov    (%esi),%eax
801076b6:	83 e0 02             	and    $0x2,%eax
801076b9:	50                   	push   %eax
801076ba:	68 f7 82 10 80       	push   $0x801082f7
801076bf:	e8 ec 8f ff ff       	call   801006b0 <cprintf>
    
    if(!(*pte & PTE_W))
801076c4:	83 c4 10             	add    $0x10,%esp
801076c7:	f6 06 02             	testb  $0x2,(%esi)
801076ca:	75 4d                	jne    80107719 <handle_page_fault+0xe9>
    {
      cprintf("Write bit is unset\n");
801076cc:	83 ec 0c             	sub    $0xc,%esp
801076cf:	68 0c 83 10 80       	push   $0x8010830c
801076d4:	e8 d7 8f ff ff       	call   801006b0 <cprintf>
        // update_rmap(myproc()->pid,V2P(new_page));
        // // *pte|=PTE_W;
        // lcr3(V2P(myproc()->pgdir));

      uint pa= PTE_ADDR(*pte);
      share_split(pa,pte);
801076d9:	58                   	pop    %eax
801076da:	5a                   	pop    %edx
801076db:	56                   	push   %esi
      uint pa= PTE_ADDR(*pte);
801076dc:	8b 06                	mov    (%esi),%eax
801076de:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      share_split(pa,pte);
801076e3:	50                   	push   %eax
801076e4:	e8 d7 fe ff ff       	call   801075c0 <share_split>
      lcr3(V2P(myproc()->pgdir));
801076e9:	e8 c2 c2 ff ff       	call   801039b0 <myproc>
801076ee:	8b 40 08             	mov    0x8(%eax),%eax
801076f1:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801076f6:	0f 22 d8             	mov    %eax,%cr3
    }

    else {
      panic("write bit is set");
    }
    cprintf("Returningg page fault\n");
801076f9:	c7 04 24 20 83 10 80 	movl   $0x80108320,(%esp)
80107700:	e8 ab 8f ff ff       	call   801006b0 <cprintf>
    
     cprintf("Returning\n");
80107705:	c7 04 24 37 83 10 80 	movl   $0x80108337,(%esp)
8010770c:	e8 9f 8f ff ff       	call   801006b0 <cprintf>
80107711:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107714:	5b                   	pop    %ebx
80107715:	5e                   	pop    %esi
80107716:	5f                   	pop    %edi
80107717:	5d                   	pop    %ebp
80107718:	c3                   	ret    
      panic("write bit is set");
80107719:	83 ec 0c             	sub    $0xc,%esp
8010771c:	68 42 83 10 80       	push   $0x80108342
80107721:	e8 6a 8c ff ff       	call   80100390 <panic>

80107726 <handle_page_fault.cold>:
    cprintf("Not present\n");
80107726:	83 ec 0c             	sub    $0xc,%esp
80107729:	68 ff 82 10 80       	push   $0x801082ff
8010772e:	e8 7d 8f ff ff       	call   801006b0 <cprintf>
    cprintf("returned walkpagedir %d\n", *pte);
80107733:	a1 00 00 00 00       	mov    0x0,%eax
80107738:	0f 0b                	ud2    
