
_sh:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  return 0;
}

int
main(void)
{
       0:	f3 0f 1e fb          	endbr32 
       4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
       8:	83 e4 f0             	and    $0xfffffff0,%esp
       b:	ff 71 fc             	pushl  -0x4(%ecx)
       e:	55                   	push   %ebp
       f:	89 e5                	mov    %esp,%ebp
      11:	53                   	push   %ebx
      12:	51                   	push   %ecx
  static char buf[100];
  int fd;

  // Ensure that three file descriptors are open.
  while((fd = open("console", O_RDWR)) >= 0){
      13:	eb 08                	jmp    1d <main+0x1d>
      15:	8d 76 00             	lea    0x0(%esi),%esi
    if(fd >= 3){
      18:	83 f8 02             	cmp    $0x2,%eax
      1b:	7f 7d                	jg     9a <main+0x9a>
  while((fd = open("console", O_RDWR)) >= 0){
      1d:	83 ec 08             	sub    $0x8,%esp
      20:	6a 02                	push   $0x2
      22:	68 e1 12 00 00       	push   $0x12e1
      27:	e8 77 0d 00 00       	call   da3 <open>
      2c:	83 c4 10             	add    $0x10,%esp
      2f:	85 c0                	test   %eax,%eax
      31:	79 e5                	jns    18 <main+0x18>
      33:	eb 36                	jmp    6b <main+0x6b>
      35:	8d 76 00             	lea    0x0(%esi),%esi
    }
  }

  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
      38:	80 3d 42 19 00 00 20 	cmpb   $0x20,0x1942
      3f:	74 7c                	je     bd <main+0xbd>
      41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      buf[strlen(buf)-1] = 0;  // chop \n
      if(chdir(buf+3) < 0)
        printf(2, "cannot cd %s\n", buf+3);
      continue;
    }
    int id = fork1();
      48:	e8 23 01 00 00       	call   170 <fork1>
    printf(1, "pid2: %d\n", id);
      4d:	83 ec 04             	sub    $0x4,%esp
      50:	50                   	push   %eax
    int id = fork1();
      51:	89 c3                	mov    %eax,%ebx
    printf(1, "pid2: %d\n", id);
      53:	68 f7 12 00 00       	push   $0x12f7
      58:	6a 01                	push   $0x1
      5a:	e8 71 0e 00 00       	call   ed0 <printf>
    if(id == 0){
      5f:	83 c4 10             	add    $0x10,%esp
      62:	85 db                	test   %ebx,%ebx
      64:	74 42                	je     a8 <main+0xa8>
      
      runcmd(parsecmd(buf));
    }
    wait();
      66:	e8 00 0d 00 00       	call   d6b <wait>
  while(getcmd(buf, sizeof(buf)) >= 0){
      6b:	83 ec 08             	sub    $0x8,%esp
      6e:	6a 64                	push   $0x64
      70:	68 40 19 00 00       	push   $0x1940
      75:	e8 86 00 00 00       	call   100 <getcmd>
      7a:	83 c4 10             	add    $0x10,%esp
      7d:	85 c0                	test   %eax,%eax
      7f:	78 14                	js     95 <main+0x95>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
      81:	80 3d 40 19 00 00 63 	cmpb   $0x63,0x1940
      88:	75 be                	jne    48 <main+0x48>
      8a:	80 3d 41 19 00 00 64 	cmpb   $0x64,0x1941
      91:	75 b5                	jne    48 <main+0x48>
      93:	eb a3                	jmp    38 <main+0x38>
  }
  exit();
      95:	e8 c9 0c 00 00       	call   d63 <exit>
      close(fd);
      9a:	83 ec 0c             	sub    $0xc,%esp
      9d:	50                   	push   %eax
      9e:	e8 e8 0c 00 00       	call   d8b <close>
      break;
      a3:	83 c4 10             	add    $0x10,%esp
      a6:	eb c3                	jmp    6b <main+0x6b>
      runcmd(parsecmd(buf));
      a8:	83 ec 0c             	sub    $0xc,%esp
      ab:	68 40 19 00 00       	push   $0x1940
      b0:	e8 db 09 00 00       	call   a90 <parsecmd>
      b5:	89 04 24             	mov    %eax,(%esp)
      b8:	e8 f3 00 00 00       	call   1b0 <runcmd>
      buf[strlen(buf)-1] = 0;  // chop \n
      bd:	83 ec 0c             	sub    $0xc,%esp
      c0:	68 40 19 00 00       	push   $0x1940
      c5:	e8 b6 0a 00 00       	call   b80 <strlen>
      if(chdir(buf+3) < 0)
      ca:	c7 04 24 43 19 00 00 	movl   $0x1943,(%esp)
      buf[strlen(buf)-1] = 0;  // chop \n
      d1:	c6 80 3f 19 00 00 00 	movb   $0x0,0x193f(%eax)
      if(chdir(buf+3) < 0)
      d8:	e8 f6 0c 00 00       	call   dd3 <chdir>
      dd:	83 c4 10             	add    $0x10,%esp
      e0:	85 c0                	test   %eax,%eax
      e2:	79 87                	jns    6b <main+0x6b>
        printf(2, "cannot cd %s\n", buf+3);
      e4:	50                   	push   %eax
      e5:	68 43 19 00 00       	push   $0x1943
      ea:	68 e9 12 00 00       	push   $0x12e9
      ef:	6a 02                	push   $0x2
      f1:	e8 da 0d 00 00       	call   ed0 <printf>
      f6:	83 c4 10             	add    $0x10,%esp
      f9:	e9 6d ff ff ff       	jmp    6b <main+0x6b>
      fe:	66 90                	xchg   %ax,%ax

00000100 <getcmd>:
{
     100:	f3 0f 1e fb          	endbr32 
     104:	55                   	push   %ebp
     105:	89 e5                	mov    %esp,%ebp
     107:	56                   	push   %esi
     108:	53                   	push   %ebx
     109:	8b 75 0c             	mov    0xc(%ebp),%esi
     10c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  printf(2, "$ ");
     10f:	83 ec 08             	sub    $0x8,%esp
     112:	68 38 12 00 00       	push   $0x1238
     117:	6a 02                	push   $0x2
     119:	e8 b2 0d 00 00       	call   ed0 <printf>
  memset(buf, 0, nbuf);
     11e:	83 c4 0c             	add    $0xc,%esp
     121:	56                   	push   %esi
     122:	6a 00                	push   $0x0
     124:	53                   	push   %ebx
     125:	e8 96 0a 00 00       	call   bc0 <memset>
  gets(buf, nbuf);
     12a:	58                   	pop    %eax
     12b:	5a                   	pop    %edx
     12c:	56                   	push   %esi
     12d:	53                   	push   %ebx
     12e:	e8 ed 0a 00 00       	call   c20 <gets>
  if(buf[0] == 0) // EOF
     133:	83 c4 10             	add    $0x10,%esp
     136:	31 c0                	xor    %eax,%eax
     138:	80 3b 00             	cmpb   $0x0,(%ebx)
     13b:	0f 94 c0             	sete   %al
}
     13e:	8d 65 f8             	lea    -0x8(%ebp),%esp
     141:	5b                   	pop    %ebx
  if(buf[0] == 0) // EOF
     142:	f7 d8                	neg    %eax
}
     144:	5e                   	pop    %esi
     145:	5d                   	pop    %ebp
     146:	c3                   	ret    
     147:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     14e:	66 90                	xchg   %ax,%ax

00000150 <panic>:
}

void
panic(char *s)
{
     150:	f3 0f 1e fb          	endbr32 
     154:	55                   	push   %ebp
     155:	89 e5                	mov    %esp,%ebp
     157:	83 ec 0c             	sub    $0xc,%esp
  printf(2, "%s\n", s);
     15a:	ff 75 08             	pushl  0x8(%ebp)
     15d:	68 dd 12 00 00       	push   $0x12dd
     162:	6a 02                	push   $0x2
     164:	e8 67 0d 00 00       	call   ed0 <printf>
  exit();
     169:	e8 f5 0b 00 00       	call   d63 <exit>
     16e:	66 90                	xchg   %ax,%ax

00000170 <fork1>:
}

int
fork1(void)
{
     170:	f3 0f 1e fb          	endbr32 
     174:	55                   	push   %ebp
     175:	89 e5                	mov    %esp,%ebp
     177:	53                   	push   %ebx
     178:	83 ec 04             	sub    $0x4,%esp
  int pid;

  pid = fork();
     17b:	e8 db 0b 00 00       	call   d5b <fork>
  printf(1, "PID %d\n", pid);
     180:	83 ec 04             	sub    $0x4,%esp
     183:	50                   	push   %eax
  pid = fork();
     184:	89 c3                	mov    %eax,%ebx
  printf(1, "PID %d\n", pid);
     186:	68 3b 12 00 00       	push   $0x123b
     18b:	6a 01                	push   $0x1
     18d:	e8 3e 0d 00 00       	call   ed0 <printf>
  if(pid == -1)
     192:	83 c4 10             	add    $0x10,%esp
     195:	83 fb ff             	cmp    $0xffffffff,%ebx
     198:	74 07                	je     1a1 <fork1+0x31>
    panic("fork");
  return pid;
}
     19a:	89 d8                	mov    %ebx,%eax
     19c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     19f:	c9                   	leave  
     1a0:	c3                   	ret    
    panic("fork");
     1a1:	83 ec 0c             	sub    $0xc,%esp
     1a4:	68 43 12 00 00       	push   $0x1243
     1a9:	e8 a2 ff ff ff       	call   150 <panic>
     1ae:	66 90                	xchg   %ax,%ax

000001b0 <runcmd>:
{
     1b0:	f3 0f 1e fb          	endbr32 
     1b4:	55                   	push   %ebp
     1b5:	89 e5                	mov    %esp,%ebp
     1b7:	53                   	push   %ebx
     1b8:	83 ec 14             	sub    $0x14,%esp
     1bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(cmd == 0)
     1be:	85 db                	test   %ebx,%ebx
     1c0:	74 6e                	je     230 <runcmd+0x80>
  switch(cmd->type){
     1c2:	83 3b 05             	cmpl   $0x5,(%ebx)
     1c5:	0f 87 e2 00 00 00    	ja     2ad <runcmd+0xfd>
     1cb:	8b 03                	mov    (%ebx),%eax
     1cd:	3e ff 24 85 04 13 00 	notrack jmp *0x1304(,%eax,4)
     1d4:	00 
    if(pipe(p) < 0)
     1d5:	83 ec 0c             	sub    $0xc,%esp
     1d8:	8d 45 f0             	lea    -0x10(%ebp),%eax
     1db:	50                   	push   %eax
     1dc:	e8 92 0b 00 00       	call   d73 <pipe>
     1e1:	83 c4 10             	add    $0x10,%esp
     1e4:	85 c0                	test   %eax,%eax
     1e6:	0f 88 e3 00 00 00    	js     2cf <runcmd+0x11f>
    if(fork1() == 0){
     1ec:	e8 7f ff ff ff       	call   170 <fork1>
     1f1:	85 c0                	test   %eax,%eax
     1f3:	0f 84 e3 00 00 00    	je     2dc <runcmd+0x12c>
    if(fork1() == 0){
     1f9:	e8 72 ff ff ff       	call   170 <fork1>
     1fe:	85 c0                	test   %eax,%eax
     200:	0f 84 04 01 00 00    	je     30a <runcmd+0x15a>
    close(p[0]);
     206:	83 ec 0c             	sub    $0xc,%esp
     209:	ff 75 f0             	pushl  -0x10(%ebp)
     20c:	e8 7a 0b 00 00       	call   d8b <close>
    close(p[1]);
     211:	58                   	pop    %eax
     212:	ff 75 f4             	pushl  -0xc(%ebp)
     215:	e8 71 0b 00 00       	call   d8b <close>
    wait();
     21a:	e8 4c 0b 00 00       	call   d6b <wait>
    wait();
     21f:	e8 47 0b 00 00       	call   d6b <wait>
    break;
     224:	83 c4 10             	add    $0x10,%esp
     227:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     22e:	66 90                	xchg   %ax,%ax
    exit();
     230:	e8 2e 0b 00 00       	call   d63 <exit>
    if(fork1() == 0)
     235:	e8 36 ff ff ff       	call   170 <fork1>
     23a:	85 c0                	test   %eax,%eax
     23c:	75 f2                	jne    230 <runcmd+0x80>
     23e:	eb 62                	jmp    2a2 <runcmd+0xf2>
    if(ecmd->argv[0] == 0)
     240:	8b 43 04             	mov    0x4(%ebx),%eax
     243:	85 c0                	test   %eax,%eax
     245:	74 e9                	je     230 <runcmd+0x80>
    exec(ecmd->argv[0], ecmd->argv);
     247:	8d 53 04             	lea    0x4(%ebx),%edx
     24a:	51                   	push   %ecx
     24b:	51                   	push   %ecx
     24c:	52                   	push   %edx
     24d:	50                   	push   %eax
     24e:	e8 48 0b 00 00       	call   d9b <exec>
    printf(2, "exec %s failed\n", ecmd->argv[0]);
     253:	83 c4 0c             	add    $0xc,%esp
     256:	ff 73 04             	pushl  0x4(%ebx)
     259:	68 4f 12 00 00       	push   $0x124f
     25e:	6a 02                	push   $0x2
     260:	e8 6b 0c 00 00       	call   ed0 <printf>
    break;
     265:	83 c4 10             	add    $0x10,%esp
     268:	eb c6                	jmp    230 <runcmd+0x80>
    if(fork1() == 0)
     26a:	e8 01 ff ff ff       	call   170 <fork1>
     26f:	85 c0                	test   %eax,%eax
     271:	74 2f                	je     2a2 <runcmd+0xf2>
    wait();
     273:	e8 f3 0a 00 00       	call   d6b <wait>
    runcmd(lcmd->right);
     278:	83 ec 0c             	sub    $0xc,%esp
     27b:	ff 73 08             	pushl  0x8(%ebx)
     27e:	e8 2d ff ff ff       	call   1b0 <runcmd>
    close(rcmd->fd);
     283:	83 ec 0c             	sub    $0xc,%esp
     286:	ff 73 14             	pushl  0x14(%ebx)
     289:	e8 fd 0a 00 00       	call   d8b <close>
    if(open(rcmd->file, rcmd->mode) < 0){
     28e:	58                   	pop    %eax
     28f:	5a                   	pop    %edx
     290:	ff 73 10             	pushl  0x10(%ebx)
     293:	ff 73 08             	pushl  0x8(%ebx)
     296:	e8 08 0b 00 00       	call   da3 <open>
     29b:	83 c4 10             	add    $0x10,%esp
     29e:	85 c0                	test   %eax,%eax
     2a0:	78 18                	js     2ba <runcmd+0x10a>
      runcmd(bcmd->cmd);
     2a2:	83 ec 0c             	sub    $0xc,%esp
     2a5:	ff 73 04             	pushl  0x4(%ebx)
     2a8:	e8 03 ff ff ff       	call   1b0 <runcmd>
    panic("runcmd");
     2ad:	83 ec 0c             	sub    $0xc,%esp
     2b0:	68 48 12 00 00       	push   $0x1248
     2b5:	e8 96 fe ff ff       	call   150 <panic>
      printf(2, "open %s failed\n", rcmd->file);
     2ba:	51                   	push   %ecx
     2bb:	ff 73 08             	pushl  0x8(%ebx)
     2be:	68 5f 12 00 00       	push   $0x125f
     2c3:	6a 02                	push   $0x2
     2c5:	e8 06 0c 00 00       	call   ed0 <printf>
      exit();
     2ca:	e8 94 0a 00 00       	call   d63 <exit>
      panic("pipe");
     2cf:	83 ec 0c             	sub    $0xc,%esp
     2d2:	68 6f 12 00 00       	push   $0x126f
     2d7:	e8 74 fe ff ff       	call   150 <panic>
      close(1);
     2dc:	83 ec 0c             	sub    $0xc,%esp
     2df:	6a 01                	push   $0x1
     2e1:	e8 a5 0a 00 00       	call   d8b <close>
      dup(p[1]);
     2e6:	58                   	pop    %eax
     2e7:	ff 75 f4             	pushl  -0xc(%ebp)
     2ea:	e8 ec 0a 00 00       	call   ddb <dup>
      close(p[0]);
     2ef:	58                   	pop    %eax
     2f0:	ff 75 f0             	pushl  -0x10(%ebp)
     2f3:	e8 93 0a 00 00       	call   d8b <close>
      close(p[1]);
     2f8:	58                   	pop    %eax
     2f9:	ff 75 f4             	pushl  -0xc(%ebp)
     2fc:	e8 8a 0a 00 00       	call   d8b <close>
      runcmd(pcmd->left);
     301:	5a                   	pop    %edx
     302:	ff 73 04             	pushl  0x4(%ebx)
     305:	e8 a6 fe ff ff       	call   1b0 <runcmd>
      close(0);
     30a:	83 ec 0c             	sub    $0xc,%esp
     30d:	6a 00                	push   $0x0
     30f:	e8 77 0a 00 00       	call   d8b <close>
      dup(p[0]);
     314:	5a                   	pop    %edx
     315:	ff 75 f0             	pushl  -0x10(%ebp)
     318:	e8 be 0a 00 00       	call   ddb <dup>
      close(p[0]);
     31d:	59                   	pop    %ecx
     31e:	ff 75 f0             	pushl  -0x10(%ebp)
     321:	e8 65 0a 00 00       	call   d8b <close>
      close(p[1]);
     326:	58                   	pop    %eax
     327:	ff 75 f4             	pushl  -0xc(%ebp)
     32a:	e8 5c 0a 00 00       	call   d8b <close>
      runcmd(pcmd->right);
     32f:	58                   	pop    %eax
     330:	ff 73 08             	pushl  0x8(%ebx)
     333:	e8 78 fe ff ff       	call   1b0 <runcmd>
     338:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     33f:	90                   	nop

00000340 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     340:	f3 0f 1e fb          	endbr32 
     344:	55                   	push   %ebp
     345:	89 e5                	mov    %esp,%ebp
     347:	53                   	push   %ebx
     348:	83 ec 10             	sub    $0x10,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     34b:	6a 54                	push   $0x54
     34d:	e8 de 0d 00 00       	call   1130 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     352:	83 c4 0c             	add    $0xc,%esp
     355:	6a 54                	push   $0x54
  cmd = malloc(sizeof(*cmd));
     357:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     359:	6a 00                	push   $0x0
     35b:	50                   	push   %eax
     35c:	e8 5f 08 00 00       	call   bc0 <memset>
  cmd->type = EXEC;
     361:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  return (struct cmd*)cmd;
}
     367:	89 d8                	mov    %ebx,%eax
     369:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     36c:	c9                   	leave  
     36d:	c3                   	ret    
     36e:	66 90                	xchg   %ax,%ax

00000370 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     370:	f3 0f 1e fb          	endbr32 
     374:	55                   	push   %ebp
     375:	89 e5                	mov    %esp,%ebp
     377:	53                   	push   %ebx
     378:	83 ec 10             	sub    $0x10,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     37b:	6a 18                	push   $0x18
     37d:	e8 ae 0d 00 00       	call   1130 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     382:	83 c4 0c             	add    $0xc,%esp
     385:	6a 18                	push   $0x18
  cmd = malloc(sizeof(*cmd));
     387:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     389:	6a 00                	push   $0x0
     38b:	50                   	push   %eax
     38c:	e8 2f 08 00 00       	call   bc0 <memset>
  cmd->type = REDIR;
  cmd->cmd = subcmd;
     391:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = REDIR;
     394:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  cmd->cmd = subcmd;
     39a:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->file = file;
     39d:	8b 45 0c             	mov    0xc(%ebp),%eax
     3a0:	89 43 08             	mov    %eax,0x8(%ebx)
  cmd->efile = efile;
     3a3:	8b 45 10             	mov    0x10(%ebp),%eax
     3a6:	89 43 0c             	mov    %eax,0xc(%ebx)
  cmd->mode = mode;
     3a9:	8b 45 14             	mov    0x14(%ebp),%eax
     3ac:	89 43 10             	mov    %eax,0x10(%ebx)
  cmd->fd = fd;
     3af:	8b 45 18             	mov    0x18(%ebp),%eax
     3b2:	89 43 14             	mov    %eax,0x14(%ebx)
  return (struct cmd*)cmd;
}
     3b5:	89 d8                	mov    %ebx,%eax
     3b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     3ba:	c9                   	leave  
     3bb:	c3                   	ret    
     3bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000003c0 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     3c0:	f3 0f 1e fb          	endbr32 
     3c4:	55                   	push   %ebp
     3c5:	89 e5                	mov    %esp,%ebp
     3c7:	53                   	push   %ebx
     3c8:	83 ec 10             	sub    $0x10,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3cb:	6a 0c                	push   $0xc
     3cd:	e8 5e 0d 00 00       	call   1130 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     3d2:	83 c4 0c             	add    $0xc,%esp
     3d5:	6a 0c                	push   $0xc
  cmd = malloc(sizeof(*cmd));
     3d7:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     3d9:	6a 00                	push   $0x0
     3db:	50                   	push   %eax
     3dc:	e8 df 07 00 00       	call   bc0 <memset>
  cmd->type = PIPE;
  cmd->left = left;
     3e1:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = PIPE;
     3e4:	c7 03 03 00 00 00    	movl   $0x3,(%ebx)
  cmd->left = left;
     3ea:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
     3ed:	8b 45 0c             	mov    0xc(%ebp),%eax
     3f0:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
     3f3:	89 d8                	mov    %ebx,%eax
     3f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     3f8:	c9                   	leave  
     3f9:	c3                   	ret    
     3fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000400 <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     400:	f3 0f 1e fb          	endbr32 
     404:	55                   	push   %ebp
     405:	89 e5                	mov    %esp,%ebp
     407:	53                   	push   %ebx
     408:	83 ec 10             	sub    $0x10,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     40b:	6a 0c                	push   $0xc
     40d:	e8 1e 0d 00 00       	call   1130 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     412:	83 c4 0c             	add    $0xc,%esp
     415:	6a 0c                	push   $0xc
  cmd = malloc(sizeof(*cmd));
     417:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     419:	6a 00                	push   $0x0
     41b:	50                   	push   %eax
     41c:	e8 9f 07 00 00       	call   bc0 <memset>
  cmd->type = LIST;
  cmd->left = left;
     421:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = LIST;
     424:	c7 03 04 00 00 00    	movl   $0x4,(%ebx)
  cmd->left = left;
     42a:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
     42d:	8b 45 0c             	mov    0xc(%ebp),%eax
     430:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
     433:	89 d8                	mov    %ebx,%eax
     435:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     438:	c9                   	leave  
     439:	c3                   	ret    
     43a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000440 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     440:	f3 0f 1e fb          	endbr32 
     444:	55                   	push   %ebp
     445:	89 e5                	mov    %esp,%ebp
     447:	53                   	push   %ebx
     448:	83 ec 10             	sub    $0x10,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     44b:	6a 08                	push   $0x8
     44d:	e8 de 0c 00 00       	call   1130 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     452:	83 c4 0c             	add    $0xc,%esp
     455:	6a 08                	push   $0x8
  cmd = malloc(sizeof(*cmd));
     457:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     459:	6a 00                	push   $0x0
     45b:	50                   	push   %eax
     45c:	e8 5f 07 00 00       	call   bc0 <memset>
  cmd->type = BACK;
  cmd->cmd = subcmd;
     461:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = BACK;
     464:	c7 03 05 00 00 00    	movl   $0x5,(%ebx)
  cmd->cmd = subcmd;
     46a:	89 43 04             	mov    %eax,0x4(%ebx)
  return (struct cmd*)cmd;
}
     46d:	89 d8                	mov    %ebx,%eax
     46f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     472:	c9                   	leave  
     473:	c3                   	ret    
     474:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     47b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     47f:	90                   	nop

00000480 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     480:	f3 0f 1e fb          	endbr32 
     484:	55                   	push   %ebp
     485:	89 e5                	mov    %esp,%ebp
     487:	57                   	push   %edi
     488:	56                   	push   %esi
     489:	53                   	push   %ebx
     48a:	83 ec 0c             	sub    $0xc,%esp
  char *s;
  int ret;

  s = *ps;
     48d:	8b 45 08             	mov    0x8(%ebp),%eax
{
     490:	8b 5d 0c             	mov    0xc(%ebp),%ebx
     493:	8b 75 10             	mov    0x10(%ebp),%esi
  s = *ps;
     496:	8b 38                	mov    (%eax),%edi
  while(s < es && strchr(whitespace, *s))
     498:	39 df                	cmp    %ebx,%edi
     49a:	72 0b                	jb     4a7 <gettoken+0x27>
     49c:	eb 21                	jmp    4bf <gettoken+0x3f>
     49e:	66 90                	xchg   %ax,%ax
    s++;
     4a0:	83 c7 01             	add    $0x1,%edi
  while(s < es && strchr(whitespace, *s))
     4a3:	39 fb                	cmp    %edi,%ebx
     4a5:	74 18                	je     4bf <gettoken+0x3f>
     4a7:	0f be 07             	movsbl (%edi),%eax
     4aa:	83 ec 08             	sub    $0x8,%esp
     4ad:	50                   	push   %eax
     4ae:	68 1c 19 00 00       	push   $0x191c
     4b3:	e8 28 07 00 00       	call   be0 <strchr>
     4b8:	83 c4 10             	add    $0x10,%esp
     4bb:	85 c0                	test   %eax,%eax
     4bd:	75 e1                	jne    4a0 <gettoken+0x20>
  if(q)
     4bf:	85 f6                	test   %esi,%esi
     4c1:	74 02                	je     4c5 <gettoken+0x45>
    *q = s;
     4c3:	89 3e                	mov    %edi,(%esi)
  ret = *s;
     4c5:	0f b6 07             	movzbl (%edi),%eax
  switch(*s){
     4c8:	3c 3c                	cmp    $0x3c,%al
     4ca:	0f 8f d0 00 00 00    	jg     5a0 <gettoken+0x120>
     4d0:	3c 3a                	cmp    $0x3a,%al
     4d2:	0f 8f b4 00 00 00    	jg     58c <gettoken+0x10c>
     4d8:	84 c0                	test   %al,%al
     4da:	75 44                	jne    520 <gettoken+0xa0>
     4dc:	31 f6                	xor    %esi,%esi
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     4de:	8b 55 14             	mov    0x14(%ebp),%edx
     4e1:	85 d2                	test   %edx,%edx
     4e3:	74 05                	je     4ea <gettoken+0x6a>
    *eq = s;
     4e5:	8b 45 14             	mov    0x14(%ebp),%eax
     4e8:	89 38                	mov    %edi,(%eax)

  while(s < es && strchr(whitespace, *s))
     4ea:	39 df                	cmp    %ebx,%edi
     4ec:	72 09                	jb     4f7 <gettoken+0x77>
     4ee:	eb 1f                	jmp    50f <gettoken+0x8f>
    s++;
     4f0:	83 c7 01             	add    $0x1,%edi
  while(s < es && strchr(whitespace, *s))
     4f3:	39 fb                	cmp    %edi,%ebx
     4f5:	74 18                	je     50f <gettoken+0x8f>
     4f7:	0f be 07             	movsbl (%edi),%eax
     4fa:	83 ec 08             	sub    $0x8,%esp
     4fd:	50                   	push   %eax
     4fe:	68 1c 19 00 00       	push   $0x191c
     503:	e8 d8 06 00 00       	call   be0 <strchr>
     508:	83 c4 10             	add    $0x10,%esp
     50b:	85 c0                	test   %eax,%eax
     50d:	75 e1                	jne    4f0 <gettoken+0x70>
  *ps = s;
     50f:	8b 45 08             	mov    0x8(%ebp),%eax
     512:	89 38                	mov    %edi,(%eax)
  return ret;
}
     514:	8d 65 f4             	lea    -0xc(%ebp),%esp
     517:	89 f0                	mov    %esi,%eax
     519:	5b                   	pop    %ebx
     51a:	5e                   	pop    %esi
     51b:	5f                   	pop    %edi
     51c:	5d                   	pop    %ebp
     51d:	c3                   	ret    
     51e:	66 90                	xchg   %ax,%ax
  switch(*s){
     520:	79 5e                	jns    580 <gettoken+0x100>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     522:	39 fb                	cmp    %edi,%ebx
     524:	77 34                	ja     55a <gettoken+0xda>
  if(eq)
     526:	8b 45 14             	mov    0x14(%ebp),%eax
     529:	be 61 00 00 00       	mov    $0x61,%esi
     52e:	85 c0                	test   %eax,%eax
     530:	75 b3                	jne    4e5 <gettoken+0x65>
     532:	eb db                	jmp    50f <gettoken+0x8f>
     534:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     538:	0f be 07             	movsbl (%edi),%eax
     53b:	83 ec 08             	sub    $0x8,%esp
     53e:	50                   	push   %eax
     53f:	68 14 19 00 00       	push   $0x1914
     544:	e8 97 06 00 00       	call   be0 <strchr>
     549:	83 c4 10             	add    $0x10,%esp
     54c:	85 c0                	test   %eax,%eax
     54e:	75 22                	jne    572 <gettoken+0xf2>
      s++;
     550:	83 c7 01             	add    $0x1,%edi
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     553:	39 fb                	cmp    %edi,%ebx
     555:	74 cf                	je     526 <gettoken+0xa6>
     557:	0f b6 07             	movzbl (%edi),%eax
     55a:	83 ec 08             	sub    $0x8,%esp
     55d:	0f be f0             	movsbl %al,%esi
     560:	56                   	push   %esi
     561:	68 1c 19 00 00       	push   $0x191c
     566:	e8 75 06 00 00       	call   be0 <strchr>
     56b:	83 c4 10             	add    $0x10,%esp
     56e:	85 c0                	test   %eax,%eax
     570:	74 c6                	je     538 <gettoken+0xb8>
    ret = 'a';
     572:	be 61 00 00 00       	mov    $0x61,%esi
     577:	e9 62 ff ff ff       	jmp    4de <gettoken+0x5e>
     57c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  switch(*s){
     580:	3c 26                	cmp    $0x26,%al
     582:	74 08                	je     58c <gettoken+0x10c>
     584:	8d 48 d8             	lea    -0x28(%eax),%ecx
     587:	80 f9 01             	cmp    $0x1,%cl
     58a:	77 96                	ja     522 <gettoken+0xa2>
  ret = *s;
     58c:	0f be f0             	movsbl %al,%esi
    s++;
     58f:	83 c7 01             	add    $0x1,%edi
    break;
     592:	e9 47 ff ff ff       	jmp    4de <gettoken+0x5e>
     597:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     59e:	66 90                	xchg   %ax,%ax
  switch(*s){
     5a0:	3c 3e                	cmp    $0x3e,%al
     5a2:	75 1c                	jne    5c0 <gettoken+0x140>
    if(*s == '>'){
     5a4:	80 7f 01 3e          	cmpb   $0x3e,0x1(%edi)
    s++;
     5a8:	8d 47 01             	lea    0x1(%edi),%eax
    if(*s == '>'){
     5ab:	74 1c                	je     5c9 <gettoken+0x149>
    s++;
     5ad:	89 c7                	mov    %eax,%edi
     5af:	be 3e 00 00 00       	mov    $0x3e,%esi
     5b4:	e9 25 ff ff ff       	jmp    4de <gettoken+0x5e>
     5b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  switch(*s){
     5c0:	3c 7c                	cmp    $0x7c,%al
     5c2:	74 c8                	je     58c <gettoken+0x10c>
     5c4:	e9 59 ff ff ff       	jmp    522 <gettoken+0xa2>
      s++;
     5c9:	83 c7 02             	add    $0x2,%edi
      ret = '+';
     5cc:	be 2b 00 00 00       	mov    $0x2b,%esi
     5d1:	e9 08 ff ff ff       	jmp    4de <gettoken+0x5e>
     5d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     5dd:	8d 76 00             	lea    0x0(%esi),%esi

000005e0 <peek>:

int
peek(char **ps, char *es, char *toks)
{
     5e0:	f3 0f 1e fb          	endbr32 
     5e4:	55                   	push   %ebp
     5e5:	89 e5                	mov    %esp,%ebp
     5e7:	57                   	push   %edi
     5e8:	56                   	push   %esi
     5e9:	53                   	push   %ebx
     5ea:	83 ec 0c             	sub    $0xc,%esp
     5ed:	8b 7d 08             	mov    0x8(%ebp),%edi
     5f0:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *s;

  s = *ps;
     5f3:	8b 1f                	mov    (%edi),%ebx
  while(s < es && strchr(whitespace, *s))
     5f5:	39 f3                	cmp    %esi,%ebx
     5f7:	72 0e                	jb     607 <peek+0x27>
     5f9:	eb 24                	jmp    61f <peek+0x3f>
     5fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     5ff:	90                   	nop
    s++;
     600:	83 c3 01             	add    $0x1,%ebx
  while(s < es && strchr(whitespace, *s))
     603:	39 de                	cmp    %ebx,%esi
     605:	74 18                	je     61f <peek+0x3f>
     607:	0f be 03             	movsbl (%ebx),%eax
     60a:	83 ec 08             	sub    $0x8,%esp
     60d:	50                   	push   %eax
     60e:	68 1c 19 00 00       	push   $0x191c
     613:	e8 c8 05 00 00       	call   be0 <strchr>
     618:	83 c4 10             	add    $0x10,%esp
     61b:	85 c0                	test   %eax,%eax
     61d:	75 e1                	jne    600 <peek+0x20>
  *ps = s;
     61f:	89 1f                	mov    %ebx,(%edi)
  return *s && strchr(toks, *s);
     621:	0f be 03             	movsbl (%ebx),%eax
     624:	31 d2                	xor    %edx,%edx
     626:	84 c0                	test   %al,%al
     628:	75 0e                	jne    638 <peek+0x58>
}
     62a:	8d 65 f4             	lea    -0xc(%ebp),%esp
     62d:	89 d0                	mov    %edx,%eax
     62f:	5b                   	pop    %ebx
     630:	5e                   	pop    %esi
     631:	5f                   	pop    %edi
     632:	5d                   	pop    %ebp
     633:	c3                   	ret    
     634:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return *s && strchr(toks, *s);
     638:	83 ec 08             	sub    $0x8,%esp
     63b:	50                   	push   %eax
     63c:	ff 75 10             	pushl  0x10(%ebp)
     63f:	e8 9c 05 00 00       	call   be0 <strchr>
     644:	83 c4 10             	add    $0x10,%esp
     647:	31 d2                	xor    %edx,%edx
     649:	85 c0                	test   %eax,%eax
     64b:	0f 95 c2             	setne  %dl
}
     64e:	8d 65 f4             	lea    -0xc(%ebp),%esp
     651:	5b                   	pop    %ebx
     652:	89 d0                	mov    %edx,%eax
     654:	5e                   	pop    %esi
     655:	5f                   	pop    %edi
     656:	5d                   	pop    %ebp
     657:	c3                   	ret    
     658:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     65f:	90                   	nop

00000660 <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     660:	f3 0f 1e fb          	endbr32 
     664:	55                   	push   %ebp
     665:	89 e5                	mov    %esp,%ebp
     667:	57                   	push   %edi
     668:	56                   	push   %esi
     669:	53                   	push   %ebx
     66a:	83 ec 1c             	sub    $0x1c,%esp
     66d:	8b 75 0c             	mov    0xc(%ebp),%esi
     670:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     673:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     677:	90                   	nop
     678:	83 ec 04             	sub    $0x4,%esp
     67b:	68 91 12 00 00       	push   $0x1291
     680:	53                   	push   %ebx
     681:	56                   	push   %esi
     682:	e8 59 ff ff ff       	call   5e0 <peek>
     687:	83 c4 10             	add    $0x10,%esp
     68a:	85 c0                	test   %eax,%eax
     68c:	74 6a                	je     6f8 <parseredirs+0x98>
    tok = gettoken(ps, es, 0, 0);
     68e:	6a 00                	push   $0x0
     690:	6a 00                	push   $0x0
     692:	53                   	push   %ebx
     693:	56                   	push   %esi
     694:	e8 e7 fd ff ff       	call   480 <gettoken>
     699:	89 c7                	mov    %eax,%edi
    if(gettoken(ps, es, &q, &eq) != 'a')
     69b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     69e:	50                   	push   %eax
     69f:	8d 45 e0             	lea    -0x20(%ebp),%eax
     6a2:	50                   	push   %eax
     6a3:	53                   	push   %ebx
     6a4:	56                   	push   %esi
     6a5:	e8 d6 fd ff ff       	call   480 <gettoken>
     6aa:	83 c4 20             	add    $0x20,%esp
     6ad:	83 f8 61             	cmp    $0x61,%eax
     6b0:	75 51                	jne    703 <parseredirs+0xa3>
      panic("missing file for redirection");
    switch(tok){
     6b2:	83 ff 3c             	cmp    $0x3c,%edi
     6b5:	74 31                	je     6e8 <parseredirs+0x88>
     6b7:	83 ff 3e             	cmp    $0x3e,%edi
     6ba:	74 05                	je     6c1 <parseredirs+0x61>
     6bc:	83 ff 2b             	cmp    $0x2b,%edi
     6bf:	75 b7                	jne    678 <parseredirs+0x18>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     6c1:	83 ec 0c             	sub    $0xc,%esp
     6c4:	6a 01                	push   $0x1
     6c6:	68 01 02 00 00       	push   $0x201
     6cb:	ff 75 e4             	pushl  -0x1c(%ebp)
     6ce:	ff 75 e0             	pushl  -0x20(%ebp)
     6d1:	ff 75 08             	pushl  0x8(%ebp)
     6d4:	e8 97 fc ff ff       	call   370 <redircmd>
      break;
     6d9:	83 c4 20             	add    $0x20,%esp
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     6dc:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     6df:	eb 97                	jmp    678 <parseredirs+0x18>
     6e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     6e8:	83 ec 0c             	sub    $0xc,%esp
     6eb:	6a 00                	push   $0x0
     6ed:	6a 00                	push   $0x0
     6ef:	eb da                	jmp    6cb <parseredirs+0x6b>
     6f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
  }
  return cmd;
}
     6f8:	8b 45 08             	mov    0x8(%ebp),%eax
     6fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
     6fe:	5b                   	pop    %ebx
     6ff:	5e                   	pop    %esi
     700:	5f                   	pop    %edi
     701:	5d                   	pop    %ebp
     702:	c3                   	ret    
      panic("missing file for redirection");
     703:	83 ec 0c             	sub    $0xc,%esp
     706:	68 74 12 00 00       	push   $0x1274
     70b:	e8 40 fa ff ff       	call   150 <panic>

00000710 <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     710:	f3 0f 1e fb          	endbr32 
     714:	55                   	push   %ebp
     715:	89 e5                	mov    %esp,%ebp
     717:	57                   	push   %edi
     718:	56                   	push   %esi
     719:	53                   	push   %ebx
     71a:	83 ec 30             	sub    $0x30,%esp
     71d:	8b 75 08             	mov    0x8(%ebp),%esi
     720:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     723:	68 94 12 00 00       	push   $0x1294
     728:	57                   	push   %edi
     729:	56                   	push   %esi
     72a:	e8 b1 fe ff ff       	call   5e0 <peek>
     72f:	83 c4 10             	add    $0x10,%esp
     732:	85 c0                	test   %eax,%eax
     734:	0f 85 96 00 00 00    	jne    7d0 <parseexec+0xc0>
     73a:	89 c3                	mov    %eax,%ebx
    return parseblock(ps, es);

  ret = execcmd();
     73c:	e8 ff fb ff ff       	call   340 <execcmd>
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     741:	83 ec 04             	sub    $0x4,%esp
     744:	57                   	push   %edi
     745:	56                   	push   %esi
     746:	50                   	push   %eax
  ret = execcmd();
     747:	89 45 d0             	mov    %eax,-0x30(%ebp)
  ret = parseredirs(ret, ps, es);
     74a:	e8 11 ff ff ff       	call   660 <parseredirs>
  while(!peek(ps, es, "|)&;")){
     74f:	83 c4 10             	add    $0x10,%esp
  ret = parseredirs(ret, ps, es);
     752:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  while(!peek(ps, es, "|)&;")){
     755:	eb 1c                	jmp    773 <parseexec+0x63>
     757:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     75e:	66 90                	xchg   %ax,%ax
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
     760:	83 ec 04             	sub    $0x4,%esp
     763:	57                   	push   %edi
     764:	56                   	push   %esi
     765:	ff 75 d4             	pushl  -0x2c(%ebp)
     768:	e8 f3 fe ff ff       	call   660 <parseredirs>
     76d:	83 c4 10             	add    $0x10,%esp
     770:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  while(!peek(ps, es, "|)&;")){
     773:	83 ec 04             	sub    $0x4,%esp
     776:	68 ab 12 00 00       	push   $0x12ab
     77b:	57                   	push   %edi
     77c:	56                   	push   %esi
     77d:	e8 5e fe ff ff       	call   5e0 <peek>
     782:	83 c4 10             	add    $0x10,%esp
     785:	85 c0                	test   %eax,%eax
     787:	75 67                	jne    7f0 <parseexec+0xe0>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     789:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     78c:	50                   	push   %eax
     78d:	8d 45 e0             	lea    -0x20(%ebp),%eax
     790:	50                   	push   %eax
     791:	57                   	push   %edi
     792:	56                   	push   %esi
     793:	e8 e8 fc ff ff       	call   480 <gettoken>
     798:	83 c4 10             	add    $0x10,%esp
     79b:	85 c0                	test   %eax,%eax
     79d:	74 51                	je     7f0 <parseexec+0xe0>
    if(tok != 'a')
     79f:	83 f8 61             	cmp    $0x61,%eax
     7a2:	75 6b                	jne    80f <parseexec+0xff>
    cmd->argv[argc] = q;
     7a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
     7a7:	8b 55 d0             	mov    -0x30(%ebp),%edx
     7aa:	89 44 9a 04          	mov    %eax,0x4(%edx,%ebx,4)
    cmd->eargv[argc] = eq;
     7ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     7b1:	89 44 9a 2c          	mov    %eax,0x2c(%edx,%ebx,4)
    argc++;
     7b5:	83 c3 01             	add    $0x1,%ebx
    if(argc >= MAXARGS)
     7b8:	83 fb 0a             	cmp    $0xa,%ebx
     7bb:	75 a3                	jne    760 <parseexec+0x50>
      panic("too many args");
     7bd:	83 ec 0c             	sub    $0xc,%esp
     7c0:	68 9d 12 00 00       	push   $0x129d
     7c5:	e8 86 f9 ff ff       	call   150 <panic>
     7ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return parseblock(ps, es);
     7d0:	83 ec 08             	sub    $0x8,%esp
     7d3:	57                   	push   %edi
     7d4:	56                   	push   %esi
     7d5:	e8 66 01 00 00       	call   940 <parseblock>
     7da:	83 c4 10             	add    $0x10,%esp
     7dd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     7e0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     7e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
     7e6:	5b                   	pop    %ebx
     7e7:	5e                   	pop    %esi
     7e8:	5f                   	pop    %edi
     7e9:	5d                   	pop    %ebp
     7ea:	c3                   	ret    
     7eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     7ef:	90                   	nop
  cmd->argv[argc] = 0;
     7f0:	8b 45 d0             	mov    -0x30(%ebp),%eax
     7f3:	8d 04 98             	lea    (%eax,%ebx,4),%eax
     7f6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  cmd->eargv[argc] = 0;
     7fd:	c7 40 2c 00 00 00 00 	movl   $0x0,0x2c(%eax)
}
     804:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     807:	8d 65 f4             	lea    -0xc(%ebp),%esp
     80a:	5b                   	pop    %ebx
     80b:	5e                   	pop    %esi
     80c:	5f                   	pop    %edi
     80d:	5d                   	pop    %ebp
     80e:	c3                   	ret    
      panic("syntax");
     80f:	83 ec 0c             	sub    $0xc,%esp
     812:	68 96 12 00 00       	push   $0x1296
     817:	e8 34 f9 ff ff       	call   150 <panic>
     81c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000820 <parsepipe>:
{
     820:	f3 0f 1e fb          	endbr32 
     824:	55                   	push   %ebp
     825:	89 e5                	mov    %esp,%ebp
     827:	57                   	push   %edi
     828:	56                   	push   %esi
     829:	53                   	push   %ebx
     82a:	83 ec 14             	sub    $0x14,%esp
     82d:	8b 75 08             	mov    0x8(%ebp),%esi
     830:	8b 7d 0c             	mov    0xc(%ebp),%edi
  cmd = parseexec(ps, es);
     833:	57                   	push   %edi
     834:	56                   	push   %esi
     835:	e8 d6 fe ff ff       	call   710 <parseexec>
  if(peek(ps, es, "|")){
     83a:	83 c4 0c             	add    $0xc,%esp
     83d:	68 b0 12 00 00       	push   $0x12b0
  cmd = parseexec(ps, es);
     842:	89 c3                	mov    %eax,%ebx
  if(peek(ps, es, "|")){
     844:	57                   	push   %edi
     845:	56                   	push   %esi
     846:	e8 95 fd ff ff       	call   5e0 <peek>
     84b:	83 c4 10             	add    $0x10,%esp
     84e:	85 c0                	test   %eax,%eax
     850:	75 0e                	jne    860 <parsepipe+0x40>
}
     852:	8d 65 f4             	lea    -0xc(%ebp),%esp
     855:	89 d8                	mov    %ebx,%eax
     857:	5b                   	pop    %ebx
     858:	5e                   	pop    %esi
     859:	5f                   	pop    %edi
     85a:	5d                   	pop    %ebp
     85b:	c3                   	ret    
     85c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    gettoken(ps, es, 0, 0);
     860:	6a 00                	push   $0x0
     862:	6a 00                	push   $0x0
     864:	57                   	push   %edi
     865:	56                   	push   %esi
     866:	e8 15 fc ff ff       	call   480 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     86b:	58                   	pop    %eax
     86c:	5a                   	pop    %edx
     86d:	57                   	push   %edi
     86e:	56                   	push   %esi
     86f:	e8 ac ff ff ff       	call   820 <parsepipe>
     874:	89 5d 08             	mov    %ebx,0x8(%ebp)
     877:	83 c4 10             	add    $0x10,%esp
     87a:	89 45 0c             	mov    %eax,0xc(%ebp)
}
     87d:	8d 65 f4             	lea    -0xc(%ebp),%esp
     880:	5b                   	pop    %ebx
     881:	5e                   	pop    %esi
     882:	5f                   	pop    %edi
     883:	5d                   	pop    %ebp
    cmd = pipecmd(cmd, parsepipe(ps, es));
     884:	e9 37 fb ff ff       	jmp    3c0 <pipecmd>
     889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000890 <parseline>:
{
     890:	f3 0f 1e fb          	endbr32 
     894:	55                   	push   %ebp
     895:	89 e5                	mov    %esp,%ebp
     897:	57                   	push   %edi
     898:	56                   	push   %esi
     899:	53                   	push   %ebx
     89a:	83 ec 14             	sub    $0x14,%esp
     89d:	8b 75 08             	mov    0x8(%ebp),%esi
     8a0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  cmd = parsepipe(ps, es);
     8a3:	57                   	push   %edi
     8a4:	56                   	push   %esi
     8a5:	e8 76 ff ff ff       	call   820 <parsepipe>
  while(peek(ps, es, "&")){
     8aa:	83 c4 10             	add    $0x10,%esp
  cmd = parsepipe(ps, es);
     8ad:	89 c3                	mov    %eax,%ebx
  while(peek(ps, es, "&")){
     8af:	eb 1f                	jmp    8d0 <parseline+0x40>
     8b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    gettoken(ps, es, 0, 0);
     8b8:	6a 00                	push   $0x0
     8ba:	6a 00                	push   $0x0
     8bc:	57                   	push   %edi
     8bd:	56                   	push   %esi
     8be:	e8 bd fb ff ff       	call   480 <gettoken>
    cmd = backcmd(cmd);
     8c3:	89 1c 24             	mov    %ebx,(%esp)
     8c6:	e8 75 fb ff ff       	call   440 <backcmd>
     8cb:	83 c4 10             	add    $0x10,%esp
     8ce:	89 c3                	mov    %eax,%ebx
  while(peek(ps, es, "&")){
     8d0:	83 ec 04             	sub    $0x4,%esp
     8d3:	68 b2 12 00 00       	push   $0x12b2
     8d8:	57                   	push   %edi
     8d9:	56                   	push   %esi
     8da:	e8 01 fd ff ff       	call   5e0 <peek>
     8df:	83 c4 10             	add    $0x10,%esp
     8e2:	85 c0                	test   %eax,%eax
     8e4:	75 d2                	jne    8b8 <parseline+0x28>
  if(peek(ps, es, ";")){
     8e6:	83 ec 04             	sub    $0x4,%esp
     8e9:	68 ae 12 00 00       	push   $0x12ae
     8ee:	57                   	push   %edi
     8ef:	56                   	push   %esi
     8f0:	e8 eb fc ff ff       	call   5e0 <peek>
     8f5:	83 c4 10             	add    $0x10,%esp
     8f8:	85 c0                	test   %eax,%eax
     8fa:	75 14                	jne    910 <parseline+0x80>
}
     8fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
     8ff:	89 d8                	mov    %ebx,%eax
     901:	5b                   	pop    %ebx
     902:	5e                   	pop    %esi
     903:	5f                   	pop    %edi
     904:	5d                   	pop    %ebp
     905:	c3                   	ret    
     906:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     90d:	8d 76 00             	lea    0x0(%esi),%esi
    gettoken(ps, es, 0, 0);
     910:	6a 00                	push   $0x0
     912:	6a 00                	push   $0x0
     914:	57                   	push   %edi
     915:	56                   	push   %esi
     916:	e8 65 fb ff ff       	call   480 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     91b:	58                   	pop    %eax
     91c:	5a                   	pop    %edx
     91d:	57                   	push   %edi
     91e:	56                   	push   %esi
     91f:	e8 6c ff ff ff       	call   890 <parseline>
     924:	89 5d 08             	mov    %ebx,0x8(%ebp)
     927:	83 c4 10             	add    $0x10,%esp
     92a:	89 45 0c             	mov    %eax,0xc(%ebp)
}
     92d:	8d 65 f4             	lea    -0xc(%ebp),%esp
     930:	5b                   	pop    %ebx
     931:	5e                   	pop    %esi
     932:	5f                   	pop    %edi
     933:	5d                   	pop    %ebp
    cmd = listcmd(cmd, parseline(ps, es));
     934:	e9 c7 fa ff ff       	jmp    400 <listcmd>
     939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000940 <parseblock>:
{
     940:	f3 0f 1e fb          	endbr32 
     944:	55                   	push   %ebp
     945:	89 e5                	mov    %esp,%ebp
     947:	57                   	push   %edi
     948:	56                   	push   %esi
     949:	53                   	push   %ebx
     94a:	83 ec 10             	sub    $0x10,%esp
     94d:	8b 5d 08             	mov    0x8(%ebp),%ebx
     950:	8b 75 0c             	mov    0xc(%ebp),%esi
  if(!peek(ps, es, "("))
     953:	68 94 12 00 00       	push   $0x1294
     958:	56                   	push   %esi
     959:	53                   	push   %ebx
     95a:	e8 81 fc ff ff       	call   5e0 <peek>
     95f:	83 c4 10             	add    $0x10,%esp
     962:	85 c0                	test   %eax,%eax
     964:	74 4a                	je     9b0 <parseblock+0x70>
  gettoken(ps, es, 0, 0);
     966:	6a 00                	push   $0x0
     968:	6a 00                	push   $0x0
     96a:	56                   	push   %esi
     96b:	53                   	push   %ebx
     96c:	e8 0f fb ff ff       	call   480 <gettoken>
  cmd = parseline(ps, es);
     971:	58                   	pop    %eax
     972:	5a                   	pop    %edx
     973:	56                   	push   %esi
     974:	53                   	push   %ebx
     975:	e8 16 ff ff ff       	call   890 <parseline>
  if(!peek(ps, es, ")"))
     97a:	83 c4 0c             	add    $0xc,%esp
     97d:	68 d0 12 00 00       	push   $0x12d0
  cmd = parseline(ps, es);
     982:	89 c7                	mov    %eax,%edi
  if(!peek(ps, es, ")"))
     984:	56                   	push   %esi
     985:	53                   	push   %ebx
     986:	e8 55 fc ff ff       	call   5e0 <peek>
     98b:	83 c4 10             	add    $0x10,%esp
     98e:	85 c0                	test   %eax,%eax
     990:	74 2b                	je     9bd <parseblock+0x7d>
  gettoken(ps, es, 0, 0);
     992:	6a 00                	push   $0x0
     994:	6a 00                	push   $0x0
     996:	56                   	push   %esi
     997:	53                   	push   %ebx
     998:	e8 e3 fa ff ff       	call   480 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     99d:	83 c4 0c             	add    $0xc,%esp
     9a0:	56                   	push   %esi
     9a1:	53                   	push   %ebx
     9a2:	57                   	push   %edi
     9a3:	e8 b8 fc ff ff       	call   660 <parseredirs>
}
     9a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
     9ab:	5b                   	pop    %ebx
     9ac:	5e                   	pop    %esi
     9ad:	5f                   	pop    %edi
     9ae:	5d                   	pop    %ebp
     9af:	c3                   	ret    
    panic("parseblock");
     9b0:	83 ec 0c             	sub    $0xc,%esp
     9b3:	68 b4 12 00 00       	push   $0x12b4
     9b8:	e8 93 f7 ff ff       	call   150 <panic>
    panic("syntax - missing )");
     9bd:	83 ec 0c             	sub    $0xc,%esp
     9c0:	68 bf 12 00 00       	push   $0x12bf
     9c5:	e8 86 f7 ff ff       	call   150 <panic>
     9ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000009d0 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     9d0:	f3 0f 1e fb          	endbr32 
     9d4:	55                   	push   %ebp
     9d5:	89 e5                	mov    %esp,%ebp
     9d7:	53                   	push   %ebx
     9d8:	83 ec 04             	sub    $0x4,%esp
     9db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     9de:	85 db                	test   %ebx,%ebx
     9e0:	0f 84 9a 00 00 00    	je     a80 <nulterminate+0xb0>
    return 0;

  switch(cmd->type){
     9e6:	83 3b 05             	cmpl   $0x5,(%ebx)
     9e9:	77 6d                	ja     a58 <nulterminate+0x88>
     9eb:	8b 03                	mov    (%ebx),%eax
     9ed:	3e ff 24 85 1c 13 00 	notrack jmp *0x131c(,%eax,4)
     9f4:	00 
     9f5:	8d 76 00             	lea    0x0(%esi),%esi
    nulterminate(pcmd->right);
    break;

  case LIST:
    lcmd = (struct listcmd*)cmd;
    nulterminate(lcmd->left);
     9f8:	83 ec 0c             	sub    $0xc,%esp
     9fb:	ff 73 04             	pushl  0x4(%ebx)
     9fe:	e8 cd ff ff ff       	call   9d0 <nulterminate>
    nulterminate(lcmd->right);
     a03:	58                   	pop    %eax
     a04:	ff 73 08             	pushl  0x8(%ebx)
     a07:	e8 c4 ff ff ff       	call   9d0 <nulterminate>
    break;
     a0c:	83 c4 10             	add    $0x10,%esp
     a0f:	89 d8                	mov    %ebx,%eax
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     a11:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     a14:	c9                   	leave  
     a15:	c3                   	ret    
     a16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     a1d:	8d 76 00             	lea    0x0(%esi),%esi
    nulterminate(bcmd->cmd);
     a20:	83 ec 0c             	sub    $0xc,%esp
     a23:	ff 73 04             	pushl  0x4(%ebx)
     a26:	e8 a5 ff ff ff       	call   9d0 <nulterminate>
    break;
     a2b:	89 d8                	mov    %ebx,%eax
     a2d:	83 c4 10             	add    $0x10,%esp
}
     a30:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     a33:	c9                   	leave  
     a34:	c3                   	ret    
     a35:	8d 76 00             	lea    0x0(%esi),%esi
    for(i=0; ecmd->argv[i]; i++)
     a38:	8b 4b 04             	mov    0x4(%ebx),%ecx
     a3b:	8d 43 08             	lea    0x8(%ebx),%eax
     a3e:	85 c9                	test   %ecx,%ecx
     a40:	74 16                	je     a58 <nulterminate+0x88>
     a42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      *ecmd->eargv[i] = 0;
     a48:	8b 50 24             	mov    0x24(%eax),%edx
     a4b:	83 c0 04             	add    $0x4,%eax
     a4e:	c6 02 00             	movb   $0x0,(%edx)
    for(i=0; ecmd->argv[i]; i++)
     a51:	8b 50 fc             	mov    -0x4(%eax),%edx
     a54:	85 d2                	test   %edx,%edx
     a56:	75 f0                	jne    a48 <nulterminate+0x78>
  switch(cmd->type){
     a58:	89 d8                	mov    %ebx,%eax
}
     a5a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     a5d:	c9                   	leave  
     a5e:	c3                   	ret    
     a5f:	90                   	nop
    nulterminate(rcmd->cmd);
     a60:	83 ec 0c             	sub    $0xc,%esp
     a63:	ff 73 04             	pushl  0x4(%ebx)
     a66:	e8 65 ff ff ff       	call   9d0 <nulterminate>
    *rcmd->efile = 0;
     a6b:	8b 43 0c             	mov    0xc(%ebx),%eax
    break;
     a6e:	83 c4 10             	add    $0x10,%esp
    *rcmd->efile = 0;
     a71:	c6 00 00             	movb   $0x0,(%eax)
    break;
     a74:	89 d8                	mov    %ebx,%eax
}
     a76:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     a79:	c9                   	leave  
     a7a:	c3                   	ret    
     a7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     a7f:	90                   	nop
    return 0;
     a80:	31 c0                	xor    %eax,%eax
     a82:	eb 8d                	jmp    a11 <nulterminate+0x41>
     a84:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     a8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     a8f:	90                   	nop

00000a90 <parsecmd>:
{
     a90:	f3 0f 1e fb          	endbr32 
     a94:	55                   	push   %ebp
     a95:	89 e5                	mov    %esp,%ebp
     a97:	56                   	push   %esi
     a98:	53                   	push   %ebx
  es = s + strlen(s);
     a99:	8b 5d 08             	mov    0x8(%ebp),%ebx
     a9c:	83 ec 0c             	sub    $0xc,%esp
     a9f:	53                   	push   %ebx
     aa0:	e8 db 00 00 00       	call   b80 <strlen>
  cmd = parseline(&s, es);
     aa5:	59                   	pop    %ecx
     aa6:	5e                   	pop    %esi
  es = s + strlen(s);
     aa7:	01 c3                	add    %eax,%ebx
  cmd = parseline(&s, es);
     aa9:	8d 45 08             	lea    0x8(%ebp),%eax
     aac:	53                   	push   %ebx
     aad:	50                   	push   %eax
     aae:	e8 dd fd ff ff       	call   890 <parseline>
  peek(&s, es, "");
     ab3:	83 c4 0c             	add    $0xc,%esp
  cmd = parseline(&s, es);
     ab6:	89 c6                	mov    %eax,%esi
  peek(&s, es, "");
     ab8:	8d 45 08             	lea    0x8(%ebp),%eax
     abb:	68 00 13 00 00       	push   $0x1300
     ac0:	53                   	push   %ebx
     ac1:	50                   	push   %eax
     ac2:	e8 19 fb ff ff       	call   5e0 <peek>
  if(s != es){
     ac7:	8b 45 08             	mov    0x8(%ebp),%eax
     aca:	83 c4 10             	add    $0x10,%esp
     acd:	39 d8                	cmp    %ebx,%eax
     acf:	75 12                	jne    ae3 <parsecmd+0x53>
  nulterminate(cmd);
     ad1:	83 ec 0c             	sub    $0xc,%esp
     ad4:	56                   	push   %esi
     ad5:	e8 f6 fe ff ff       	call   9d0 <nulterminate>
}
     ada:	8d 65 f8             	lea    -0x8(%ebp),%esp
     add:	89 f0                	mov    %esi,%eax
     adf:	5b                   	pop    %ebx
     ae0:	5e                   	pop    %esi
     ae1:	5d                   	pop    %ebp
     ae2:	c3                   	ret    
    printf(2, "leftovers: %s\n", s);
     ae3:	52                   	push   %edx
     ae4:	50                   	push   %eax
     ae5:	68 d2 12 00 00       	push   $0x12d2
     aea:	6a 02                	push   $0x2
     aec:	e8 df 03 00 00       	call   ed0 <printf>
    panic("syntax");
     af1:	c7 04 24 96 12 00 00 	movl   $0x1296,(%esp)
     af8:	e8 53 f6 ff ff       	call   150 <panic>
     afd:	66 90                	xchg   %ax,%ax
     aff:	90                   	nop

00000b00 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
     b00:	f3 0f 1e fb          	endbr32 
     b04:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     b05:	31 c0                	xor    %eax,%eax
{
     b07:	89 e5                	mov    %esp,%ebp
     b09:	53                   	push   %ebx
     b0a:	8b 4d 08             	mov    0x8(%ebp),%ecx
     b0d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while((*s++ = *t++) != 0)
     b10:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
     b14:	88 14 01             	mov    %dl,(%ecx,%eax,1)
     b17:	83 c0 01             	add    $0x1,%eax
     b1a:	84 d2                	test   %dl,%dl
     b1c:	75 f2                	jne    b10 <strcpy+0x10>
    ;
  return os;
}
     b1e:	89 c8                	mov    %ecx,%eax
     b20:	5b                   	pop    %ebx
     b21:	5d                   	pop    %ebp
     b22:	c3                   	ret    
     b23:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     b2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000b30 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     b30:	f3 0f 1e fb          	endbr32 
     b34:	55                   	push   %ebp
     b35:	89 e5                	mov    %esp,%ebp
     b37:	53                   	push   %ebx
     b38:	8b 4d 08             	mov    0x8(%ebp),%ecx
     b3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
     b3e:	0f b6 01             	movzbl (%ecx),%eax
     b41:	0f b6 1a             	movzbl (%edx),%ebx
     b44:	84 c0                	test   %al,%al
     b46:	75 19                	jne    b61 <strcmp+0x31>
     b48:	eb 26                	jmp    b70 <strcmp+0x40>
     b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     b50:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
     b54:	83 c1 01             	add    $0x1,%ecx
     b57:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
     b5a:	0f b6 1a             	movzbl (%edx),%ebx
     b5d:	84 c0                	test   %al,%al
     b5f:	74 0f                	je     b70 <strcmp+0x40>
     b61:	38 d8                	cmp    %bl,%al
     b63:	74 eb                	je     b50 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
     b65:	29 d8                	sub    %ebx,%eax
}
     b67:	5b                   	pop    %ebx
     b68:	5d                   	pop    %ebp
     b69:	c3                   	ret    
     b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     b70:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
     b72:	29 d8                	sub    %ebx,%eax
}
     b74:	5b                   	pop    %ebx
     b75:	5d                   	pop    %ebp
     b76:	c3                   	ret    
     b77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     b7e:	66 90                	xchg   %ax,%ax

00000b80 <strlen>:

uint
strlen(const char *s)
{
     b80:	f3 0f 1e fb          	endbr32 
     b84:	55                   	push   %ebp
     b85:	89 e5                	mov    %esp,%ebp
     b87:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
     b8a:	80 3a 00             	cmpb   $0x0,(%edx)
     b8d:	74 21                	je     bb0 <strlen+0x30>
     b8f:	31 c0                	xor    %eax,%eax
     b91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     b98:	83 c0 01             	add    $0x1,%eax
     b9b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
     b9f:	89 c1                	mov    %eax,%ecx
     ba1:	75 f5                	jne    b98 <strlen+0x18>
    ;
  return n;
}
     ba3:	89 c8                	mov    %ecx,%eax
     ba5:	5d                   	pop    %ebp
     ba6:	c3                   	ret    
     ba7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     bae:	66 90                	xchg   %ax,%ax
  for(n = 0; s[n]; n++)
     bb0:	31 c9                	xor    %ecx,%ecx
}
     bb2:	5d                   	pop    %ebp
     bb3:	89 c8                	mov    %ecx,%eax
     bb5:	c3                   	ret    
     bb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     bbd:	8d 76 00             	lea    0x0(%esi),%esi

00000bc0 <memset>:

void*
memset(void *dst, int c, uint n)
{
     bc0:	f3 0f 1e fb          	endbr32 
     bc4:	55                   	push   %ebp
     bc5:	89 e5                	mov    %esp,%ebp
     bc7:	57                   	push   %edi
     bc8:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
     bcb:	8b 4d 10             	mov    0x10(%ebp),%ecx
     bce:	8b 45 0c             	mov    0xc(%ebp),%eax
     bd1:	89 d7                	mov    %edx,%edi
     bd3:	fc                   	cld    
     bd4:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
     bd6:	89 d0                	mov    %edx,%eax
     bd8:	5f                   	pop    %edi
     bd9:	5d                   	pop    %ebp
     bda:	c3                   	ret    
     bdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     bdf:	90                   	nop

00000be0 <strchr>:

char*
strchr(const char *s, char c)
{
     be0:	f3 0f 1e fb          	endbr32 
     be4:	55                   	push   %ebp
     be5:	89 e5                	mov    %esp,%ebp
     be7:	8b 45 08             	mov    0x8(%ebp),%eax
     bea:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
     bee:	0f b6 10             	movzbl (%eax),%edx
     bf1:	84 d2                	test   %dl,%dl
     bf3:	75 16                	jne    c0b <strchr+0x2b>
     bf5:	eb 21                	jmp    c18 <strchr+0x38>
     bf7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     bfe:	66 90                	xchg   %ax,%ax
     c00:	0f b6 50 01          	movzbl 0x1(%eax),%edx
     c04:	83 c0 01             	add    $0x1,%eax
     c07:	84 d2                	test   %dl,%dl
     c09:	74 0d                	je     c18 <strchr+0x38>
    if(*s == c)
     c0b:	38 d1                	cmp    %dl,%cl
     c0d:	75 f1                	jne    c00 <strchr+0x20>
      return (char*)s;
  return 0;
}
     c0f:	5d                   	pop    %ebp
     c10:	c3                   	ret    
     c11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
     c18:	31 c0                	xor    %eax,%eax
}
     c1a:	5d                   	pop    %ebp
     c1b:	c3                   	ret    
     c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000c20 <gets>:

char*
gets(char *buf, int max)
{
     c20:	f3 0f 1e fb          	endbr32 
     c24:	55                   	push   %ebp
     c25:	89 e5                	mov    %esp,%ebp
     c27:	57                   	push   %edi
     c28:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     c29:	31 f6                	xor    %esi,%esi
{
     c2b:	53                   	push   %ebx
     c2c:	89 f3                	mov    %esi,%ebx
     c2e:	83 ec 1c             	sub    $0x1c,%esp
     c31:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
     c34:	eb 33                	jmp    c69 <gets+0x49>
     c36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     c3d:	8d 76 00             	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
     c40:	83 ec 04             	sub    $0x4,%esp
     c43:	8d 45 e7             	lea    -0x19(%ebp),%eax
     c46:	6a 01                	push   $0x1
     c48:	50                   	push   %eax
     c49:	6a 00                	push   $0x0
     c4b:	e8 2b 01 00 00       	call   d7b <read>
    if(cc < 1)
     c50:	83 c4 10             	add    $0x10,%esp
     c53:	85 c0                	test   %eax,%eax
     c55:	7e 1c                	jle    c73 <gets+0x53>
      break;
    buf[i++] = c;
     c57:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
     c5b:	83 c7 01             	add    $0x1,%edi
     c5e:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
     c61:	3c 0a                	cmp    $0xa,%al
     c63:	74 23                	je     c88 <gets+0x68>
     c65:	3c 0d                	cmp    $0xd,%al
     c67:	74 1f                	je     c88 <gets+0x68>
  for(i=0; i+1 < max; ){
     c69:	83 c3 01             	add    $0x1,%ebx
     c6c:	89 fe                	mov    %edi,%esi
     c6e:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
     c71:	7c cd                	jl     c40 <gets+0x20>
     c73:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
     c75:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
     c78:	c6 03 00             	movb   $0x0,(%ebx)
}
     c7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
     c7e:	5b                   	pop    %ebx
     c7f:	5e                   	pop    %esi
     c80:	5f                   	pop    %edi
     c81:	5d                   	pop    %ebp
     c82:	c3                   	ret    
     c83:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     c87:	90                   	nop
     c88:	8b 75 08             	mov    0x8(%ebp),%esi
     c8b:	8b 45 08             	mov    0x8(%ebp),%eax
     c8e:	01 de                	add    %ebx,%esi
     c90:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
     c92:	c6 03 00             	movb   $0x0,(%ebx)
}
     c95:	8d 65 f4             	lea    -0xc(%ebp),%esp
     c98:	5b                   	pop    %ebx
     c99:	5e                   	pop    %esi
     c9a:	5f                   	pop    %edi
     c9b:	5d                   	pop    %ebp
     c9c:	c3                   	ret    
     c9d:	8d 76 00             	lea    0x0(%esi),%esi

00000ca0 <stat>:

int
stat(const char *n, struct stat *st)
{
     ca0:	f3 0f 1e fb          	endbr32 
     ca4:	55                   	push   %ebp
     ca5:	89 e5                	mov    %esp,%ebp
     ca7:	56                   	push   %esi
     ca8:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     ca9:	83 ec 08             	sub    $0x8,%esp
     cac:	6a 00                	push   $0x0
     cae:	ff 75 08             	pushl  0x8(%ebp)
     cb1:	e8 ed 00 00 00       	call   da3 <open>
  if(fd < 0)
     cb6:	83 c4 10             	add    $0x10,%esp
     cb9:	85 c0                	test   %eax,%eax
     cbb:	78 2b                	js     ce8 <stat+0x48>
    return -1;
  r = fstat(fd, st);
     cbd:	83 ec 08             	sub    $0x8,%esp
     cc0:	ff 75 0c             	pushl  0xc(%ebp)
     cc3:	89 c3                	mov    %eax,%ebx
     cc5:	50                   	push   %eax
     cc6:	e8 f0 00 00 00       	call   dbb <fstat>
  close(fd);
     ccb:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
     cce:	89 c6                	mov    %eax,%esi
  close(fd);
     cd0:	e8 b6 00 00 00       	call   d8b <close>
  return r;
     cd5:	83 c4 10             	add    $0x10,%esp
}
     cd8:	8d 65 f8             	lea    -0x8(%ebp),%esp
     cdb:	89 f0                	mov    %esi,%eax
     cdd:	5b                   	pop    %ebx
     cde:	5e                   	pop    %esi
     cdf:	5d                   	pop    %ebp
     ce0:	c3                   	ret    
     ce1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
     ce8:	be ff ff ff ff       	mov    $0xffffffff,%esi
     ced:	eb e9                	jmp    cd8 <stat+0x38>
     cef:	90                   	nop

00000cf0 <atoi>:

int
atoi(const char *s)
{
     cf0:	f3 0f 1e fb          	endbr32 
     cf4:	55                   	push   %ebp
     cf5:	89 e5                	mov    %esp,%ebp
     cf7:	53                   	push   %ebx
     cf8:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     cfb:	0f be 02             	movsbl (%edx),%eax
     cfe:	8d 48 d0             	lea    -0x30(%eax),%ecx
     d01:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
     d04:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
     d09:	77 1a                	ja     d25 <atoi+0x35>
     d0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     d0f:	90                   	nop
    n = n*10 + *s++ - '0';
     d10:	83 c2 01             	add    $0x1,%edx
     d13:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
     d16:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
     d1a:	0f be 02             	movsbl (%edx),%eax
     d1d:	8d 58 d0             	lea    -0x30(%eax),%ebx
     d20:	80 fb 09             	cmp    $0x9,%bl
     d23:	76 eb                	jbe    d10 <atoi+0x20>
  return n;
}
     d25:	89 c8                	mov    %ecx,%eax
     d27:	5b                   	pop    %ebx
     d28:	5d                   	pop    %ebp
     d29:	c3                   	ret    
     d2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000d30 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     d30:	f3 0f 1e fb          	endbr32 
     d34:	55                   	push   %ebp
     d35:	89 e5                	mov    %esp,%ebp
     d37:	57                   	push   %edi
     d38:	8b 45 10             	mov    0x10(%ebp),%eax
     d3b:	8b 55 08             	mov    0x8(%ebp),%edx
     d3e:	56                   	push   %esi
     d3f:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     d42:	85 c0                	test   %eax,%eax
     d44:	7e 0f                	jle    d55 <memmove+0x25>
     d46:	01 d0                	add    %edx,%eax
  dst = vdst;
     d48:	89 d7                	mov    %edx,%edi
     d4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *dst++ = *src++;
     d50:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
     d51:	39 f8                	cmp    %edi,%eax
     d53:	75 fb                	jne    d50 <memmove+0x20>
  return vdst;
}
     d55:	5e                   	pop    %esi
     d56:	89 d0                	mov    %edx,%eax
     d58:	5f                   	pop    %edi
     d59:	5d                   	pop    %ebp
     d5a:	c3                   	ret    

00000d5b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     d5b:	b8 01 00 00 00       	mov    $0x1,%eax
     d60:	cd 40                	int    $0x40
     d62:	c3                   	ret    

00000d63 <exit>:
SYSCALL(exit)
     d63:	b8 02 00 00 00       	mov    $0x2,%eax
     d68:	cd 40                	int    $0x40
     d6a:	c3                   	ret    

00000d6b <wait>:
SYSCALL(wait)
     d6b:	b8 03 00 00 00       	mov    $0x3,%eax
     d70:	cd 40                	int    $0x40
     d72:	c3                   	ret    

00000d73 <pipe>:
SYSCALL(pipe)
     d73:	b8 04 00 00 00       	mov    $0x4,%eax
     d78:	cd 40                	int    $0x40
     d7a:	c3                   	ret    

00000d7b <read>:
SYSCALL(read)
     d7b:	b8 05 00 00 00       	mov    $0x5,%eax
     d80:	cd 40                	int    $0x40
     d82:	c3                   	ret    

00000d83 <write>:
SYSCALL(write)
     d83:	b8 10 00 00 00       	mov    $0x10,%eax
     d88:	cd 40                	int    $0x40
     d8a:	c3                   	ret    

00000d8b <close>:
SYSCALL(close)
     d8b:	b8 15 00 00 00       	mov    $0x15,%eax
     d90:	cd 40                	int    $0x40
     d92:	c3                   	ret    

00000d93 <kill>:
SYSCALL(kill)
     d93:	b8 06 00 00 00       	mov    $0x6,%eax
     d98:	cd 40                	int    $0x40
     d9a:	c3                   	ret    

00000d9b <exec>:
SYSCALL(exec)
     d9b:	b8 07 00 00 00       	mov    $0x7,%eax
     da0:	cd 40                	int    $0x40
     da2:	c3                   	ret    

00000da3 <open>:
SYSCALL(open)
     da3:	b8 0f 00 00 00       	mov    $0xf,%eax
     da8:	cd 40                	int    $0x40
     daa:	c3                   	ret    

00000dab <mknod>:
SYSCALL(mknod)
     dab:	b8 11 00 00 00       	mov    $0x11,%eax
     db0:	cd 40                	int    $0x40
     db2:	c3                   	ret    

00000db3 <unlink>:
SYSCALL(unlink)
     db3:	b8 12 00 00 00       	mov    $0x12,%eax
     db8:	cd 40                	int    $0x40
     dba:	c3                   	ret    

00000dbb <fstat>:
SYSCALL(fstat)
     dbb:	b8 08 00 00 00       	mov    $0x8,%eax
     dc0:	cd 40                	int    $0x40
     dc2:	c3                   	ret    

00000dc3 <link>:
SYSCALL(link)
     dc3:	b8 13 00 00 00       	mov    $0x13,%eax
     dc8:	cd 40                	int    $0x40
     dca:	c3                   	ret    

00000dcb <mkdir>:
SYSCALL(mkdir)
     dcb:	b8 14 00 00 00       	mov    $0x14,%eax
     dd0:	cd 40                	int    $0x40
     dd2:	c3                   	ret    

00000dd3 <chdir>:
SYSCALL(chdir)
     dd3:	b8 09 00 00 00       	mov    $0x9,%eax
     dd8:	cd 40                	int    $0x40
     dda:	c3                   	ret    

00000ddb <dup>:
SYSCALL(dup)
     ddb:	b8 0a 00 00 00       	mov    $0xa,%eax
     de0:	cd 40                	int    $0x40
     de2:	c3                   	ret    

00000de3 <getpid>:
SYSCALL(getpid)
     de3:	b8 0b 00 00 00       	mov    $0xb,%eax
     de8:	cd 40                	int    $0x40
     dea:	c3                   	ret    

00000deb <sbrk>:
SYSCALL(sbrk)
     deb:	b8 0c 00 00 00       	mov    $0xc,%eax
     df0:	cd 40                	int    $0x40
     df2:	c3                   	ret    

00000df3 <sleep>:
SYSCALL(sleep)
     df3:	b8 0d 00 00 00       	mov    $0xd,%eax
     df8:	cd 40                	int    $0x40
     dfa:	c3                   	ret    

00000dfb <uptime>:
SYSCALL(uptime)
     dfb:	b8 0e 00 00 00       	mov    $0xe,%eax
     e00:	cd 40                	int    $0x40
     e02:	c3                   	ret    

00000e03 <getrss>:
SYSCALL(getrss)
     e03:	b8 16 00 00 00       	mov    $0x16,%eax
     e08:	cd 40                	int    $0x40
     e0a:	c3                   	ret    

00000e0b <getNumFreePages>:
     e0b:	b8 17 00 00 00       	mov    $0x17,%eax
     e10:	cd 40                	int    $0x40
     e12:	c3                   	ret    
     e13:	66 90                	xchg   %ax,%ax
     e15:	66 90                	xchg   %ax,%ax
     e17:	66 90                	xchg   %ax,%ax
     e19:	66 90                	xchg   %ax,%ax
     e1b:	66 90                	xchg   %ax,%ax
     e1d:	66 90                	xchg   %ax,%ax
     e1f:	90                   	nop

00000e20 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
     e20:	55                   	push   %ebp
     e21:	89 e5                	mov    %esp,%ebp
     e23:	57                   	push   %edi
     e24:	56                   	push   %esi
     e25:	53                   	push   %ebx
     e26:	83 ec 3c             	sub    $0x3c,%esp
     e29:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
     e2c:	89 d1                	mov    %edx,%ecx
{
     e2e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
     e31:	85 d2                	test   %edx,%edx
     e33:	0f 89 7f 00 00 00    	jns    eb8 <printint+0x98>
     e39:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
     e3d:	74 79                	je     eb8 <printint+0x98>
    neg = 1;
     e3f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
     e46:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
     e48:	31 db                	xor    %ebx,%ebx
     e4a:	8d 75 d7             	lea    -0x29(%ebp),%esi
     e4d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
     e50:	89 c8                	mov    %ecx,%eax
     e52:	31 d2                	xor    %edx,%edx
     e54:	89 cf                	mov    %ecx,%edi
     e56:	f7 75 c4             	divl   -0x3c(%ebp)
     e59:	0f b6 92 3c 13 00 00 	movzbl 0x133c(%edx),%edx
     e60:	89 45 c0             	mov    %eax,-0x40(%ebp)
     e63:	89 d8                	mov    %ebx,%eax
     e65:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
     e68:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
     e6b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
     e6e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
     e71:	76 dd                	jbe    e50 <printint+0x30>
  if(neg)
     e73:	8b 4d bc             	mov    -0x44(%ebp),%ecx
     e76:	85 c9                	test   %ecx,%ecx
     e78:	74 0c                	je     e86 <printint+0x66>
    buf[i++] = '-';
     e7a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
     e7f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
     e81:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
     e86:	8b 7d b8             	mov    -0x48(%ebp),%edi
     e89:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
     e8d:	eb 07                	jmp    e96 <printint+0x76>
     e8f:	90                   	nop
     e90:	0f b6 13             	movzbl (%ebx),%edx
     e93:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
     e96:	83 ec 04             	sub    $0x4,%esp
     e99:	88 55 d7             	mov    %dl,-0x29(%ebp)
     e9c:	6a 01                	push   $0x1
     e9e:	56                   	push   %esi
     e9f:	57                   	push   %edi
     ea0:	e8 de fe ff ff       	call   d83 <write>
  while(--i >= 0)
     ea5:	83 c4 10             	add    $0x10,%esp
     ea8:	39 de                	cmp    %ebx,%esi
     eaa:	75 e4                	jne    e90 <printint+0x70>
    putc(fd, buf[i]);
}
     eac:	8d 65 f4             	lea    -0xc(%ebp),%esp
     eaf:	5b                   	pop    %ebx
     eb0:	5e                   	pop    %esi
     eb1:	5f                   	pop    %edi
     eb2:	5d                   	pop    %ebp
     eb3:	c3                   	ret    
     eb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
     eb8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
     ebf:	eb 87                	jmp    e48 <printint+0x28>
     ec1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     ec8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     ecf:	90                   	nop

00000ed0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
     ed0:	f3 0f 1e fb          	endbr32 
     ed4:	55                   	push   %ebp
     ed5:	89 e5                	mov    %esp,%ebp
     ed7:	57                   	push   %edi
     ed8:	56                   	push   %esi
     ed9:	53                   	push   %ebx
     eda:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
     edd:	8b 75 0c             	mov    0xc(%ebp),%esi
     ee0:	0f b6 1e             	movzbl (%esi),%ebx
     ee3:	84 db                	test   %bl,%bl
     ee5:	0f 84 b4 00 00 00    	je     f9f <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
     eeb:	8d 45 10             	lea    0x10(%ebp),%eax
     eee:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
     ef1:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
     ef4:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
     ef6:	89 45 d0             	mov    %eax,-0x30(%ebp)
     ef9:	eb 33                	jmp    f2e <printf+0x5e>
     efb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     eff:	90                   	nop
     f00:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
     f03:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
     f08:	83 f8 25             	cmp    $0x25,%eax
     f0b:	74 17                	je     f24 <printf+0x54>
  write(fd, &c, 1);
     f0d:	83 ec 04             	sub    $0x4,%esp
     f10:	88 5d e7             	mov    %bl,-0x19(%ebp)
     f13:	6a 01                	push   $0x1
     f15:	57                   	push   %edi
     f16:	ff 75 08             	pushl  0x8(%ebp)
     f19:	e8 65 fe ff ff       	call   d83 <write>
     f1e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
     f21:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
     f24:	0f b6 1e             	movzbl (%esi),%ebx
     f27:	83 c6 01             	add    $0x1,%esi
     f2a:	84 db                	test   %bl,%bl
     f2c:	74 71                	je     f9f <printf+0xcf>
    c = fmt[i] & 0xff;
     f2e:	0f be cb             	movsbl %bl,%ecx
     f31:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
     f34:	85 d2                	test   %edx,%edx
     f36:	74 c8                	je     f00 <printf+0x30>
      }
    } else if(state == '%'){
     f38:	83 fa 25             	cmp    $0x25,%edx
     f3b:	75 e7                	jne    f24 <printf+0x54>
      if(c == 'd'){
     f3d:	83 f8 64             	cmp    $0x64,%eax
     f40:	0f 84 9a 00 00 00    	je     fe0 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
     f46:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
     f4c:	83 f9 70             	cmp    $0x70,%ecx
     f4f:	74 5f                	je     fb0 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
     f51:	83 f8 73             	cmp    $0x73,%eax
     f54:	0f 84 d6 00 00 00    	je     1030 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     f5a:	83 f8 63             	cmp    $0x63,%eax
     f5d:	0f 84 8d 00 00 00    	je     ff0 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
     f63:	83 f8 25             	cmp    $0x25,%eax
     f66:	0f 84 b4 00 00 00    	je     1020 <printf+0x150>
  write(fd, &c, 1);
     f6c:	83 ec 04             	sub    $0x4,%esp
     f6f:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
     f73:	6a 01                	push   $0x1
     f75:	57                   	push   %edi
     f76:	ff 75 08             	pushl  0x8(%ebp)
     f79:	e8 05 fe ff ff       	call   d83 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
     f7e:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
     f81:	83 c4 0c             	add    $0xc,%esp
     f84:	6a 01                	push   $0x1
     f86:	83 c6 01             	add    $0x1,%esi
     f89:	57                   	push   %edi
     f8a:	ff 75 08             	pushl  0x8(%ebp)
     f8d:	e8 f1 fd ff ff       	call   d83 <write>
  for(i = 0; fmt[i]; i++){
     f92:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
     f96:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
     f99:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
     f9b:	84 db                	test   %bl,%bl
     f9d:	75 8f                	jne    f2e <printf+0x5e>
    }
  }
}
     f9f:	8d 65 f4             	lea    -0xc(%ebp),%esp
     fa2:	5b                   	pop    %ebx
     fa3:	5e                   	pop    %esi
     fa4:	5f                   	pop    %edi
     fa5:	5d                   	pop    %ebp
     fa6:	c3                   	ret    
     fa7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     fae:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
     fb0:	83 ec 0c             	sub    $0xc,%esp
     fb3:	b9 10 00 00 00       	mov    $0x10,%ecx
     fb8:	6a 00                	push   $0x0
     fba:	8b 5d d0             	mov    -0x30(%ebp),%ebx
     fbd:	8b 45 08             	mov    0x8(%ebp),%eax
     fc0:	8b 13                	mov    (%ebx),%edx
     fc2:	e8 59 fe ff ff       	call   e20 <printint>
        ap++;
     fc7:	89 d8                	mov    %ebx,%eax
     fc9:	83 c4 10             	add    $0x10,%esp
      state = 0;
     fcc:	31 d2                	xor    %edx,%edx
        ap++;
     fce:	83 c0 04             	add    $0x4,%eax
     fd1:	89 45 d0             	mov    %eax,-0x30(%ebp)
     fd4:	e9 4b ff ff ff       	jmp    f24 <printf+0x54>
     fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
     fe0:	83 ec 0c             	sub    $0xc,%esp
     fe3:	b9 0a 00 00 00       	mov    $0xa,%ecx
     fe8:	6a 01                	push   $0x1
     fea:	eb ce                	jmp    fba <printf+0xea>
     fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
     ff0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
     ff3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
     ff6:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
     ff8:	6a 01                	push   $0x1
        ap++;
     ffa:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
     ffd:	57                   	push   %edi
     ffe:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
    1001:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    1004:	e8 7a fd ff ff       	call   d83 <write>
        ap++;
    1009:	89 5d d0             	mov    %ebx,-0x30(%ebp)
    100c:	83 c4 10             	add    $0x10,%esp
      state = 0;
    100f:	31 d2                	xor    %edx,%edx
    1011:	e9 0e ff ff ff       	jmp    f24 <printf+0x54>
    1016:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    101d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
    1020:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
    1023:	83 ec 04             	sub    $0x4,%esp
    1026:	e9 59 ff ff ff       	jmp    f84 <printf+0xb4>
    102b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    102f:	90                   	nop
        s = (char*)*ap;
    1030:	8b 45 d0             	mov    -0x30(%ebp),%eax
    1033:	8b 18                	mov    (%eax),%ebx
        ap++;
    1035:	83 c0 04             	add    $0x4,%eax
    1038:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
    103b:	85 db                	test   %ebx,%ebx
    103d:	74 17                	je     1056 <printf+0x186>
        while(*s != 0){
    103f:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
    1042:	31 d2                	xor    %edx,%edx
        while(*s != 0){
    1044:	84 c0                	test   %al,%al
    1046:	0f 84 d8 fe ff ff    	je     f24 <printf+0x54>
    104c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
    104f:	89 de                	mov    %ebx,%esi
    1051:	8b 5d 08             	mov    0x8(%ebp),%ebx
    1054:	eb 1a                	jmp    1070 <printf+0x1a0>
          s = "(null)";
    1056:	bb 34 13 00 00       	mov    $0x1334,%ebx
        while(*s != 0){
    105b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
    105e:	b8 28 00 00 00       	mov    $0x28,%eax
    1063:	89 de                	mov    %ebx,%esi
    1065:	8b 5d 08             	mov    0x8(%ebp),%ebx
    1068:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    106f:	90                   	nop
  write(fd, &c, 1);
    1070:	83 ec 04             	sub    $0x4,%esp
          s++;
    1073:	83 c6 01             	add    $0x1,%esi
    1076:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    1079:	6a 01                	push   $0x1
    107b:	57                   	push   %edi
    107c:	53                   	push   %ebx
    107d:	e8 01 fd ff ff       	call   d83 <write>
        while(*s != 0){
    1082:	0f b6 06             	movzbl (%esi),%eax
    1085:	83 c4 10             	add    $0x10,%esp
    1088:	84 c0                	test   %al,%al
    108a:	75 e4                	jne    1070 <printf+0x1a0>
    108c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
    108f:	31 d2                	xor    %edx,%edx
    1091:	e9 8e fe ff ff       	jmp    f24 <printf+0x54>
    1096:	66 90                	xchg   %ax,%ax
    1098:	66 90                	xchg   %ax,%ax
    109a:	66 90                	xchg   %ax,%ax
    109c:	66 90                	xchg   %ax,%ax
    109e:	66 90                	xchg   %ax,%ax

000010a0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    10a0:	f3 0f 1e fb          	endbr32 
    10a4:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    10a5:	a1 a4 19 00 00       	mov    0x19a4,%eax
{
    10aa:	89 e5                	mov    %esp,%ebp
    10ac:	57                   	push   %edi
    10ad:	56                   	push   %esi
    10ae:	53                   	push   %ebx
    10af:	8b 5d 08             	mov    0x8(%ebp),%ebx
    10b2:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
    10b4:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    10b7:	39 c8                	cmp    %ecx,%eax
    10b9:	73 15                	jae    10d0 <free+0x30>
    10bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    10bf:	90                   	nop
    10c0:	39 d1                	cmp    %edx,%ecx
    10c2:	72 14                	jb     10d8 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    10c4:	39 d0                	cmp    %edx,%eax
    10c6:	73 10                	jae    10d8 <free+0x38>
{
    10c8:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    10ca:	8b 10                	mov    (%eax),%edx
    10cc:	39 c8                	cmp    %ecx,%eax
    10ce:	72 f0                	jb     10c0 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    10d0:	39 d0                	cmp    %edx,%eax
    10d2:	72 f4                	jb     10c8 <free+0x28>
    10d4:	39 d1                	cmp    %edx,%ecx
    10d6:	73 f0                	jae    10c8 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
    10d8:	8b 73 fc             	mov    -0x4(%ebx),%esi
    10db:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    10de:	39 fa                	cmp    %edi,%edx
    10e0:	74 1e                	je     1100 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    10e2:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    10e5:	8b 50 04             	mov    0x4(%eax),%edx
    10e8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    10eb:	39 f1                	cmp    %esi,%ecx
    10ed:	74 28                	je     1117 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    10ef:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
    10f1:	5b                   	pop    %ebx
  freep = p;
    10f2:	a3 a4 19 00 00       	mov    %eax,0x19a4
}
    10f7:	5e                   	pop    %esi
    10f8:	5f                   	pop    %edi
    10f9:	5d                   	pop    %ebp
    10fa:	c3                   	ret    
    10fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    10ff:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
    1100:	03 72 04             	add    0x4(%edx),%esi
    1103:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    1106:	8b 10                	mov    (%eax),%edx
    1108:	8b 12                	mov    (%edx),%edx
    110a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    110d:	8b 50 04             	mov    0x4(%eax),%edx
    1110:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    1113:	39 f1                	cmp    %esi,%ecx
    1115:	75 d8                	jne    10ef <free+0x4f>
    p->s.size += bp->s.size;
    1117:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
    111a:	a3 a4 19 00 00       	mov    %eax,0x19a4
    p->s.size += bp->s.size;
    111f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1122:	8b 53 f8             	mov    -0x8(%ebx),%edx
    1125:	89 10                	mov    %edx,(%eax)
}
    1127:	5b                   	pop    %ebx
    1128:	5e                   	pop    %esi
    1129:	5f                   	pop    %edi
    112a:	5d                   	pop    %ebp
    112b:	c3                   	ret    
    112c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00001130 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1130:	f3 0f 1e fb          	endbr32 
    1134:	55                   	push   %ebp
    1135:	89 e5                	mov    %esp,%ebp
    1137:	57                   	push   %edi
    1138:	56                   	push   %esi
    1139:	53                   	push   %ebx
    113a:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    113d:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
    1140:	8b 3d a4 19 00 00    	mov    0x19a4,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1146:	8d 70 07             	lea    0x7(%eax),%esi
    1149:	c1 ee 03             	shr    $0x3,%esi
    114c:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
    114f:	85 ff                	test   %edi,%edi
    1151:	0f 84 a9 00 00 00    	je     1200 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1157:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
    1159:	8b 48 04             	mov    0x4(%eax),%ecx
    115c:	39 f1                	cmp    %esi,%ecx
    115e:	73 6d                	jae    11cd <malloc+0x9d>
    1160:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
    1166:	bb 00 10 00 00       	mov    $0x1000,%ebx
    116b:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
    116e:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
    1175:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    1178:	eb 17                	jmp    1191 <malloc+0x61>
    117a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1180:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
    1182:	8b 4a 04             	mov    0x4(%edx),%ecx
    1185:	39 f1                	cmp    %esi,%ecx
    1187:	73 4f                	jae    11d8 <malloc+0xa8>
    1189:	8b 3d a4 19 00 00    	mov    0x19a4,%edi
    118f:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1191:	39 c7                	cmp    %eax,%edi
    1193:	75 eb                	jne    1180 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
    1195:	83 ec 0c             	sub    $0xc,%esp
    1198:	ff 75 e4             	pushl  -0x1c(%ebp)
    119b:	e8 4b fc ff ff       	call   deb <sbrk>
  if(p == (char*)-1)
    11a0:	83 c4 10             	add    $0x10,%esp
    11a3:	83 f8 ff             	cmp    $0xffffffff,%eax
    11a6:	74 1b                	je     11c3 <malloc+0x93>
  hp->s.size = nu;
    11a8:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
    11ab:	83 ec 0c             	sub    $0xc,%esp
    11ae:	83 c0 08             	add    $0x8,%eax
    11b1:	50                   	push   %eax
    11b2:	e8 e9 fe ff ff       	call   10a0 <free>
  return freep;
    11b7:	a1 a4 19 00 00       	mov    0x19a4,%eax
      if((p = morecore(nunits)) == 0)
    11bc:	83 c4 10             	add    $0x10,%esp
    11bf:	85 c0                	test   %eax,%eax
    11c1:	75 bd                	jne    1180 <malloc+0x50>
        return 0;
  }
}
    11c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
    11c6:	31 c0                	xor    %eax,%eax
}
    11c8:	5b                   	pop    %ebx
    11c9:	5e                   	pop    %esi
    11ca:	5f                   	pop    %edi
    11cb:	5d                   	pop    %ebp
    11cc:	c3                   	ret    
    if(p->s.size >= nunits){
    11cd:	89 c2                	mov    %eax,%edx
    11cf:	89 f8                	mov    %edi,%eax
    11d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
    11d8:	39 ce                	cmp    %ecx,%esi
    11da:	74 54                	je     1230 <malloc+0x100>
        p->s.size -= nunits;
    11dc:	29 f1                	sub    %esi,%ecx
    11de:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
    11e1:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
    11e4:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
    11e7:	a3 a4 19 00 00       	mov    %eax,0x19a4
}
    11ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
    11ef:	8d 42 08             	lea    0x8(%edx),%eax
}
    11f2:	5b                   	pop    %ebx
    11f3:	5e                   	pop    %esi
    11f4:	5f                   	pop    %edi
    11f5:	5d                   	pop    %ebp
    11f6:	c3                   	ret    
    11f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    11fe:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
    1200:	c7 05 a4 19 00 00 a8 	movl   $0x19a8,0x19a4
    1207:	19 00 00 
    base.s.size = 0;
    120a:	bf a8 19 00 00       	mov    $0x19a8,%edi
    base.s.ptr = freep = prevp = &base;
    120f:	c7 05 a8 19 00 00 a8 	movl   $0x19a8,0x19a8
    1216:	19 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1219:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
    121b:	c7 05 ac 19 00 00 00 	movl   $0x0,0x19ac
    1222:	00 00 00 
    if(p->s.size >= nunits){
    1225:	e9 36 ff ff ff       	jmp    1160 <malloc+0x30>
    122a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
    1230:	8b 0a                	mov    (%edx),%ecx
    1232:	89 08                	mov    %ecx,(%eax)
    1234:	eb b1                	jmp    11e7 <malloc+0xb7>
