
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0001a117          	auipc	sp,0x1a
    80000004:	c7010113          	add	sp,sp,-912 # 80019c70 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	add	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	6d0050ef          	jal	800056e6 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	add	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	add	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	sll	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00022797          	auipc	a5,0x22
    80000034:	d4078793          	add	a5,a5,-704 # 80021d70 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	sll	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	132080e7          	jalr	306(ra) # 8000017a <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	8b090913          	add	s2,s2,-1872 # 80008900 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	074080e7          	jalr	116(ra) # 800060ce <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	114080e7          	jalr	276(ra) # 80006182 <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	add	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	add	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	b0c080e7          	jalr	-1268(ra) # 80005b96 <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	add	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	add	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78713          	add	a4,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	00e504b3          	add	s1,a0,a4
    800000ac:	777d                	lui	a4,0xfffff
    800000ae:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b0:	94be                	add	s1,s1,a5
    800000b2:	0095ee63          	bltu	a1,s1,800000ce <freerange+0x3c>
    800000b6:	892e                	mv	s2,a1
    kfree(p);
    800000b8:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ba:	6985                	lui	s3,0x1
    kfree(p);
    800000bc:	01448533          	add	a0,s1,s4
    800000c0:	00000097          	auipc	ra,0x0
    800000c4:	f5c080e7          	jalr	-164(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c8:	94ce                	add	s1,s1,s3
    800000ca:	fe9979e3          	bgeu	s2,s1,800000bc <freerange+0x2a>
}
    800000ce:	70a2                	ld	ra,40(sp)
    800000d0:	7402                	ld	s0,32(sp)
    800000d2:	64e2                	ld	s1,24(sp)
    800000d4:	6942                	ld	s2,16(sp)
    800000d6:	69a2                	ld	s3,8(sp)
    800000d8:	6a02                	ld	s4,0(sp)
    800000da:	6145                	add	sp,sp,48
    800000dc:	8082                	ret

00000000800000de <kinit>:
{
    800000de:	1141                	add	sp,sp,-16
    800000e0:	e406                	sd	ra,8(sp)
    800000e2:	e022                	sd	s0,0(sp)
    800000e4:	0800                	add	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e6:	00008597          	auipc	a1,0x8
    800000ea:	f3258593          	add	a1,a1,-206 # 80008018 <etext+0x18>
    800000ee:	00009517          	auipc	a0,0x9
    800000f2:	81250513          	add	a0,a0,-2030 # 80008900 <kmem>
    800000f6:	00006097          	auipc	ra,0x6
    800000fa:	f48080e7          	jalr	-184(ra) # 8000603e <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	sll	a1,a1,0x1b
    80000102:	00022517          	auipc	a0,0x22
    80000106:	c6e50513          	add	a0,a0,-914 # 80021d70 <end>
    8000010a:	00000097          	auipc	ra,0x0
    8000010e:	f88080e7          	jalr	-120(ra) # 80000092 <freerange>
}
    80000112:	60a2                	ld	ra,8(sp)
    80000114:	6402                	ld	s0,0(sp)
    80000116:	0141                	add	sp,sp,16
    80000118:	8082                	ret

000000008000011a <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    8000011a:	1101                	add	sp,sp,-32
    8000011c:	ec06                	sd	ra,24(sp)
    8000011e:	e822                	sd	s0,16(sp)
    80000120:	e426                	sd	s1,8(sp)
    80000122:	1000                	add	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000124:	00008497          	auipc	s1,0x8
    80000128:	7dc48493          	add	s1,s1,2012 # 80008900 <kmem>
    8000012c:	8526                	mv	a0,s1
    8000012e:	00006097          	auipc	ra,0x6
    80000132:	fa0080e7          	jalr	-96(ra) # 800060ce <acquire>
  r = kmem.freelist;
    80000136:	6c84                	ld	s1,24(s1)
  if(r)
    80000138:	c885                	beqz	s1,80000168 <kalloc+0x4e>
    kmem.freelist = r->next;
    8000013a:	609c                	ld	a5,0(s1)
    8000013c:	00008517          	auipc	a0,0x8
    80000140:	7c450513          	add	a0,a0,1988 # 80008900 <kmem>
    80000144:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000146:	00006097          	auipc	ra,0x6
    8000014a:	03c080e7          	jalr	60(ra) # 80006182 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014e:	6605                	lui	a2,0x1
    80000150:	4595                	li	a1,5
    80000152:	8526                	mv	a0,s1
    80000154:	00000097          	auipc	ra,0x0
    80000158:	026080e7          	jalr	38(ra) # 8000017a <memset>
  return (void*)r;
}
    8000015c:	8526                	mv	a0,s1
    8000015e:	60e2                	ld	ra,24(sp)
    80000160:	6442                	ld	s0,16(sp)
    80000162:	64a2                	ld	s1,8(sp)
    80000164:	6105                	add	sp,sp,32
    80000166:	8082                	ret
  release(&kmem.lock);
    80000168:	00008517          	auipc	a0,0x8
    8000016c:	79850513          	add	a0,a0,1944 # 80008900 <kmem>
    80000170:	00006097          	auipc	ra,0x6
    80000174:	012080e7          	jalr	18(ra) # 80006182 <release>
  if(r)
    80000178:	b7d5                	j	8000015c <kalloc+0x42>

000000008000017a <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000017a:	1141                	add	sp,sp,-16
    8000017c:	e422                	sd	s0,8(sp)
    8000017e:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000180:	ca19                	beqz	a2,80000196 <memset+0x1c>
    80000182:	87aa                	mv	a5,a0
    80000184:	1602                	sll	a2,a2,0x20
    80000186:	9201                	srl	a2,a2,0x20
    80000188:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    8000018c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000190:	0785                	add	a5,a5,1
    80000192:	fee79de3          	bne	a5,a4,8000018c <memset+0x12>
  }
  return dst;
}
    80000196:	6422                	ld	s0,8(sp)
    80000198:	0141                	add	sp,sp,16
    8000019a:	8082                	ret

000000008000019c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019c:	1141                	add	sp,sp,-16
    8000019e:	e422                	sd	s0,8(sp)
    800001a0:	0800                	add	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a2:	ca05                	beqz	a2,800001d2 <memcmp+0x36>
    800001a4:	fff6069b          	addw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800001a8:	1682                	sll	a3,a3,0x20
    800001aa:	9281                	srl	a3,a3,0x20
    800001ac:	0685                	add	a3,a3,1
    800001ae:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001b0:	00054783          	lbu	a5,0(a0)
    800001b4:	0005c703          	lbu	a4,0(a1)
    800001b8:	00e79863          	bne	a5,a4,800001c8 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001bc:	0505                	add	a0,a0,1
    800001be:	0585                	add	a1,a1,1
  while(n-- > 0){
    800001c0:	fed518e3          	bne	a0,a3,800001b0 <memcmp+0x14>
  }

  return 0;
    800001c4:	4501                	li	a0,0
    800001c6:	a019                	j	800001cc <memcmp+0x30>
      return *s1 - *s2;
    800001c8:	40e7853b          	subw	a0,a5,a4
}
    800001cc:	6422                	ld	s0,8(sp)
    800001ce:	0141                	add	sp,sp,16
    800001d0:	8082                	ret
  return 0;
    800001d2:	4501                	li	a0,0
    800001d4:	bfe5                	j	800001cc <memcmp+0x30>

00000000800001d6 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d6:	1141                	add	sp,sp,-16
    800001d8:	e422                	sd	s0,8(sp)
    800001da:	0800                	add	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001dc:	c205                	beqz	a2,800001fc <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001de:	02a5e263          	bltu	a1,a0,80000202 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001e2:	1602                	sll	a2,a2,0x20
    800001e4:	9201                	srl	a2,a2,0x20
    800001e6:	00c587b3          	add	a5,a1,a2
{
    800001ea:	872a                	mv	a4,a0
      *d++ = *s++;
    800001ec:	0585                	add	a1,a1,1
    800001ee:	0705                	add	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdd291>
    800001f0:	fff5c683          	lbu	a3,-1(a1)
    800001f4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001f8:	fef59ae3          	bne	a1,a5,800001ec <memmove+0x16>

  return dst;
}
    800001fc:	6422                	ld	s0,8(sp)
    800001fe:	0141                	add	sp,sp,16
    80000200:	8082                	ret
  if(s < d && s + n > d){
    80000202:	02061693          	sll	a3,a2,0x20
    80000206:	9281                	srl	a3,a3,0x20
    80000208:	00d58733          	add	a4,a1,a3
    8000020c:	fce57be3          	bgeu	a0,a4,800001e2 <memmove+0xc>
    d += n;
    80000210:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000212:	fff6079b          	addw	a5,a2,-1
    80000216:	1782                	sll	a5,a5,0x20
    80000218:	9381                	srl	a5,a5,0x20
    8000021a:	fff7c793          	not	a5,a5
    8000021e:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000220:	177d                	add	a4,a4,-1
    80000222:	16fd                	add	a3,a3,-1
    80000224:	00074603          	lbu	a2,0(a4)
    80000228:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000022c:	fee79ae3          	bne	a5,a4,80000220 <memmove+0x4a>
    80000230:	b7f1                	j	800001fc <memmove+0x26>

0000000080000232 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000232:	1141                	add	sp,sp,-16
    80000234:	e406                	sd	ra,8(sp)
    80000236:	e022                	sd	s0,0(sp)
    80000238:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
    8000023a:	00000097          	auipc	ra,0x0
    8000023e:	f9c080e7          	jalr	-100(ra) # 800001d6 <memmove>
}
    80000242:	60a2                	ld	ra,8(sp)
    80000244:	6402                	ld	s0,0(sp)
    80000246:	0141                	add	sp,sp,16
    80000248:	8082                	ret

000000008000024a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000024a:	1141                	add	sp,sp,-16
    8000024c:	e422                	sd	s0,8(sp)
    8000024e:	0800                	add	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000250:	ce11                	beqz	a2,8000026c <strncmp+0x22>
    80000252:	00054783          	lbu	a5,0(a0)
    80000256:	cf89                	beqz	a5,80000270 <strncmp+0x26>
    80000258:	0005c703          	lbu	a4,0(a1)
    8000025c:	00f71a63          	bne	a4,a5,80000270 <strncmp+0x26>
    n--, p++, q++;
    80000260:	367d                	addw	a2,a2,-1
    80000262:	0505                	add	a0,a0,1
    80000264:	0585                	add	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000266:	f675                	bnez	a2,80000252 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000268:	4501                	li	a0,0
    8000026a:	a809                	j	8000027c <strncmp+0x32>
    8000026c:	4501                	li	a0,0
    8000026e:	a039                	j	8000027c <strncmp+0x32>
  if(n == 0)
    80000270:	ca09                	beqz	a2,80000282 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000272:	00054503          	lbu	a0,0(a0)
    80000276:	0005c783          	lbu	a5,0(a1)
    8000027a:	9d1d                	subw	a0,a0,a5
}
    8000027c:	6422                	ld	s0,8(sp)
    8000027e:	0141                	add	sp,sp,16
    80000280:	8082                	ret
    return 0;
    80000282:	4501                	li	a0,0
    80000284:	bfe5                	j	8000027c <strncmp+0x32>

0000000080000286 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000286:	1141                	add	sp,sp,-16
    80000288:	e422                	sd	s0,8(sp)
    8000028a:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    8000028c:	87aa                	mv	a5,a0
    8000028e:	86b2                	mv	a3,a2
    80000290:	367d                	addw	a2,a2,-1
    80000292:	00d05963          	blez	a3,800002a4 <strncpy+0x1e>
    80000296:	0785                	add	a5,a5,1
    80000298:	0005c703          	lbu	a4,0(a1)
    8000029c:	fee78fa3          	sb	a4,-1(a5)
    800002a0:	0585                	add	a1,a1,1
    800002a2:	f775                	bnez	a4,8000028e <strncpy+0x8>
    ;
  while(n-- > 0)
    800002a4:	873e                	mv	a4,a5
    800002a6:	9fb5                	addw	a5,a5,a3
    800002a8:	37fd                	addw	a5,a5,-1
    800002aa:	00c05963          	blez	a2,800002bc <strncpy+0x36>
    *s++ = 0;
    800002ae:	0705                	add	a4,a4,1
    800002b0:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    800002b4:	40e786bb          	subw	a3,a5,a4
    800002b8:	fed04be3          	bgtz	a3,800002ae <strncpy+0x28>
  return os;
}
    800002bc:	6422                	ld	s0,8(sp)
    800002be:	0141                	add	sp,sp,16
    800002c0:	8082                	ret

00000000800002c2 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002c2:	1141                	add	sp,sp,-16
    800002c4:	e422                	sd	s0,8(sp)
    800002c6:	0800                	add	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002c8:	02c05363          	blez	a2,800002ee <safestrcpy+0x2c>
    800002cc:	fff6069b          	addw	a3,a2,-1
    800002d0:	1682                	sll	a3,a3,0x20
    800002d2:	9281                	srl	a3,a3,0x20
    800002d4:	96ae                	add	a3,a3,a1
    800002d6:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002d8:	00d58963          	beq	a1,a3,800002ea <safestrcpy+0x28>
    800002dc:	0585                	add	a1,a1,1
    800002de:	0785                	add	a5,a5,1
    800002e0:	fff5c703          	lbu	a4,-1(a1)
    800002e4:	fee78fa3          	sb	a4,-1(a5)
    800002e8:	fb65                	bnez	a4,800002d8 <safestrcpy+0x16>
    ;
  *s = 0;
    800002ea:	00078023          	sb	zero,0(a5)
  return os;
}
    800002ee:	6422                	ld	s0,8(sp)
    800002f0:	0141                	add	sp,sp,16
    800002f2:	8082                	ret

00000000800002f4 <strlen>:

int
strlen(const char *s)
{
    800002f4:	1141                	add	sp,sp,-16
    800002f6:	e422                	sd	s0,8(sp)
    800002f8:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002fa:	00054783          	lbu	a5,0(a0)
    800002fe:	cf91                	beqz	a5,8000031a <strlen+0x26>
    80000300:	0505                	add	a0,a0,1
    80000302:	87aa                	mv	a5,a0
    80000304:	86be                	mv	a3,a5
    80000306:	0785                	add	a5,a5,1
    80000308:	fff7c703          	lbu	a4,-1(a5)
    8000030c:	ff65                	bnez	a4,80000304 <strlen+0x10>
    8000030e:	40a6853b          	subw	a0,a3,a0
    80000312:	2505                	addw	a0,a0,1
    ;
  return n;
}
    80000314:	6422                	ld	s0,8(sp)
    80000316:	0141                	add	sp,sp,16
    80000318:	8082                	ret
  for(n = 0; s[n]; n++)
    8000031a:	4501                	li	a0,0
    8000031c:	bfe5                	j	80000314 <strlen+0x20>

000000008000031e <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    8000031e:	1141                	add	sp,sp,-16
    80000320:	e406                	sd	ra,8(sp)
    80000322:	e022                	sd	s0,0(sp)
    80000324:	0800                	add	s0,sp,16
  if(cpuid() == 0){
    80000326:	00001097          	auipc	ra,0x1
    8000032a:	b58080e7          	jalr	-1192(ra) # 80000e7e <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    8000032e:	00008717          	auipc	a4,0x8
    80000332:	5a270713          	add	a4,a4,1442 # 800088d0 <started>
  if(cpuid() == 0){
    80000336:	c139                	beqz	a0,8000037c <main+0x5e>
    while(started == 0)
    80000338:	431c                	lw	a5,0(a4)
    8000033a:	2781                	sext.w	a5,a5
    8000033c:	dff5                	beqz	a5,80000338 <main+0x1a>
      ;
    __sync_synchronize();
    8000033e:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000342:	00001097          	auipc	ra,0x1
    80000346:	b3c080e7          	jalr	-1220(ra) # 80000e7e <cpuid>
    8000034a:	85aa                	mv	a1,a0
    8000034c:	00008517          	auipc	a0,0x8
    80000350:	cec50513          	add	a0,a0,-788 # 80008038 <etext+0x38>
    80000354:	00006097          	auipc	ra,0x6
    80000358:	88c080e7          	jalr	-1908(ra) # 80005be0 <printf>
    kvminithart();    // turn on paging
    8000035c:	00000097          	auipc	ra,0x0
    80000360:	0d8080e7          	jalr	216(ra) # 80000434 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000364:	00001097          	auipc	ra,0x1
    80000368:	7e8080e7          	jalr	2024(ra) # 80001b4c <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000036c:	00005097          	auipc	ra,0x5
    80000370:	d34080e7          	jalr	-716(ra) # 800050a0 <plicinithart>
  }

  scheduler();        
    80000374:	00001097          	auipc	ra,0x1
    80000378:	030080e7          	jalr	48(ra) # 800013a4 <scheduler>
    consoleinit();
    8000037c:	00005097          	auipc	ra,0x5
    80000380:	72a080e7          	jalr	1834(ra) # 80005aa6 <consoleinit>
    printfinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	a3c080e7          	jalr	-1476(ra) # 80005dc0 <printfinit>
    printf("\n");
    8000038c:	00008517          	auipc	a0,0x8
    80000390:	cbc50513          	add	a0,a0,-836 # 80008048 <etext+0x48>
    80000394:	00006097          	auipc	ra,0x6
    80000398:	84c080e7          	jalr	-1972(ra) # 80005be0 <printf>
    printf("xv6 kernel is booting\n");
    8000039c:	00008517          	auipc	a0,0x8
    800003a0:	c8450513          	add	a0,a0,-892 # 80008020 <etext+0x20>
    800003a4:	00006097          	auipc	ra,0x6
    800003a8:	83c080e7          	jalr	-1988(ra) # 80005be0 <printf>
    printf("\n");
    800003ac:	00008517          	auipc	a0,0x8
    800003b0:	c9c50513          	add	a0,a0,-868 # 80008048 <etext+0x48>
    800003b4:	00006097          	auipc	ra,0x6
    800003b8:	82c080e7          	jalr	-2004(ra) # 80005be0 <printf>
    kinit();         // physical page allocator
    800003bc:	00000097          	auipc	ra,0x0
    800003c0:	d22080e7          	jalr	-734(ra) # 800000de <kinit>
    kvminit();       // create kernel page table
    800003c4:	00000097          	auipc	ra,0x0
    800003c8:	34a080e7          	jalr	842(ra) # 8000070e <kvminit>
    kvminithart();   // turn on paging
    800003cc:	00000097          	auipc	ra,0x0
    800003d0:	068080e7          	jalr	104(ra) # 80000434 <kvminithart>
    procinit();      // process table
    800003d4:	00001097          	auipc	ra,0x1
    800003d8:	9f6080e7          	jalr	-1546(ra) # 80000dca <procinit>
    trapinit();      // trap vectors
    800003dc:	00001097          	auipc	ra,0x1
    800003e0:	748080e7          	jalr	1864(ra) # 80001b24 <trapinit>
    trapinithart();  // install kernel trap vector
    800003e4:	00001097          	auipc	ra,0x1
    800003e8:	768080e7          	jalr	1896(ra) # 80001b4c <trapinithart>
    plicinit();      // set up interrupt controller
    800003ec:	00005097          	auipc	ra,0x5
    800003f0:	c9e080e7          	jalr	-866(ra) # 8000508a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	cac080e7          	jalr	-852(ra) # 800050a0 <plicinithart>
    binit();         // buffer cache
    800003fc:	00002097          	auipc	ra,0x2
    80000400:	e9e080e7          	jalr	-354(ra) # 8000229a <binit>
    iinit();         // inode table
    80000404:	00002097          	auipc	ra,0x2
    80000408:	53c080e7          	jalr	1340(ra) # 80002940 <iinit>
    fileinit();      // file table
    8000040c:	00003097          	auipc	ra,0x3
    80000410:	4b2080e7          	jalr	1202(ra) # 800038be <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000414:	00005097          	auipc	ra,0x5
    80000418:	d94080e7          	jalr	-620(ra) # 800051a8 <virtio_disk_init>
    userinit();      // first user process
    8000041c:	00001097          	auipc	ra,0x1
    80000420:	d6a080e7          	jalr	-662(ra) # 80001186 <userinit>
    __sync_synchronize();
    80000424:	0ff0000f          	fence
    started = 1;
    80000428:	4785                	li	a5,1
    8000042a:	00008717          	auipc	a4,0x8
    8000042e:	4af72323          	sw	a5,1190(a4) # 800088d0 <started>
    80000432:	b789                	j	80000374 <main+0x56>

0000000080000434 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000434:	1141                	add	sp,sp,-16
    80000436:	e422                	sd	s0,8(sp)
    80000438:	0800                	add	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    8000043a:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    8000043e:	00008797          	auipc	a5,0x8
    80000442:	49a7b783          	ld	a5,1178(a5) # 800088d8 <kernel_pagetable>
    80000446:	83b1                	srl	a5,a5,0xc
    80000448:	577d                	li	a4,-1
    8000044a:	177e                	sll	a4,a4,0x3f
    8000044c:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    8000044e:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000452:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000456:	6422                	ld	s0,8(sp)
    80000458:	0141                	add	sp,sp,16
    8000045a:	8082                	ret

000000008000045c <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000045c:	7139                	add	sp,sp,-64
    8000045e:	fc06                	sd	ra,56(sp)
    80000460:	f822                	sd	s0,48(sp)
    80000462:	f426                	sd	s1,40(sp)
    80000464:	f04a                	sd	s2,32(sp)
    80000466:	ec4e                	sd	s3,24(sp)
    80000468:	e852                	sd	s4,16(sp)
    8000046a:	e456                	sd	s5,8(sp)
    8000046c:	e05a                	sd	s6,0(sp)
    8000046e:	0080                	add	s0,sp,64
    80000470:	84aa                	mv	s1,a0
    80000472:	89ae                	mv	s3,a1
    80000474:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000476:	57fd                	li	a5,-1
    80000478:	83e9                	srl	a5,a5,0x1a
    8000047a:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000047c:	4b31                	li	s6,12
  if(va >= MAXVA)
    8000047e:	04b7f263          	bgeu	a5,a1,800004c2 <walk+0x66>
    panic("walk");
    80000482:	00008517          	auipc	a0,0x8
    80000486:	bce50513          	add	a0,a0,-1074 # 80008050 <etext+0x50>
    8000048a:	00005097          	auipc	ra,0x5
    8000048e:	70c080e7          	jalr	1804(ra) # 80005b96 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000492:	060a8663          	beqz	s5,800004fe <walk+0xa2>
    80000496:	00000097          	auipc	ra,0x0
    8000049a:	c84080e7          	jalr	-892(ra) # 8000011a <kalloc>
    8000049e:	84aa                	mv	s1,a0
    800004a0:	c529                	beqz	a0,800004ea <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004a2:	6605                	lui	a2,0x1
    800004a4:	4581                	li	a1,0
    800004a6:	00000097          	auipc	ra,0x0
    800004aa:	cd4080e7          	jalr	-812(ra) # 8000017a <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004ae:	00c4d793          	srl	a5,s1,0xc
    800004b2:	07aa                	sll	a5,a5,0xa
    800004b4:	0017e793          	or	a5,a5,1
    800004b8:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004bc:	3a5d                	addw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdd287>
    800004be:	036a0063          	beq	s4,s6,800004de <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004c2:	0149d933          	srl	s2,s3,s4
    800004c6:	1ff97913          	and	s2,s2,511
    800004ca:	090e                	sll	s2,s2,0x3
    800004cc:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004ce:	00093483          	ld	s1,0(s2)
    800004d2:	0014f793          	and	a5,s1,1
    800004d6:	dfd5                	beqz	a5,80000492 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004d8:	80a9                	srl	s1,s1,0xa
    800004da:	04b2                	sll	s1,s1,0xc
    800004dc:	b7c5                	j	800004bc <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004de:	00c9d513          	srl	a0,s3,0xc
    800004e2:	1ff57513          	and	a0,a0,511
    800004e6:	050e                	sll	a0,a0,0x3
    800004e8:	9526                	add	a0,a0,s1
}
    800004ea:	70e2                	ld	ra,56(sp)
    800004ec:	7442                	ld	s0,48(sp)
    800004ee:	74a2                	ld	s1,40(sp)
    800004f0:	7902                	ld	s2,32(sp)
    800004f2:	69e2                	ld	s3,24(sp)
    800004f4:	6a42                	ld	s4,16(sp)
    800004f6:	6aa2                	ld	s5,8(sp)
    800004f8:	6b02                	ld	s6,0(sp)
    800004fa:	6121                	add	sp,sp,64
    800004fc:	8082                	ret
        return 0;
    800004fe:	4501                	li	a0,0
    80000500:	b7ed                	j	800004ea <walk+0x8e>

0000000080000502 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000502:	57fd                	li	a5,-1
    80000504:	83e9                	srl	a5,a5,0x1a
    80000506:	00b7f463          	bgeu	a5,a1,8000050e <walkaddr+0xc>
    return 0;
    8000050a:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000050c:	8082                	ret
{
    8000050e:	1141                	add	sp,sp,-16
    80000510:	e406                	sd	ra,8(sp)
    80000512:	e022                	sd	s0,0(sp)
    80000514:	0800                	add	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000516:	4601                	li	a2,0
    80000518:	00000097          	auipc	ra,0x0
    8000051c:	f44080e7          	jalr	-188(ra) # 8000045c <walk>
  if(pte == 0)
    80000520:	c105                	beqz	a0,80000540 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000522:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000524:	0117f693          	and	a3,a5,17
    80000528:	4745                	li	a4,17
    return 0;
    8000052a:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000052c:	00e68663          	beq	a3,a4,80000538 <walkaddr+0x36>
}
    80000530:	60a2                	ld	ra,8(sp)
    80000532:	6402                	ld	s0,0(sp)
    80000534:	0141                	add	sp,sp,16
    80000536:	8082                	ret
  pa = PTE2PA(*pte);
    80000538:	83a9                	srl	a5,a5,0xa
    8000053a:	00c79513          	sll	a0,a5,0xc
  return pa;
    8000053e:	bfcd                	j	80000530 <walkaddr+0x2e>
    return 0;
    80000540:	4501                	li	a0,0
    80000542:	b7fd                	j	80000530 <walkaddr+0x2e>

0000000080000544 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000544:	715d                	add	sp,sp,-80
    80000546:	e486                	sd	ra,72(sp)
    80000548:	e0a2                	sd	s0,64(sp)
    8000054a:	fc26                	sd	s1,56(sp)
    8000054c:	f84a                	sd	s2,48(sp)
    8000054e:	f44e                	sd	s3,40(sp)
    80000550:	f052                	sd	s4,32(sp)
    80000552:	ec56                	sd	s5,24(sp)
    80000554:	e85a                	sd	s6,16(sp)
    80000556:	e45e                	sd	s7,8(sp)
    80000558:	0880                	add	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000055a:	03459793          	sll	a5,a1,0x34
    8000055e:	e7b9                	bnez	a5,800005ac <mappages+0x68>
    80000560:	8aaa                	mv	s5,a0
    80000562:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    80000564:	03461793          	sll	a5,a2,0x34
    80000568:	ebb1                	bnez	a5,800005bc <mappages+0x78>
    panic("mappages: size not aligned");

  if(size == 0)
    8000056a:	c22d                	beqz	a2,800005cc <mappages+0x88>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    8000056c:	77fd                	lui	a5,0xfffff
    8000056e:	963e                	add	a2,a2,a5
    80000570:	00b609b3          	add	s3,a2,a1
  a = va;
    80000574:	892e                	mv	s2,a1
    80000576:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000057a:	6b85                	lui	s7,0x1
    8000057c:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    80000580:	4605                	li	a2,1
    80000582:	85ca                	mv	a1,s2
    80000584:	8556                	mv	a0,s5
    80000586:	00000097          	auipc	ra,0x0
    8000058a:	ed6080e7          	jalr	-298(ra) # 8000045c <walk>
    8000058e:	cd39                	beqz	a0,800005ec <mappages+0xa8>
    if(*pte & PTE_V)
    80000590:	611c                	ld	a5,0(a0)
    80000592:	8b85                	and	a5,a5,1
    80000594:	e7a1                	bnez	a5,800005dc <mappages+0x98>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000596:	80b1                	srl	s1,s1,0xc
    80000598:	04aa                	sll	s1,s1,0xa
    8000059a:	0164e4b3          	or	s1,s1,s6
    8000059e:	0014e493          	or	s1,s1,1
    800005a2:	e104                	sd	s1,0(a0)
    if(a == last)
    800005a4:	07390063          	beq	s2,s3,80000604 <mappages+0xc0>
    a += PGSIZE;
    800005a8:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800005aa:	bfc9                	j	8000057c <mappages+0x38>
    panic("mappages: va not aligned");
    800005ac:	00008517          	auipc	a0,0x8
    800005b0:	aac50513          	add	a0,a0,-1364 # 80008058 <etext+0x58>
    800005b4:	00005097          	auipc	ra,0x5
    800005b8:	5e2080e7          	jalr	1506(ra) # 80005b96 <panic>
    panic("mappages: size not aligned");
    800005bc:	00008517          	auipc	a0,0x8
    800005c0:	abc50513          	add	a0,a0,-1348 # 80008078 <etext+0x78>
    800005c4:	00005097          	auipc	ra,0x5
    800005c8:	5d2080e7          	jalr	1490(ra) # 80005b96 <panic>
    panic("mappages: size");
    800005cc:	00008517          	auipc	a0,0x8
    800005d0:	acc50513          	add	a0,a0,-1332 # 80008098 <etext+0x98>
    800005d4:	00005097          	auipc	ra,0x5
    800005d8:	5c2080e7          	jalr	1474(ra) # 80005b96 <panic>
      panic("mappages: remap");
    800005dc:	00008517          	auipc	a0,0x8
    800005e0:	acc50513          	add	a0,a0,-1332 # 800080a8 <etext+0xa8>
    800005e4:	00005097          	auipc	ra,0x5
    800005e8:	5b2080e7          	jalr	1458(ra) # 80005b96 <panic>
      return -1;
    800005ec:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800005ee:	60a6                	ld	ra,72(sp)
    800005f0:	6406                	ld	s0,64(sp)
    800005f2:	74e2                	ld	s1,56(sp)
    800005f4:	7942                	ld	s2,48(sp)
    800005f6:	79a2                	ld	s3,40(sp)
    800005f8:	7a02                	ld	s4,32(sp)
    800005fa:	6ae2                	ld	s5,24(sp)
    800005fc:	6b42                	ld	s6,16(sp)
    800005fe:	6ba2                	ld	s7,8(sp)
    80000600:	6161                	add	sp,sp,80
    80000602:	8082                	ret
  return 0;
    80000604:	4501                	li	a0,0
    80000606:	b7e5                	j	800005ee <mappages+0xaa>

0000000080000608 <kvmmap>:
{
    80000608:	1141                	add	sp,sp,-16
    8000060a:	e406                	sd	ra,8(sp)
    8000060c:	e022                	sd	s0,0(sp)
    8000060e:	0800                	add	s0,sp,16
    80000610:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000612:	86b2                	mv	a3,a2
    80000614:	863e                	mv	a2,a5
    80000616:	00000097          	auipc	ra,0x0
    8000061a:	f2e080e7          	jalr	-210(ra) # 80000544 <mappages>
    8000061e:	e509                	bnez	a0,80000628 <kvmmap+0x20>
}
    80000620:	60a2                	ld	ra,8(sp)
    80000622:	6402                	ld	s0,0(sp)
    80000624:	0141                	add	sp,sp,16
    80000626:	8082                	ret
    panic("kvmmap");
    80000628:	00008517          	auipc	a0,0x8
    8000062c:	a9050513          	add	a0,a0,-1392 # 800080b8 <etext+0xb8>
    80000630:	00005097          	auipc	ra,0x5
    80000634:	566080e7          	jalr	1382(ra) # 80005b96 <panic>

0000000080000638 <kvmmake>:
{
    80000638:	1101                	add	sp,sp,-32
    8000063a:	ec06                	sd	ra,24(sp)
    8000063c:	e822                	sd	s0,16(sp)
    8000063e:	e426                	sd	s1,8(sp)
    80000640:	e04a                	sd	s2,0(sp)
    80000642:	1000                	add	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000644:	00000097          	auipc	ra,0x0
    80000648:	ad6080e7          	jalr	-1322(ra) # 8000011a <kalloc>
    8000064c:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000064e:	6605                	lui	a2,0x1
    80000650:	4581                	li	a1,0
    80000652:	00000097          	auipc	ra,0x0
    80000656:	b28080e7          	jalr	-1240(ra) # 8000017a <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000065a:	4719                	li	a4,6
    8000065c:	6685                	lui	a3,0x1
    8000065e:	10000637          	lui	a2,0x10000
    80000662:	100005b7          	lui	a1,0x10000
    80000666:	8526                	mv	a0,s1
    80000668:	00000097          	auipc	ra,0x0
    8000066c:	fa0080e7          	jalr	-96(ra) # 80000608 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000670:	4719                	li	a4,6
    80000672:	6685                	lui	a3,0x1
    80000674:	10001637          	lui	a2,0x10001
    80000678:	100015b7          	lui	a1,0x10001
    8000067c:	8526                	mv	a0,s1
    8000067e:	00000097          	auipc	ra,0x0
    80000682:	f8a080e7          	jalr	-118(ra) # 80000608 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000686:	4719                	li	a4,6
    80000688:	004006b7          	lui	a3,0x400
    8000068c:	0c000637          	lui	a2,0xc000
    80000690:	0c0005b7          	lui	a1,0xc000
    80000694:	8526                	mv	a0,s1
    80000696:	00000097          	auipc	ra,0x0
    8000069a:	f72080e7          	jalr	-142(ra) # 80000608 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000069e:	00008917          	auipc	s2,0x8
    800006a2:	96290913          	add	s2,s2,-1694 # 80008000 <etext>
    800006a6:	4729                	li	a4,10
    800006a8:	80008697          	auipc	a3,0x80008
    800006ac:	95868693          	add	a3,a3,-1704 # 8000 <_entry-0x7fff8000>
    800006b0:	4605                	li	a2,1
    800006b2:	067e                	sll	a2,a2,0x1f
    800006b4:	85b2                	mv	a1,a2
    800006b6:	8526                	mv	a0,s1
    800006b8:	00000097          	auipc	ra,0x0
    800006bc:	f50080e7          	jalr	-176(ra) # 80000608 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006c0:	4719                	li	a4,6
    800006c2:	46c5                	li	a3,17
    800006c4:	06ee                	sll	a3,a3,0x1b
    800006c6:	412686b3          	sub	a3,a3,s2
    800006ca:	864a                	mv	a2,s2
    800006cc:	85ca                	mv	a1,s2
    800006ce:	8526                	mv	a0,s1
    800006d0:	00000097          	auipc	ra,0x0
    800006d4:	f38080e7          	jalr	-200(ra) # 80000608 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006d8:	4729                	li	a4,10
    800006da:	6685                	lui	a3,0x1
    800006dc:	00007617          	auipc	a2,0x7
    800006e0:	92460613          	add	a2,a2,-1756 # 80007000 <_trampoline>
    800006e4:	040005b7          	lui	a1,0x4000
    800006e8:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800006ea:	05b2                	sll	a1,a1,0xc
    800006ec:	8526                	mv	a0,s1
    800006ee:	00000097          	auipc	ra,0x0
    800006f2:	f1a080e7          	jalr	-230(ra) # 80000608 <kvmmap>
  proc_mapstacks(kpgtbl);
    800006f6:	8526                	mv	a0,s1
    800006f8:	00000097          	auipc	ra,0x0
    800006fc:	63c080e7          	jalr	1596(ra) # 80000d34 <proc_mapstacks>
}
    80000700:	8526                	mv	a0,s1
    80000702:	60e2                	ld	ra,24(sp)
    80000704:	6442                	ld	s0,16(sp)
    80000706:	64a2                	ld	s1,8(sp)
    80000708:	6902                	ld	s2,0(sp)
    8000070a:	6105                	add	sp,sp,32
    8000070c:	8082                	ret

000000008000070e <kvminit>:
{
    8000070e:	1141                	add	sp,sp,-16
    80000710:	e406                	sd	ra,8(sp)
    80000712:	e022                	sd	s0,0(sp)
    80000714:	0800                	add	s0,sp,16
  kernel_pagetable = kvmmake();
    80000716:	00000097          	auipc	ra,0x0
    8000071a:	f22080e7          	jalr	-222(ra) # 80000638 <kvmmake>
    8000071e:	00008797          	auipc	a5,0x8
    80000722:	1aa7bd23          	sd	a0,442(a5) # 800088d8 <kernel_pagetable>
}
    80000726:	60a2                	ld	ra,8(sp)
    80000728:	6402                	ld	s0,0(sp)
    8000072a:	0141                	add	sp,sp,16
    8000072c:	8082                	ret

000000008000072e <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000072e:	715d                	add	sp,sp,-80
    80000730:	e486                	sd	ra,72(sp)
    80000732:	e0a2                	sd	s0,64(sp)
    80000734:	fc26                	sd	s1,56(sp)
    80000736:	f84a                	sd	s2,48(sp)
    80000738:	f44e                	sd	s3,40(sp)
    8000073a:	f052                	sd	s4,32(sp)
    8000073c:	ec56                	sd	s5,24(sp)
    8000073e:	e85a                	sd	s6,16(sp)
    80000740:	e45e                	sd	s7,8(sp)
    80000742:	0880                	add	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000744:	03459793          	sll	a5,a1,0x34
    80000748:	e795                	bnez	a5,80000774 <uvmunmap+0x46>
    8000074a:	8a2a                	mv	s4,a0
    8000074c:	892e                	mv	s2,a1
    8000074e:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000750:	0632                	sll	a2,a2,0xc
    80000752:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000756:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000758:	6b05                	lui	s6,0x1
    8000075a:	0735e263          	bltu	a1,s3,800007be <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    8000075e:	60a6                	ld	ra,72(sp)
    80000760:	6406                	ld	s0,64(sp)
    80000762:	74e2                	ld	s1,56(sp)
    80000764:	7942                	ld	s2,48(sp)
    80000766:	79a2                	ld	s3,40(sp)
    80000768:	7a02                	ld	s4,32(sp)
    8000076a:	6ae2                	ld	s5,24(sp)
    8000076c:	6b42                	ld	s6,16(sp)
    8000076e:	6ba2                	ld	s7,8(sp)
    80000770:	6161                	add	sp,sp,80
    80000772:	8082                	ret
    panic("uvmunmap: not aligned");
    80000774:	00008517          	auipc	a0,0x8
    80000778:	94c50513          	add	a0,a0,-1716 # 800080c0 <etext+0xc0>
    8000077c:	00005097          	auipc	ra,0x5
    80000780:	41a080e7          	jalr	1050(ra) # 80005b96 <panic>
      panic("uvmunmap: walk");
    80000784:	00008517          	auipc	a0,0x8
    80000788:	95450513          	add	a0,a0,-1708 # 800080d8 <etext+0xd8>
    8000078c:	00005097          	auipc	ra,0x5
    80000790:	40a080e7          	jalr	1034(ra) # 80005b96 <panic>
      panic("uvmunmap: not mapped");
    80000794:	00008517          	auipc	a0,0x8
    80000798:	95450513          	add	a0,a0,-1708 # 800080e8 <etext+0xe8>
    8000079c:	00005097          	auipc	ra,0x5
    800007a0:	3fa080e7          	jalr	1018(ra) # 80005b96 <panic>
      panic("uvmunmap: not a leaf");
    800007a4:	00008517          	auipc	a0,0x8
    800007a8:	95c50513          	add	a0,a0,-1700 # 80008100 <etext+0x100>
    800007ac:	00005097          	auipc	ra,0x5
    800007b0:	3ea080e7          	jalr	1002(ra) # 80005b96 <panic>
    *pte = 0;
    800007b4:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007b8:	995a                	add	s2,s2,s6
    800007ba:	fb3972e3          	bgeu	s2,s3,8000075e <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007be:	4601                	li	a2,0
    800007c0:	85ca                	mv	a1,s2
    800007c2:	8552                	mv	a0,s4
    800007c4:	00000097          	auipc	ra,0x0
    800007c8:	c98080e7          	jalr	-872(ra) # 8000045c <walk>
    800007cc:	84aa                	mv	s1,a0
    800007ce:	d95d                	beqz	a0,80000784 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007d0:	6108                	ld	a0,0(a0)
    800007d2:	00157793          	and	a5,a0,1
    800007d6:	dfdd                	beqz	a5,80000794 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007d8:	3ff57793          	and	a5,a0,1023
    800007dc:	fd7784e3          	beq	a5,s7,800007a4 <uvmunmap+0x76>
    if(do_free){
    800007e0:	fc0a8ae3          	beqz	s5,800007b4 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    800007e4:	8129                	srl	a0,a0,0xa
      kfree((void*)pa);
    800007e6:	0532                	sll	a0,a0,0xc
    800007e8:	00000097          	auipc	ra,0x0
    800007ec:	834080e7          	jalr	-1996(ra) # 8000001c <kfree>
    800007f0:	b7d1                	j	800007b4 <uvmunmap+0x86>

00000000800007f2 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007f2:	1101                	add	sp,sp,-32
    800007f4:	ec06                	sd	ra,24(sp)
    800007f6:	e822                	sd	s0,16(sp)
    800007f8:	e426                	sd	s1,8(sp)
    800007fa:	1000                	add	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007fc:	00000097          	auipc	ra,0x0
    80000800:	91e080e7          	jalr	-1762(ra) # 8000011a <kalloc>
    80000804:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000806:	c519                	beqz	a0,80000814 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000808:	6605                	lui	a2,0x1
    8000080a:	4581                	li	a1,0
    8000080c:	00000097          	auipc	ra,0x0
    80000810:	96e080e7          	jalr	-1682(ra) # 8000017a <memset>
  return pagetable;
}
    80000814:	8526                	mv	a0,s1
    80000816:	60e2                	ld	ra,24(sp)
    80000818:	6442                	ld	s0,16(sp)
    8000081a:	64a2                	ld	s1,8(sp)
    8000081c:	6105                	add	sp,sp,32
    8000081e:	8082                	ret

0000000080000820 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80000820:	7179                	add	sp,sp,-48
    80000822:	f406                	sd	ra,40(sp)
    80000824:	f022                	sd	s0,32(sp)
    80000826:	ec26                	sd	s1,24(sp)
    80000828:	e84a                	sd	s2,16(sp)
    8000082a:	e44e                	sd	s3,8(sp)
    8000082c:	e052                	sd	s4,0(sp)
    8000082e:	1800                	add	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000830:	6785                	lui	a5,0x1
    80000832:	04f67863          	bgeu	a2,a5,80000882 <uvmfirst+0x62>
    80000836:	8a2a                	mv	s4,a0
    80000838:	89ae                	mv	s3,a1
    8000083a:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    8000083c:	00000097          	auipc	ra,0x0
    80000840:	8de080e7          	jalr	-1826(ra) # 8000011a <kalloc>
    80000844:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000846:	6605                	lui	a2,0x1
    80000848:	4581                	li	a1,0
    8000084a:	00000097          	auipc	ra,0x0
    8000084e:	930080e7          	jalr	-1744(ra) # 8000017a <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000852:	4779                	li	a4,30
    80000854:	86ca                	mv	a3,s2
    80000856:	6605                	lui	a2,0x1
    80000858:	4581                	li	a1,0
    8000085a:	8552                	mv	a0,s4
    8000085c:	00000097          	auipc	ra,0x0
    80000860:	ce8080e7          	jalr	-792(ra) # 80000544 <mappages>
  memmove(mem, src, sz);
    80000864:	8626                	mv	a2,s1
    80000866:	85ce                	mv	a1,s3
    80000868:	854a                	mv	a0,s2
    8000086a:	00000097          	auipc	ra,0x0
    8000086e:	96c080e7          	jalr	-1684(ra) # 800001d6 <memmove>
}
    80000872:	70a2                	ld	ra,40(sp)
    80000874:	7402                	ld	s0,32(sp)
    80000876:	64e2                	ld	s1,24(sp)
    80000878:	6942                	ld	s2,16(sp)
    8000087a:	69a2                	ld	s3,8(sp)
    8000087c:	6a02                	ld	s4,0(sp)
    8000087e:	6145                	add	sp,sp,48
    80000880:	8082                	ret
    panic("uvmfirst: more than a page");
    80000882:	00008517          	auipc	a0,0x8
    80000886:	89650513          	add	a0,a0,-1898 # 80008118 <etext+0x118>
    8000088a:	00005097          	auipc	ra,0x5
    8000088e:	30c080e7          	jalr	780(ra) # 80005b96 <panic>

0000000080000892 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000892:	1101                	add	sp,sp,-32
    80000894:	ec06                	sd	ra,24(sp)
    80000896:	e822                	sd	s0,16(sp)
    80000898:	e426                	sd	s1,8(sp)
    8000089a:	1000                	add	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000089c:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000089e:	00b67d63          	bgeu	a2,a1,800008b8 <uvmdealloc+0x26>
    800008a2:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800008a4:	6785                	lui	a5,0x1
    800008a6:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008a8:	00f60733          	add	a4,a2,a5
    800008ac:	76fd                	lui	a3,0xfffff
    800008ae:	8f75                	and	a4,a4,a3
    800008b0:	97ae                	add	a5,a5,a1
    800008b2:	8ff5                	and	a5,a5,a3
    800008b4:	00f76863          	bltu	a4,a5,800008c4 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800008b8:	8526                	mv	a0,s1
    800008ba:	60e2                	ld	ra,24(sp)
    800008bc:	6442                	ld	s0,16(sp)
    800008be:	64a2                	ld	s1,8(sp)
    800008c0:	6105                	add	sp,sp,32
    800008c2:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008c4:	8f99                	sub	a5,a5,a4
    800008c6:	83b1                	srl	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008c8:	4685                	li	a3,1
    800008ca:	0007861b          	sext.w	a2,a5
    800008ce:	85ba                	mv	a1,a4
    800008d0:	00000097          	auipc	ra,0x0
    800008d4:	e5e080e7          	jalr	-418(ra) # 8000072e <uvmunmap>
    800008d8:	b7c5                	j	800008b8 <uvmdealloc+0x26>

00000000800008da <uvmalloc>:
  if(newsz < oldsz)
    800008da:	0ab66563          	bltu	a2,a1,80000984 <uvmalloc+0xaa>
{
    800008de:	7139                	add	sp,sp,-64
    800008e0:	fc06                	sd	ra,56(sp)
    800008e2:	f822                	sd	s0,48(sp)
    800008e4:	f426                	sd	s1,40(sp)
    800008e6:	f04a                	sd	s2,32(sp)
    800008e8:	ec4e                	sd	s3,24(sp)
    800008ea:	e852                	sd	s4,16(sp)
    800008ec:	e456                	sd	s5,8(sp)
    800008ee:	e05a                	sd	s6,0(sp)
    800008f0:	0080                	add	s0,sp,64
    800008f2:	8aaa                	mv	s5,a0
    800008f4:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008f6:	6785                	lui	a5,0x1
    800008f8:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008fa:	95be                	add	a1,a1,a5
    800008fc:	77fd                	lui	a5,0xfffff
    800008fe:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000902:	08c9f363          	bgeu	s3,a2,80000988 <uvmalloc+0xae>
    80000906:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000908:	0126eb13          	or	s6,a3,18
    mem = kalloc();
    8000090c:	00000097          	auipc	ra,0x0
    80000910:	80e080e7          	jalr	-2034(ra) # 8000011a <kalloc>
    80000914:	84aa                	mv	s1,a0
    if(mem == 0){
    80000916:	c51d                	beqz	a0,80000944 <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    80000918:	6605                	lui	a2,0x1
    8000091a:	4581                	li	a1,0
    8000091c:	00000097          	auipc	ra,0x0
    80000920:	85e080e7          	jalr	-1954(ra) # 8000017a <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000924:	875a                	mv	a4,s6
    80000926:	86a6                	mv	a3,s1
    80000928:	6605                	lui	a2,0x1
    8000092a:	85ca                	mv	a1,s2
    8000092c:	8556                	mv	a0,s5
    8000092e:	00000097          	auipc	ra,0x0
    80000932:	c16080e7          	jalr	-1002(ra) # 80000544 <mappages>
    80000936:	e90d                	bnez	a0,80000968 <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000938:	6785                	lui	a5,0x1
    8000093a:	993e                	add	s2,s2,a5
    8000093c:	fd4968e3          	bltu	s2,s4,8000090c <uvmalloc+0x32>
  return newsz;
    80000940:	8552                	mv	a0,s4
    80000942:	a809                	j	80000954 <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    80000944:	864e                	mv	a2,s3
    80000946:	85ca                	mv	a1,s2
    80000948:	8556                	mv	a0,s5
    8000094a:	00000097          	auipc	ra,0x0
    8000094e:	f48080e7          	jalr	-184(ra) # 80000892 <uvmdealloc>
      return 0;
    80000952:	4501                	li	a0,0
}
    80000954:	70e2                	ld	ra,56(sp)
    80000956:	7442                	ld	s0,48(sp)
    80000958:	74a2                	ld	s1,40(sp)
    8000095a:	7902                	ld	s2,32(sp)
    8000095c:	69e2                	ld	s3,24(sp)
    8000095e:	6a42                	ld	s4,16(sp)
    80000960:	6aa2                	ld	s5,8(sp)
    80000962:	6b02                	ld	s6,0(sp)
    80000964:	6121                	add	sp,sp,64
    80000966:	8082                	ret
      kfree(mem);
    80000968:	8526                	mv	a0,s1
    8000096a:	fffff097          	auipc	ra,0xfffff
    8000096e:	6b2080e7          	jalr	1714(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000972:	864e                	mv	a2,s3
    80000974:	85ca                	mv	a1,s2
    80000976:	8556                	mv	a0,s5
    80000978:	00000097          	auipc	ra,0x0
    8000097c:	f1a080e7          	jalr	-230(ra) # 80000892 <uvmdealloc>
      return 0;
    80000980:	4501                	li	a0,0
    80000982:	bfc9                	j	80000954 <uvmalloc+0x7a>
    return oldsz;
    80000984:	852e                	mv	a0,a1
}
    80000986:	8082                	ret
  return newsz;
    80000988:	8532                	mv	a0,a2
    8000098a:	b7e9                	j	80000954 <uvmalloc+0x7a>

000000008000098c <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000098c:	7179                	add	sp,sp,-48
    8000098e:	f406                	sd	ra,40(sp)
    80000990:	f022                	sd	s0,32(sp)
    80000992:	ec26                	sd	s1,24(sp)
    80000994:	e84a                	sd	s2,16(sp)
    80000996:	e44e                	sd	s3,8(sp)
    80000998:	e052                	sd	s4,0(sp)
    8000099a:	1800                	add	s0,sp,48
    8000099c:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    8000099e:	84aa                	mv	s1,a0
    800009a0:	6905                	lui	s2,0x1
    800009a2:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009a4:	4985                	li	s3,1
    800009a6:	a829                	j	800009c0 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800009a8:	83a9                	srl	a5,a5,0xa
      freewalk((pagetable_t)child);
    800009aa:	00c79513          	sll	a0,a5,0xc
    800009ae:	00000097          	auipc	ra,0x0
    800009b2:	fde080e7          	jalr	-34(ra) # 8000098c <freewalk>
      pagetable[i] = 0;
    800009b6:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800009ba:	04a1                	add	s1,s1,8
    800009bc:	03248163          	beq	s1,s2,800009de <freewalk+0x52>
    pte_t pte = pagetable[i];
    800009c0:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009c2:	00f7f713          	and	a4,a5,15
    800009c6:	ff3701e3          	beq	a4,s3,800009a8 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009ca:	8b85                	and	a5,a5,1
    800009cc:	d7fd                	beqz	a5,800009ba <freewalk+0x2e>
      panic("freewalk: leaf");
    800009ce:	00007517          	auipc	a0,0x7
    800009d2:	76a50513          	add	a0,a0,1898 # 80008138 <etext+0x138>
    800009d6:	00005097          	auipc	ra,0x5
    800009da:	1c0080e7          	jalr	448(ra) # 80005b96 <panic>
    }
  }
  kfree((void*)pagetable);
    800009de:	8552                	mv	a0,s4
    800009e0:	fffff097          	auipc	ra,0xfffff
    800009e4:	63c080e7          	jalr	1596(ra) # 8000001c <kfree>
}
    800009e8:	70a2                	ld	ra,40(sp)
    800009ea:	7402                	ld	s0,32(sp)
    800009ec:	64e2                	ld	s1,24(sp)
    800009ee:	6942                	ld	s2,16(sp)
    800009f0:	69a2                	ld	s3,8(sp)
    800009f2:	6a02                	ld	s4,0(sp)
    800009f4:	6145                	add	sp,sp,48
    800009f6:	8082                	ret

00000000800009f8 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009f8:	1101                	add	sp,sp,-32
    800009fa:	ec06                	sd	ra,24(sp)
    800009fc:	e822                	sd	s0,16(sp)
    800009fe:	e426                	sd	s1,8(sp)
    80000a00:	1000                	add	s0,sp,32
    80000a02:	84aa                	mv	s1,a0
  if(sz > 0)
    80000a04:	e999                	bnez	a1,80000a1a <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000a06:	8526                	mv	a0,s1
    80000a08:	00000097          	auipc	ra,0x0
    80000a0c:	f84080e7          	jalr	-124(ra) # 8000098c <freewalk>
}
    80000a10:	60e2                	ld	ra,24(sp)
    80000a12:	6442                	ld	s0,16(sp)
    80000a14:	64a2                	ld	s1,8(sp)
    80000a16:	6105                	add	sp,sp,32
    80000a18:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000a1a:	6785                	lui	a5,0x1
    80000a1c:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000a1e:	95be                	add	a1,a1,a5
    80000a20:	4685                	li	a3,1
    80000a22:	00c5d613          	srl	a2,a1,0xc
    80000a26:	4581                	li	a1,0
    80000a28:	00000097          	auipc	ra,0x0
    80000a2c:	d06080e7          	jalr	-762(ra) # 8000072e <uvmunmap>
    80000a30:	bfd9                	j	80000a06 <uvmfree+0xe>

0000000080000a32 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a32:	c679                	beqz	a2,80000b00 <uvmcopy+0xce>
{
    80000a34:	715d                	add	sp,sp,-80
    80000a36:	e486                	sd	ra,72(sp)
    80000a38:	e0a2                	sd	s0,64(sp)
    80000a3a:	fc26                	sd	s1,56(sp)
    80000a3c:	f84a                	sd	s2,48(sp)
    80000a3e:	f44e                	sd	s3,40(sp)
    80000a40:	f052                	sd	s4,32(sp)
    80000a42:	ec56                	sd	s5,24(sp)
    80000a44:	e85a                	sd	s6,16(sp)
    80000a46:	e45e                	sd	s7,8(sp)
    80000a48:	0880                	add	s0,sp,80
    80000a4a:	8b2a                	mv	s6,a0
    80000a4c:	8aae                	mv	s5,a1
    80000a4e:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a50:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a52:	4601                	li	a2,0
    80000a54:	85ce                	mv	a1,s3
    80000a56:	855a                	mv	a0,s6
    80000a58:	00000097          	auipc	ra,0x0
    80000a5c:	a04080e7          	jalr	-1532(ra) # 8000045c <walk>
    80000a60:	c531                	beqz	a0,80000aac <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a62:	6118                	ld	a4,0(a0)
    80000a64:	00177793          	and	a5,a4,1
    80000a68:	cbb1                	beqz	a5,80000abc <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a6a:	00a75593          	srl	a1,a4,0xa
    80000a6e:	00c59b93          	sll	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a72:	3ff77493          	and	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a76:	fffff097          	auipc	ra,0xfffff
    80000a7a:	6a4080e7          	jalr	1700(ra) # 8000011a <kalloc>
    80000a7e:	892a                	mv	s2,a0
    80000a80:	c939                	beqz	a0,80000ad6 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a82:	6605                	lui	a2,0x1
    80000a84:	85de                	mv	a1,s7
    80000a86:	fffff097          	auipc	ra,0xfffff
    80000a8a:	750080e7          	jalr	1872(ra) # 800001d6 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a8e:	8726                	mv	a4,s1
    80000a90:	86ca                	mv	a3,s2
    80000a92:	6605                	lui	a2,0x1
    80000a94:	85ce                	mv	a1,s3
    80000a96:	8556                	mv	a0,s5
    80000a98:	00000097          	auipc	ra,0x0
    80000a9c:	aac080e7          	jalr	-1364(ra) # 80000544 <mappages>
    80000aa0:	e515                	bnez	a0,80000acc <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000aa2:	6785                	lui	a5,0x1
    80000aa4:	99be                	add	s3,s3,a5
    80000aa6:	fb49e6e3          	bltu	s3,s4,80000a52 <uvmcopy+0x20>
    80000aaa:	a081                	j	80000aea <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000aac:	00007517          	auipc	a0,0x7
    80000ab0:	69c50513          	add	a0,a0,1692 # 80008148 <etext+0x148>
    80000ab4:	00005097          	auipc	ra,0x5
    80000ab8:	0e2080e7          	jalr	226(ra) # 80005b96 <panic>
      panic("uvmcopy: page not present");
    80000abc:	00007517          	auipc	a0,0x7
    80000ac0:	6ac50513          	add	a0,a0,1708 # 80008168 <etext+0x168>
    80000ac4:	00005097          	auipc	ra,0x5
    80000ac8:	0d2080e7          	jalr	210(ra) # 80005b96 <panic>
      kfree(mem);
    80000acc:	854a                	mv	a0,s2
    80000ace:	fffff097          	auipc	ra,0xfffff
    80000ad2:	54e080e7          	jalr	1358(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000ad6:	4685                	li	a3,1
    80000ad8:	00c9d613          	srl	a2,s3,0xc
    80000adc:	4581                	li	a1,0
    80000ade:	8556                	mv	a0,s5
    80000ae0:	00000097          	auipc	ra,0x0
    80000ae4:	c4e080e7          	jalr	-946(ra) # 8000072e <uvmunmap>
  return -1;
    80000ae8:	557d                	li	a0,-1
}
    80000aea:	60a6                	ld	ra,72(sp)
    80000aec:	6406                	ld	s0,64(sp)
    80000aee:	74e2                	ld	s1,56(sp)
    80000af0:	7942                	ld	s2,48(sp)
    80000af2:	79a2                	ld	s3,40(sp)
    80000af4:	7a02                	ld	s4,32(sp)
    80000af6:	6ae2                	ld	s5,24(sp)
    80000af8:	6b42                	ld	s6,16(sp)
    80000afa:	6ba2                	ld	s7,8(sp)
    80000afc:	6161                	add	sp,sp,80
    80000afe:	8082                	ret
  return 0;
    80000b00:	4501                	li	a0,0
}
    80000b02:	8082                	ret

0000000080000b04 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000b04:	1141                	add	sp,sp,-16
    80000b06:	e406                	sd	ra,8(sp)
    80000b08:	e022                	sd	s0,0(sp)
    80000b0a:	0800                	add	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000b0c:	4601                	li	a2,0
    80000b0e:	00000097          	auipc	ra,0x0
    80000b12:	94e080e7          	jalr	-1714(ra) # 8000045c <walk>
  if(pte == 0)
    80000b16:	c901                	beqz	a0,80000b26 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000b18:	611c                	ld	a5,0(a0)
    80000b1a:	9bbd                	and	a5,a5,-17
    80000b1c:	e11c                	sd	a5,0(a0)
}
    80000b1e:	60a2                	ld	ra,8(sp)
    80000b20:	6402                	ld	s0,0(sp)
    80000b22:	0141                	add	sp,sp,16
    80000b24:	8082                	ret
    panic("uvmclear");
    80000b26:	00007517          	auipc	a0,0x7
    80000b2a:	66250513          	add	a0,a0,1634 # 80008188 <etext+0x188>
    80000b2e:	00005097          	auipc	ra,0x5
    80000b32:	068080e7          	jalr	104(ra) # 80005b96 <panic>

0000000080000b36 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    80000b36:	cac9                	beqz	a3,80000bc8 <copyout+0x92>
{
    80000b38:	711d                	add	sp,sp,-96
    80000b3a:	ec86                	sd	ra,88(sp)
    80000b3c:	e8a2                	sd	s0,80(sp)
    80000b3e:	e4a6                	sd	s1,72(sp)
    80000b40:	e0ca                	sd	s2,64(sp)
    80000b42:	fc4e                	sd	s3,56(sp)
    80000b44:	f852                	sd	s4,48(sp)
    80000b46:	f456                	sd	s5,40(sp)
    80000b48:	f05a                	sd	s6,32(sp)
    80000b4a:	ec5e                	sd	s7,24(sp)
    80000b4c:	e862                	sd	s8,16(sp)
    80000b4e:	e466                	sd	s9,8(sp)
    80000b50:	e06a                	sd	s10,0(sp)
    80000b52:	1080                	add	s0,sp,96
    80000b54:	8baa                	mv	s7,a0
    80000b56:	8aae                	mv	s5,a1
    80000b58:	8b32                	mv	s6,a2
    80000b5a:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b5c:	74fd                	lui	s1,0xfffff
    80000b5e:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    80000b60:	57fd                	li	a5,-1
    80000b62:	83e9                	srl	a5,a5,0x1a
    80000b64:	0697e463          	bltu	a5,s1,80000bcc <copyout+0x96>
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000b68:	4cd5                	li	s9,21
    80000b6a:	6d05                	lui	s10,0x1
    if(va0 >= MAXVA)
    80000b6c:	8c3e                	mv	s8,a5
    80000b6e:	a035                	j	80000b9a <copyout+0x64>
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    80000b70:	83a9                	srl	a5,a5,0xa
    80000b72:	07b2                	sll	a5,a5,0xc
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b74:	409a8533          	sub	a0,s5,s1
    80000b78:	0009061b          	sext.w	a2,s2
    80000b7c:	85da                	mv	a1,s6
    80000b7e:	953e                	add	a0,a0,a5
    80000b80:	fffff097          	auipc	ra,0xfffff
    80000b84:	656080e7          	jalr	1622(ra) # 800001d6 <memmove>

    len -= n;
    80000b88:	412989b3          	sub	s3,s3,s2
    src += n;
    80000b8c:	9b4a                	add	s6,s6,s2
  while(len > 0){
    80000b8e:	02098b63          	beqz	s3,80000bc4 <copyout+0x8e>
    if(va0 >= MAXVA)
    80000b92:	034c6f63          	bltu	s8,s4,80000bd0 <copyout+0x9a>
    va0 = PGROUNDDOWN(dstva);
    80000b96:	84d2                	mv	s1,s4
    dstva = va0 + PGSIZE;
    80000b98:	8ad2                	mv	s5,s4
    pte = walk(pagetable, va0, 0);
    80000b9a:	4601                	li	a2,0
    80000b9c:	85a6                	mv	a1,s1
    80000b9e:	855e                	mv	a0,s7
    80000ba0:	00000097          	auipc	ra,0x0
    80000ba4:	8bc080e7          	jalr	-1860(ra) # 8000045c <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000ba8:	c515                	beqz	a0,80000bd4 <copyout+0x9e>
    80000baa:	611c                	ld	a5,0(a0)
    80000bac:	0157f713          	and	a4,a5,21
    80000bb0:	05971163          	bne	a4,s9,80000bf2 <copyout+0xbc>
    n = PGSIZE - (dstva - va0);
    80000bb4:	01a48a33          	add	s4,s1,s10
    80000bb8:	415a0933          	sub	s2,s4,s5
    80000bbc:	fb29fae3          	bgeu	s3,s2,80000b70 <copyout+0x3a>
    80000bc0:	894e                	mv	s2,s3
    80000bc2:	b77d                	j	80000b70 <copyout+0x3a>
  }
  return 0;
    80000bc4:	4501                	li	a0,0
    80000bc6:	a801                	j	80000bd6 <copyout+0xa0>
    80000bc8:	4501                	li	a0,0
}
    80000bca:	8082                	ret
      return -1;
    80000bcc:	557d                	li	a0,-1
    80000bce:	a021                	j	80000bd6 <copyout+0xa0>
    80000bd0:	557d                	li	a0,-1
    80000bd2:	a011                	j	80000bd6 <copyout+0xa0>
      return -1;
    80000bd4:	557d                	li	a0,-1
}
    80000bd6:	60e6                	ld	ra,88(sp)
    80000bd8:	6446                	ld	s0,80(sp)
    80000bda:	64a6                	ld	s1,72(sp)
    80000bdc:	6906                	ld	s2,64(sp)
    80000bde:	79e2                	ld	s3,56(sp)
    80000be0:	7a42                	ld	s4,48(sp)
    80000be2:	7aa2                	ld	s5,40(sp)
    80000be4:	7b02                	ld	s6,32(sp)
    80000be6:	6be2                	ld	s7,24(sp)
    80000be8:	6c42                	ld	s8,16(sp)
    80000bea:	6ca2                	ld	s9,8(sp)
    80000bec:	6d02                	ld	s10,0(sp)
    80000bee:	6125                	add	sp,sp,96
    80000bf0:	8082                	ret
      return -1;
    80000bf2:	557d                	li	a0,-1
    80000bf4:	b7cd                	j	80000bd6 <copyout+0xa0>

0000000080000bf6 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000bf6:	caa5                	beqz	a3,80000c66 <copyin+0x70>
{
    80000bf8:	715d                	add	sp,sp,-80
    80000bfa:	e486                	sd	ra,72(sp)
    80000bfc:	e0a2                	sd	s0,64(sp)
    80000bfe:	fc26                	sd	s1,56(sp)
    80000c00:	f84a                	sd	s2,48(sp)
    80000c02:	f44e                	sd	s3,40(sp)
    80000c04:	f052                	sd	s4,32(sp)
    80000c06:	ec56                	sd	s5,24(sp)
    80000c08:	e85a                	sd	s6,16(sp)
    80000c0a:	e45e                	sd	s7,8(sp)
    80000c0c:	e062                	sd	s8,0(sp)
    80000c0e:	0880                	add	s0,sp,80
    80000c10:	8b2a                	mv	s6,a0
    80000c12:	8a2e                	mv	s4,a1
    80000c14:	8c32                	mv	s8,a2
    80000c16:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000c18:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c1a:	6a85                	lui	s5,0x1
    80000c1c:	a01d                	j	80000c42 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000c1e:	018505b3          	add	a1,a0,s8
    80000c22:	0004861b          	sext.w	a2,s1
    80000c26:	412585b3          	sub	a1,a1,s2
    80000c2a:	8552                	mv	a0,s4
    80000c2c:	fffff097          	auipc	ra,0xfffff
    80000c30:	5aa080e7          	jalr	1450(ra) # 800001d6 <memmove>

    len -= n;
    80000c34:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000c38:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000c3a:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c3e:	02098263          	beqz	s3,80000c62 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000c42:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c46:	85ca                	mv	a1,s2
    80000c48:	855a                	mv	a0,s6
    80000c4a:	00000097          	auipc	ra,0x0
    80000c4e:	8b8080e7          	jalr	-1864(ra) # 80000502 <walkaddr>
    if(pa0 == 0)
    80000c52:	cd01                	beqz	a0,80000c6a <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000c54:	418904b3          	sub	s1,s2,s8
    80000c58:	94d6                	add	s1,s1,s5
    80000c5a:	fc99f2e3          	bgeu	s3,s1,80000c1e <copyin+0x28>
    80000c5e:	84ce                	mv	s1,s3
    80000c60:	bf7d                	j	80000c1e <copyin+0x28>
  }
  return 0;
    80000c62:	4501                	li	a0,0
    80000c64:	a021                	j	80000c6c <copyin+0x76>
    80000c66:	4501                	li	a0,0
}
    80000c68:	8082                	ret
      return -1;
    80000c6a:	557d                	li	a0,-1
}
    80000c6c:	60a6                	ld	ra,72(sp)
    80000c6e:	6406                	ld	s0,64(sp)
    80000c70:	74e2                	ld	s1,56(sp)
    80000c72:	7942                	ld	s2,48(sp)
    80000c74:	79a2                	ld	s3,40(sp)
    80000c76:	7a02                	ld	s4,32(sp)
    80000c78:	6ae2                	ld	s5,24(sp)
    80000c7a:	6b42                	ld	s6,16(sp)
    80000c7c:	6ba2                	ld	s7,8(sp)
    80000c7e:	6c02                	ld	s8,0(sp)
    80000c80:	6161                	add	sp,sp,80
    80000c82:	8082                	ret

0000000080000c84 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c84:	c2dd                	beqz	a3,80000d2a <copyinstr+0xa6>
{
    80000c86:	715d                	add	sp,sp,-80
    80000c88:	e486                	sd	ra,72(sp)
    80000c8a:	e0a2                	sd	s0,64(sp)
    80000c8c:	fc26                	sd	s1,56(sp)
    80000c8e:	f84a                	sd	s2,48(sp)
    80000c90:	f44e                	sd	s3,40(sp)
    80000c92:	f052                	sd	s4,32(sp)
    80000c94:	ec56                	sd	s5,24(sp)
    80000c96:	e85a                	sd	s6,16(sp)
    80000c98:	e45e                	sd	s7,8(sp)
    80000c9a:	0880                	add	s0,sp,80
    80000c9c:	8a2a                	mv	s4,a0
    80000c9e:	8b2e                	mv	s6,a1
    80000ca0:	8bb2                	mv	s7,a2
    80000ca2:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000ca4:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000ca6:	6985                	lui	s3,0x1
    80000ca8:	a02d                	j	80000cd2 <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000caa:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000cae:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000cb0:	37fd                	addw	a5,a5,-1
    80000cb2:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000cb6:	60a6                	ld	ra,72(sp)
    80000cb8:	6406                	ld	s0,64(sp)
    80000cba:	74e2                	ld	s1,56(sp)
    80000cbc:	7942                	ld	s2,48(sp)
    80000cbe:	79a2                	ld	s3,40(sp)
    80000cc0:	7a02                	ld	s4,32(sp)
    80000cc2:	6ae2                	ld	s5,24(sp)
    80000cc4:	6b42                	ld	s6,16(sp)
    80000cc6:	6ba2                	ld	s7,8(sp)
    80000cc8:	6161                	add	sp,sp,80
    80000cca:	8082                	ret
    srcva = va0 + PGSIZE;
    80000ccc:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000cd0:	c8a9                	beqz	s1,80000d22 <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    80000cd2:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000cd6:	85ca                	mv	a1,s2
    80000cd8:	8552                	mv	a0,s4
    80000cda:	00000097          	auipc	ra,0x0
    80000cde:	828080e7          	jalr	-2008(ra) # 80000502 <walkaddr>
    if(pa0 == 0)
    80000ce2:	c131                	beqz	a0,80000d26 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000ce4:	417906b3          	sub	a3,s2,s7
    80000ce8:	96ce                	add	a3,a3,s3
    80000cea:	00d4f363          	bgeu	s1,a3,80000cf0 <copyinstr+0x6c>
    80000cee:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000cf0:	955e                	add	a0,a0,s7
    80000cf2:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000cf6:	daf9                	beqz	a3,80000ccc <copyinstr+0x48>
    80000cf8:	87da                	mv	a5,s6
    80000cfa:	885a                	mv	a6,s6
      if(*p == '\0'){
    80000cfc:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80000d00:	96da                	add	a3,a3,s6
    80000d02:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000d04:	00f60733          	add	a4,a2,a5
    80000d08:	00074703          	lbu	a4,0(a4)
    80000d0c:	df59                	beqz	a4,80000caa <copyinstr+0x26>
        *dst = *p;
    80000d0e:	00e78023          	sb	a4,0(a5)
      dst++;
    80000d12:	0785                	add	a5,a5,1
    while(n > 0){
    80000d14:	fed797e3          	bne	a5,a3,80000d02 <copyinstr+0x7e>
    80000d18:	14fd                	add	s1,s1,-1 # ffffffffffffefff <end+0xffffffff7ffdd28f>
    80000d1a:	94c2                	add	s1,s1,a6
      --max;
    80000d1c:	8c8d                	sub	s1,s1,a1
      dst++;
    80000d1e:	8b3e                	mv	s6,a5
    80000d20:	b775                	j	80000ccc <copyinstr+0x48>
    80000d22:	4781                	li	a5,0
    80000d24:	b771                	j	80000cb0 <copyinstr+0x2c>
      return -1;
    80000d26:	557d                	li	a0,-1
    80000d28:	b779                	j	80000cb6 <copyinstr+0x32>
  int got_null = 0;
    80000d2a:	4781                	li	a5,0
  if(got_null){
    80000d2c:	37fd                	addw	a5,a5,-1
    80000d2e:	0007851b          	sext.w	a0,a5
}
    80000d32:	8082                	ret

0000000080000d34 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000d34:	7139                	add	sp,sp,-64
    80000d36:	fc06                	sd	ra,56(sp)
    80000d38:	f822                	sd	s0,48(sp)
    80000d3a:	f426                	sd	s1,40(sp)
    80000d3c:	f04a                	sd	s2,32(sp)
    80000d3e:	ec4e                	sd	s3,24(sp)
    80000d40:	e852                	sd	s4,16(sp)
    80000d42:	e456                	sd	s5,8(sp)
    80000d44:	e05a                	sd	s6,0(sp)
    80000d46:	0080                	add	s0,sp,64
    80000d48:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d4a:	00008497          	auipc	s1,0x8
    80000d4e:	00648493          	add	s1,s1,6 # 80008d50 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000d52:	8b26                	mv	s6,s1
    80000d54:	00007a97          	auipc	s5,0x7
    80000d58:	2aca8a93          	add	s5,s5,684 # 80008000 <etext>
    80000d5c:	04000937          	lui	s2,0x4000
    80000d60:	197d                	add	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000d62:	0932                	sll	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d64:	0000ea17          	auipc	s4,0xe
    80000d68:	9eca0a13          	add	s4,s4,-1556 # 8000e750 <tickslock>
    char *pa = kalloc();
    80000d6c:	fffff097          	auipc	ra,0xfffff
    80000d70:	3ae080e7          	jalr	942(ra) # 8000011a <kalloc>
    80000d74:	862a                	mv	a2,a0
    if(pa == 0)
    80000d76:	c131                	beqz	a0,80000dba <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d78:	416485b3          	sub	a1,s1,s6
    80000d7c:	858d                	sra	a1,a1,0x3
    80000d7e:	000ab783          	ld	a5,0(s5)
    80000d82:	02f585b3          	mul	a1,a1,a5
    80000d86:	2585                	addw	a1,a1,1
    80000d88:	00d5959b          	sllw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d8c:	4719                	li	a4,6
    80000d8e:	6685                	lui	a3,0x1
    80000d90:	40b905b3          	sub	a1,s2,a1
    80000d94:	854e                	mv	a0,s3
    80000d96:	00000097          	auipc	ra,0x0
    80000d9a:	872080e7          	jalr	-1934(ra) # 80000608 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d9e:	16848493          	add	s1,s1,360
    80000da2:	fd4495e3          	bne	s1,s4,80000d6c <proc_mapstacks+0x38>
  }
}
    80000da6:	70e2                	ld	ra,56(sp)
    80000da8:	7442                	ld	s0,48(sp)
    80000daa:	74a2                	ld	s1,40(sp)
    80000dac:	7902                	ld	s2,32(sp)
    80000dae:	69e2                	ld	s3,24(sp)
    80000db0:	6a42                	ld	s4,16(sp)
    80000db2:	6aa2                	ld	s5,8(sp)
    80000db4:	6b02                	ld	s6,0(sp)
    80000db6:	6121                	add	sp,sp,64
    80000db8:	8082                	ret
      panic("kalloc");
    80000dba:	00007517          	auipc	a0,0x7
    80000dbe:	3de50513          	add	a0,a0,990 # 80008198 <etext+0x198>
    80000dc2:	00005097          	auipc	ra,0x5
    80000dc6:	dd4080e7          	jalr	-556(ra) # 80005b96 <panic>

0000000080000dca <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000dca:	7139                	add	sp,sp,-64
    80000dcc:	fc06                	sd	ra,56(sp)
    80000dce:	f822                	sd	s0,48(sp)
    80000dd0:	f426                	sd	s1,40(sp)
    80000dd2:	f04a                	sd	s2,32(sp)
    80000dd4:	ec4e                	sd	s3,24(sp)
    80000dd6:	e852                	sd	s4,16(sp)
    80000dd8:	e456                	sd	s5,8(sp)
    80000dda:	e05a                	sd	s6,0(sp)
    80000ddc:	0080                	add	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000dde:	00007597          	auipc	a1,0x7
    80000de2:	3c258593          	add	a1,a1,962 # 800081a0 <etext+0x1a0>
    80000de6:	00008517          	auipc	a0,0x8
    80000dea:	b3a50513          	add	a0,a0,-1222 # 80008920 <pid_lock>
    80000dee:	00005097          	auipc	ra,0x5
    80000df2:	250080e7          	jalr	592(ra) # 8000603e <initlock>
  initlock(&wait_lock, "wait_lock");
    80000df6:	00007597          	auipc	a1,0x7
    80000dfa:	3b258593          	add	a1,a1,946 # 800081a8 <etext+0x1a8>
    80000dfe:	00008517          	auipc	a0,0x8
    80000e02:	b3a50513          	add	a0,a0,-1222 # 80008938 <wait_lock>
    80000e06:	00005097          	auipc	ra,0x5
    80000e0a:	238080e7          	jalr	568(ra) # 8000603e <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e0e:	00008497          	auipc	s1,0x8
    80000e12:	f4248493          	add	s1,s1,-190 # 80008d50 <proc>
      initlock(&p->lock, "proc");
    80000e16:	00007b17          	auipc	s6,0x7
    80000e1a:	3a2b0b13          	add	s6,s6,930 # 800081b8 <etext+0x1b8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000e1e:	8aa6                	mv	s5,s1
    80000e20:	00007a17          	auipc	s4,0x7
    80000e24:	1e0a0a13          	add	s4,s4,480 # 80008000 <etext>
    80000e28:	04000937          	lui	s2,0x4000
    80000e2c:	197d                	add	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000e2e:	0932                	sll	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e30:	0000e997          	auipc	s3,0xe
    80000e34:	92098993          	add	s3,s3,-1760 # 8000e750 <tickslock>
      initlock(&p->lock, "proc");
    80000e38:	85da                	mv	a1,s6
    80000e3a:	8526                	mv	a0,s1
    80000e3c:	00005097          	auipc	ra,0x5
    80000e40:	202080e7          	jalr	514(ra) # 8000603e <initlock>
      p->state = UNUSED;
    80000e44:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000e48:	415487b3          	sub	a5,s1,s5
    80000e4c:	878d                	sra	a5,a5,0x3
    80000e4e:	000a3703          	ld	a4,0(s4)
    80000e52:	02e787b3          	mul	a5,a5,a4
    80000e56:	2785                	addw	a5,a5,1
    80000e58:	00d7979b          	sllw	a5,a5,0xd
    80000e5c:	40f907b3          	sub	a5,s2,a5
    80000e60:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e62:	16848493          	add	s1,s1,360
    80000e66:	fd3499e3          	bne	s1,s3,80000e38 <procinit+0x6e>
  }
}
    80000e6a:	70e2                	ld	ra,56(sp)
    80000e6c:	7442                	ld	s0,48(sp)
    80000e6e:	74a2                	ld	s1,40(sp)
    80000e70:	7902                	ld	s2,32(sp)
    80000e72:	69e2                	ld	s3,24(sp)
    80000e74:	6a42                	ld	s4,16(sp)
    80000e76:	6aa2                	ld	s5,8(sp)
    80000e78:	6b02                	ld	s6,0(sp)
    80000e7a:	6121                	add	sp,sp,64
    80000e7c:	8082                	ret

0000000080000e7e <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e7e:	1141                	add	sp,sp,-16
    80000e80:	e422                	sd	s0,8(sp)
    80000e82:	0800                	add	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e84:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e86:	2501                	sext.w	a0,a0
    80000e88:	6422                	ld	s0,8(sp)
    80000e8a:	0141                	add	sp,sp,16
    80000e8c:	8082                	ret

0000000080000e8e <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000e8e:	1141                	add	sp,sp,-16
    80000e90:	e422                	sd	s0,8(sp)
    80000e92:	0800                	add	s0,sp,16
    80000e94:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e96:	2781                	sext.w	a5,a5
    80000e98:	079e                	sll	a5,a5,0x7
  return c;
}
    80000e9a:	00008517          	auipc	a0,0x8
    80000e9e:	ab650513          	add	a0,a0,-1354 # 80008950 <cpus>
    80000ea2:	953e                	add	a0,a0,a5
    80000ea4:	6422                	ld	s0,8(sp)
    80000ea6:	0141                	add	sp,sp,16
    80000ea8:	8082                	ret

0000000080000eaa <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000eaa:	1101                	add	sp,sp,-32
    80000eac:	ec06                	sd	ra,24(sp)
    80000eae:	e822                	sd	s0,16(sp)
    80000eb0:	e426                	sd	s1,8(sp)
    80000eb2:	1000                	add	s0,sp,32
  push_off();
    80000eb4:	00005097          	auipc	ra,0x5
    80000eb8:	1ce080e7          	jalr	462(ra) # 80006082 <push_off>
    80000ebc:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000ebe:	2781                	sext.w	a5,a5
    80000ec0:	079e                	sll	a5,a5,0x7
    80000ec2:	00008717          	auipc	a4,0x8
    80000ec6:	a5e70713          	add	a4,a4,-1442 # 80008920 <pid_lock>
    80000eca:	97ba                	add	a5,a5,a4
    80000ecc:	7b84                	ld	s1,48(a5)
  pop_off();
    80000ece:	00005097          	auipc	ra,0x5
    80000ed2:	254080e7          	jalr	596(ra) # 80006122 <pop_off>
  return p;
}
    80000ed6:	8526                	mv	a0,s1
    80000ed8:	60e2                	ld	ra,24(sp)
    80000eda:	6442                	ld	s0,16(sp)
    80000edc:	64a2                	ld	s1,8(sp)
    80000ede:	6105                	add	sp,sp,32
    80000ee0:	8082                	ret

0000000080000ee2 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000ee2:	1141                	add	sp,sp,-16
    80000ee4:	e406                	sd	ra,8(sp)
    80000ee6:	e022                	sd	s0,0(sp)
    80000ee8:	0800                	add	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000eea:	00000097          	auipc	ra,0x0
    80000eee:	fc0080e7          	jalr	-64(ra) # 80000eaa <myproc>
    80000ef2:	00005097          	auipc	ra,0x5
    80000ef6:	290080e7          	jalr	656(ra) # 80006182 <release>

  if (first) {
    80000efa:	00008797          	auipc	a5,0x8
    80000efe:	9867a783          	lw	a5,-1658(a5) # 80008880 <first.1>
    80000f02:	eb89                	bnez	a5,80000f14 <forkret+0x32>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80000f04:	00001097          	auipc	ra,0x1
    80000f08:	c60080e7          	jalr	-928(ra) # 80001b64 <usertrapret>
}
    80000f0c:	60a2                	ld	ra,8(sp)
    80000f0e:	6402                	ld	s0,0(sp)
    80000f10:	0141                	add	sp,sp,16
    80000f12:	8082                	ret
    fsinit(ROOTDEV);
    80000f14:	4505                	li	a0,1
    80000f16:	00002097          	auipc	ra,0x2
    80000f1a:	9aa080e7          	jalr	-1622(ra) # 800028c0 <fsinit>
    first = 0;
    80000f1e:	00008797          	auipc	a5,0x8
    80000f22:	9607a123          	sw	zero,-1694(a5) # 80008880 <first.1>
    __sync_synchronize();
    80000f26:	0ff0000f          	fence
    80000f2a:	bfe9                	j	80000f04 <forkret+0x22>

0000000080000f2c <allocpid>:
{
    80000f2c:	1101                	add	sp,sp,-32
    80000f2e:	ec06                	sd	ra,24(sp)
    80000f30:	e822                	sd	s0,16(sp)
    80000f32:	e426                	sd	s1,8(sp)
    80000f34:	e04a                	sd	s2,0(sp)
    80000f36:	1000                	add	s0,sp,32
  acquire(&pid_lock);
    80000f38:	00008917          	auipc	s2,0x8
    80000f3c:	9e890913          	add	s2,s2,-1560 # 80008920 <pid_lock>
    80000f40:	854a                	mv	a0,s2
    80000f42:	00005097          	auipc	ra,0x5
    80000f46:	18c080e7          	jalr	396(ra) # 800060ce <acquire>
  pid = nextpid;
    80000f4a:	00008797          	auipc	a5,0x8
    80000f4e:	93a78793          	add	a5,a5,-1734 # 80008884 <nextpid>
    80000f52:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f54:	0014871b          	addw	a4,s1,1
    80000f58:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f5a:	854a                	mv	a0,s2
    80000f5c:	00005097          	auipc	ra,0x5
    80000f60:	226080e7          	jalr	550(ra) # 80006182 <release>
}
    80000f64:	8526                	mv	a0,s1
    80000f66:	60e2                	ld	ra,24(sp)
    80000f68:	6442                	ld	s0,16(sp)
    80000f6a:	64a2                	ld	s1,8(sp)
    80000f6c:	6902                	ld	s2,0(sp)
    80000f6e:	6105                	add	sp,sp,32
    80000f70:	8082                	ret

0000000080000f72 <proc_pagetable>:
{
    80000f72:	1101                	add	sp,sp,-32
    80000f74:	ec06                	sd	ra,24(sp)
    80000f76:	e822                	sd	s0,16(sp)
    80000f78:	e426                	sd	s1,8(sp)
    80000f7a:	e04a                	sd	s2,0(sp)
    80000f7c:	1000                	add	s0,sp,32
    80000f7e:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f80:	00000097          	auipc	ra,0x0
    80000f84:	872080e7          	jalr	-1934(ra) # 800007f2 <uvmcreate>
    80000f88:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f8a:	c121                	beqz	a0,80000fca <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f8c:	4729                	li	a4,10
    80000f8e:	00006697          	auipc	a3,0x6
    80000f92:	07268693          	add	a3,a3,114 # 80007000 <_trampoline>
    80000f96:	6605                	lui	a2,0x1
    80000f98:	040005b7          	lui	a1,0x4000
    80000f9c:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f9e:	05b2                	sll	a1,a1,0xc
    80000fa0:	fffff097          	auipc	ra,0xfffff
    80000fa4:	5a4080e7          	jalr	1444(ra) # 80000544 <mappages>
    80000fa8:	02054863          	bltz	a0,80000fd8 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000fac:	4719                	li	a4,6
    80000fae:	05893683          	ld	a3,88(s2)
    80000fb2:	6605                	lui	a2,0x1
    80000fb4:	020005b7          	lui	a1,0x2000
    80000fb8:	15fd                	add	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000fba:	05b6                	sll	a1,a1,0xd
    80000fbc:	8526                	mv	a0,s1
    80000fbe:	fffff097          	auipc	ra,0xfffff
    80000fc2:	586080e7          	jalr	1414(ra) # 80000544 <mappages>
    80000fc6:	02054163          	bltz	a0,80000fe8 <proc_pagetable+0x76>
}
    80000fca:	8526                	mv	a0,s1
    80000fcc:	60e2                	ld	ra,24(sp)
    80000fce:	6442                	ld	s0,16(sp)
    80000fd0:	64a2                	ld	s1,8(sp)
    80000fd2:	6902                	ld	s2,0(sp)
    80000fd4:	6105                	add	sp,sp,32
    80000fd6:	8082                	ret
    uvmfree(pagetable, 0);
    80000fd8:	4581                	li	a1,0
    80000fda:	8526                	mv	a0,s1
    80000fdc:	00000097          	auipc	ra,0x0
    80000fe0:	a1c080e7          	jalr	-1508(ra) # 800009f8 <uvmfree>
    return 0;
    80000fe4:	4481                	li	s1,0
    80000fe6:	b7d5                	j	80000fca <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fe8:	4681                	li	a3,0
    80000fea:	4605                	li	a2,1
    80000fec:	040005b7          	lui	a1,0x4000
    80000ff0:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000ff2:	05b2                	sll	a1,a1,0xc
    80000ff4:	8526                	mv	a0,s1
    80000ff6:	fffff097          	auipc	ra,0xfffff
    80000ffa:	738080e7          	jalr	1848(ra) # 8000072e <uvmunmap>
    uvmfree(pagetable, 0);
    80000ffe:	4581                	li	a1,0
    80001000:	8526                	mv	a0,s1
    80001002:	00000097          	auipc	ra,0x0
    80001006:	9f6080e7          	jalr	-1546(ra) # 800009f8 <uvmfree>
    return 0;
    8000100a:	4481                	li	s1,0
    8000100c:	bf7d                	j	80000fca <proc_pagetable+0x58>

000000008000100e <proc_freepagetable>:
{
    8000100e:	1101                	add	sp,sp,-32
    80001010:	ec06                	sd	ra,24(sp)
    80001012:	e822                	sd	s0,16(sp)
    80001014:	e426                	sd	s1,8(sp)
    80001016:	e04a                	sd	s2,0(sp)
    80001018:	1000                	add	s0,sp,32
    8000101a:	84aa                	mv	s1,a0
    8000101c:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000101e:	4681                	li	a3,0
    80001020:	4605                	li	a2,1
    80001022:	040005b7          	lui	a1,0x4000
    80001026:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001028:	05b2                	sll	a1,a1,0xc
    8000102a:	fffff097          	auipc	ra,0xfffff
    8000102e:	704080e7          	jalr	1796(ra) # 8000072e <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001032:	4681                	li	a3,0
    80001034:	4605                	li	a2,1
    80001036:	020005b7          	lui	a1,0x2000
    8000103a:	15fd                	add	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    8000103c:	05b6                	sll	a1,a1,0xd
    8000103e:	8526                	mv	a0,s1
    80001040:	fffff097          	auipc	ra,0xfffff
    80001044:	6ee080e7          	jalr	1774(ra) # 8000072e <uvmunmap>
  uvmfree(pagetable, sz);
    80001048:	85ca                	mv	a1,s2
    8000104a:	8526                	mv	a0,s1
    8000104c:	00000097          	auipc	ra,0x0
    80001050:	9ac080e7          	jalr	-1620(ra) # 800009f8 <uvmfree>
}
    80001054:	60e2                	ld	ra,24(sp)
    80001056:	6442                	ld	s0,16(sp)
    80001058:	64a2                	ld	s1,8(sp)
    8000105a:	6902                	ld	s2,0(sp)
    8000105c:	6105                	add	sp,sp,32
    8000105e:	8082                	ret

0000000080001060 <freeproc>:
{
    80001060:	1101                	add	sp,sp,-32
    80001062:	ec06                	sd	ra,24(sp)
    80001064:	e822                	sd	s0,16(sp)
    80001066:	e426                	sd	s1,8(sp)
    80001068:	1000                	add	s0,sp,32
    8000106a:	84aa                	mv	s1,a0
  if(p->trapframe)
    8000106c:	6d28                	ld	a0,88(a0)
    8000106e:	c509                	beqz	a0,80001078 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001070:	fffff097          	auipc	ra,0xfffff
    80001074:	fac080e7          	jalr	-84(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001078:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    8000107c:	68a8                	ld	a0,80(s1)
    8000107e:	c511                	beqz	a0,8000108a <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001080:	64ac                	ld	a1,72(s1)
    80001082:	00000097          	auipc	ra,0x0
    80001086:	f8c080e7          	jalr	-116(ra) # 8000100e <proc_freepagetable>
  p->pagetable = 0;
    8000108a:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    8000108e:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001092:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001096:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    8000109a:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    8000109e:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    800010a2:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    800010a6:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    800010aa:	0004ac23          	sw	zero,24(s1)
}
    800010ae:	60e2                	ld	ra,24(sp)
    800010b0:	6442                	ld	s0,16(sp)
    800010b2:	64a2                	ld	s1,8(sp)
    800010b4:	6105                	add	sp,sp,32
    800010b6:	8082                	ret

00000000800010b8 <allocproc>:
{
    800010b8:	1101                	add	sp,sp,-32
    800010ba:	ec06                	sd	ra,24(sp)
    800010bc:	e822                	sd	s0,16(sp)
    800010be:	e426                	sd	s1,8(sp)
    800010c0:	e04a                	sd	s2,0(sp)
    800010c2:	1000                	add	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800010c4:	00008497          	auipc	s1,0x8
    800010c8:	c8c48493          	add	s1,s1,-884 # 80008d50 <proc>
    800010cc:	0000d917          	auipc	s2,0xd
    800010d0:	68490913          	add	s2,s2,1668 # 8000e750 <tickslock>
    acquire(&p->lock);
    800010d4:	8526                	mv	a0,s1
    800010d6:	00005097          	auipc	ra,0x5
    800010da:	ff8080e7          	jalr	-8(ra) # 800060ce <acquire>
    if(p->state == UNUSED) {
    800010de:	4c9c                	lw	a5,24(s1)
    800010e0:	cf81                	beqz	a5,800010f8 <allocproc+0x40>
      release(&p->lock);
    800010e2:	8526                	mv	a0,s1
    800010e4:	00005097          	auipc	ra,0x5
    800010e8:	09e080e7          	jalr	158(ra) # 80006182 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800010ec:	16848493          	add	s1,s1,360
    800010f0:	ff2492e3          	bne	s1,s2,800010d4 <allocproc+0x1c>
  return 0;
    800010f4:	4481                	li	s1,0
    800010f6:	a889                	j	80001148 <allocproc+0x90>
  p->pid = allocpid();
    800010f8:	00000097          	auipc	ra,0x0
    800010fc:	e34080e7          	jalr	-460(ra) # 80000f2c <allocpid>
    80001100:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001102:	4785                	li	a5,1
    80001104:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001106:	fffff097          	auipc	ra,0xfffff
    8000110a:	014080e7          	jalr	20(ra) # 8000011a <kalloc>
    8000110e:	892a                	mv	s2,a0
    80001110:	eca8                	sd	a0,88(s1)
    80001112:	c131                	beqz	a0,80001156 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    80001114:	8526                	mv	a0,s1
    80001116:	00000097          	auipc	ra,0x0
    8000111a:	e5c080e7          	jalr	-420(ra) # 80000f72 <proc_pagetable>
    8000111e:	892a                	mv	s2,a0
    80001120:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001122:	c531                	beqz	a0,8000116e <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    80001124:	07000613          	li	a2,112
    80001128:	4581                	li	a1,0
    8000112a:	06048513          	add	a0,s1,96
    8000112e:	fffff097          	auipc	ra,0xfffff
    80001132:	04c080e7          	jalr	76(ra) # 8000017a <memset>
  p->context.ra = (uint64)forkret;
    80001136:	00000797          	auipc	a5,0x0
    8000113a:	dac78793          	add	a5,a5,-596 # 80000ee2 <forkret>
    8000113e:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001140:	60bc                	ld	a5,64(s1)
    80001142:	6705                	lui	a4,0x1
    80001144:	97ba                	add	a5,a5,a4
    80001146:	f4bc                	sd	a5,104(s1)
}
    80001148:	8526                	mv	a0,s1
    8000114a:	60e2                	ld	ra,24(sp)
    8000114c:	6442                	ld	s0,16(sp)
    8000114e:	64a2                	ld	s1,8(sp)
    80001150:	6902                	ld	s2,0(sp)
    80001152:	6105                	add	sp,sp,32
    80001154:	8082                	ret
    freeproc(p);
    80001156:	8526                	mv	a0,s1
    80001158:	00000097          	auipc	ra,0x0
    8000115c:	f08080e7          	jalr	-248(ra) # 80001060 <freeproc>
    release(&p->lock);
    80001160:	8526                	mv	a0,s1
    80001162:	00005097          	auipc	ra,0x5
    80001166:	020080e7          	jalr	32(ra) # 80006182 <release>
    return 0;
    8000116a:	84ca                	mv	s1,s2
    8000116c:	bff1                	j	80001148 <allocproc+0x90>
    freeproc(p);
    8000116e:	8526                	mv	a0,s1
    80001170:	00000097          	auipc	ra,0x0
    80001174:	ef0080e7          	jalr	-272(ra) # 80001060 <freeproc>
    release(&p->lock);
    80001178:	8526                	mv	a0,s1
    8000117a:	00005097          	auipc	ra,0x5
    8000117e:	008080e7          	jalr	8(ra) # 80006182 <release>
    return 0;
    80001182:	84ca                	mv	s1,s2
    80001184:	b7d1                	j	80001148 <allocproc+0x90>

0000000080001186 <userinit>:
{
    80001186:	1101                	add	sp,sp,-32
    80001188:	ec06                	sd	ra,24(sp)
    8000118a:	e822                	sd	s0,16(sp)
    8000118c:	e426                	sd	s1,8(sp)
    8000118e:	1000                	add	s0,sp,32
  p = allocproc();
    80001190:	00000097          	auipc	ra,0x0
    80001194:	f28080e7          	jalr	-216(ra) # 800010b8 <allocproc>
    80001198:	84aa                	mv	s1,a0
  initproc = p;
    8000119a:	00007797          	auipc	a5,0x7
    8000119e:	74a7b323          	sd	a0,1862(a5) # 800088e0 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    800011a2:	03400613          	li	a2,52
    800011a6:	00007597          	auipc	a1,0x7
    800011aa:	6ea58593          	add	a1,a1,1770 # 80008890 <initcode>
    800011ae:	6928                	ld	a0,80(a0)
    800011b0:	fffff097          	auipc	ra,0xfffff
    800011b4:	670080e7          	jalr	1648(ra) # 80000820 <uvmfirst>
  p->sz = PGSIZE;
    800011b8:	6785                	lui	a5,0x1
    800011ba:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800011bc:	6cb8                	ld	a4,88(s1)
    800011be:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800011c2:	6cb8                	ld	a4,88(s1)
    800011c4:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800011c6:	4641                	li	a2,16
    800011c8:	00007597          	auipc	a1,0x7
    800011cc:	ff858593          	add	a1,a1,-8 # 800081c0 <etext+0x1c0>
    800011d0:	15848513          	add	a0,s1,344
    800011d4:	fffff097          	auipc	ra,0xfffff
    800011d8:	0ee080e7          	jalr	238(ra) # 800002c2 <safestrcpy>
  p->cwd = namei("/");
    800011dc:	00007517          	auipc	a0,0x7
    800011e0:	ff450513          	add	a0,a0,-12 # 800081d0 <etext+0x1d0>
    800011e4:	00002097          	auipc	ra,0x2
    800011e8:	0fa080e7          	jalr	250(ra) # 800032de <namei>
    800011ec:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800011f0:	478d                	li	a5,3
    800011f2:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800011f4:	8526                	mv	a0,s1
    800011f6:	00005097          	auipc	ra,0x5
    800011fa:	f8c080e7          	jalr	-116(ra) # 80006182 <release>
}
    800011fe:	60e2                	ld	ra,24(sp)
    80001200:	6442                	ld	s0,16(sp)
    80001202:	64a2                	ld	s1,8(sp)
    80001204:	6105                	add	sp,sp,32
    80001206:	8082                	ret

0000000080001208 <growproc>:
{
    80001208:	1101                	add	sp,sp,-32
    8000120a:	ec06                	sd	ra,24(sp)
    8000120c:	e822                	sd	s0,16(sp)
    8000120e:	e426                	sd	s1,8(sp)
    80001210:	e04a                	sd	s2,0(sp)
    80001212:	1000                	add	s0,sp,32
    80001214:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001216:	00000097          	auipc	ra,0x0
    8000121a:	c94080e7          	jalr	-876(ra) # 80000eaa <myproc>
    8000121e:	84aa                	mv	s1,a0
  sz = p->sz;
    80001220:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001222:	01204c63          	bgtz	s2,8000123a <growproc+0x32>
  } else if(n < 0){
    80001226:	02094663          	bltz	s2,80001252 <growproc+0x4a>
  p->sz = sz;
    8000122a:	e4ac                	sd	a1,72(s1)
  return 0;
    8000122c:	4501                	li	a0,0
}
    8000122e:	60e2                	ld	ra,24(sp)
    80001230:	6442                	ld	s0,16(sp)
    80001232:	64a2                	ld	s1,8(sp)
    80001234:	6902                	ld	s2,0(sp)
    80001236:	6105                	add	sp,sp,32
    80001238:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    8000123a:	4691                	li	a3,4
    8000123c:	00b90633          	add	a2,s2,a1
    80001240:	6928                	ld	a0,80(a0)
    80001242:	fffff097          	auipc	ra,0xfffff
    80001246:	698080e7          	jalr	1688(ra) # 800008da <uvmalloc>
    8000124a:	85aa                	mv	a1,a0
    8000124c:	fd79                	bnez	a0,8000122a <growproc+0x22>
      return -1;
    8000124e:	557d                	li	a0,-1
    80001250:	bff9                	j	8000122e <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001252:	00b90633          	add	a2,s2,a1
    80001256:	6928                	ld	a0,80(a0)
    80001258:	fffff097          	auipc	ra,0xfffff
    8000125c:	63a080e7          	jalr	1594(ra) # 80000892 <uvmdealloc>
    80001260:	85aa                	mv	a1,a0
    80001262:	b7e1                	j	8000122a <growproc+0x22>

0000000080001264 <fork>:
{
    80001264:	7139                	add	sp,sp,-64
    80001266:	fc06                	sd	ra,56(sp)
    80001268:	f822                	sd	s0,48(sp)
    8000126a:	f426                	sd	s1,40(sp)
    8000126c:	f04a                	sd	s2,32(sp)
    8000126e:	ec4e                	sd	s3,24(sp)
    80001270:	e852                	sd	s4,16(sp)
    80001272:	e456                	sd	s5,8(sp)
    80001274:	0080                	add	s0,sp,64
  struct proc *p = myproc();
    80001276:	00000097          	auipc	ra,0x0
    8000127a:	c34080e7          	jalr	-972(ra) # 80000eaa <myproc>
    8000127e:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001280:	00000097          	auipc	ra,0x0
    80001284:	e38080e7          	jalr	-456(ra) # 800010b8 <allocproc>
    80001288:	10050c63          	beqz	a0,800013a0 <fork+0x13c>
    8000128c:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000128e:	048ab603          	ld	a2,72(s5)
    80001292:	692c                	ld	a1,80(a0)
    80001294:	050ab503          	ld	a0,80(s5)
    80001298:	fffff097          	auipc	ra,0xfffff
    8000129c:	79a080e7          	jalr	1946(ra) # 80000a32 <uvmcopy>
    800012a0:	04054863          	bltz	a0,800012f0 <fork+0x8c>
  np->sz = p->sz;
    800012a4:	048ab783          	ld	a5,72(s5)
    800012a8:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    800012ac:	058ab683          	ld	a3,88(s5)
    800012b0:	87b6                	mv	a5,a3
    800012b2:	058a3703          	ld	a4,88(s4)
    800012b6:	12068693          	add	a3,a3,288
    800012ba:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800012be:	6788                	ld	a0,8(a5)
    800012c0:	6b8c                	ld	a1,16(a5)
    800012c2:	6f90                	ld	a2,24(a5)
    800012c4:	01073023          	sd	a6,0(a4)
    800012c8:	e708                	sd	a0,8(a4)
    800012ca:	eb0c                	sd	a1,16(a4)
    800012cc:	ef10                	sd	a2,24(a4)
    800012ce:	02078793          	add	a5,a5,32
    800012d2:	02070713          	add	a4,a4,32
    800012d6:	fed792e3          	bne	a5,a3,800012ba <fork+0x56>
  np->trapframe->a0 = 0;
    800012da:	058a3783          	ld	a5,88(s4)
    800012de:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800012e2:	0d0a8493          	add	s1,s5,208
    800012e6:	0d0a0913          	add	s2,s4,208
    800012ea:	150a8993          	add	s3,s5,336
    800012ee:	a00d                	j	80001310 <fork+0xac>
    freeproc(np);
    800012f0:	8552                	mv	a0,s4
    800012f2:	00000097          	auipc	ra,0x0
    800012f6:	d6e080e7          	jalr	-658(ra) # 80001060 <freeproc>
    release(&np->lock);
    800012fa:	8552                	mv	a0,s4
    800012fc:	00005097          	auipc	ra,0x5
    80001300:	e86080e7          	jalr	-378(ra) # 80006182 <release>
    return -1;
    80001304:	597d                	li	s2,-1
    80001306:	a059                	j	8000138c <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    80001308:	04a1                	add	s1,s1,8
    8000130a:	0921                	add	s2,s2,8
    8000130c:	01348b63          	beq	s1,s3,80001322 <fork+0xbe>
    if(p->ofile[i])
    80001310:	6088                	ld	a0,0(s1)
    80001312:	d97d                	beqz	a0,80001308 <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    80001314:	00002097          	auipc	ra,0x2
    80001318:	63c080e7          	jalr	1596(ra) # 80003950 <filedup>
    8000131c:	00a93023          	sd	a0,0(s2)
    80001320:	b7e5                	j	80001308 <fork+0xa4>
  np->cwd = idup(p->cwd);
    80001322:	150ab503          	ld	a0,336(s5)
    80001326:	00001097          	auipc	ra,0x1
    8000132a:	7d4080e7          	jalr	2004(ra) # 80002afa <idup>
    8000132e:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001332:	4641                	li	a2,16
    80001334:	158a8593          	add	a1,s5,344
    80001338:	158a0513          	add	a0,s4,344
    8000133c:	fffff097          	auipc	ra,0xfffff
    80001340:	f86080e7          	jalr	-122(ra) # 800002c2 <safestrcpy>
  pid = np->pid;
    80001344:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001348:	8552                	mv	a0,s4
    8000134a:	00005097          	auipc	ra,0x5
    8000134e:	e38080e7          	jalr	-456(ra) # 80006182 <release>
  acquire(&wait_lock);
    80001352:	00007497          	auipc	s1,0x7
    80001356:	5e648493          	add	s1,s1,1510 # 80008938 <wait_lock>
    8000135a:	8526                	mv	a0,s1
    8000135c:	00005097          	auipc	ra,0x5
    80001360:	d72080e7          	jalr	-654(ra) # 800060ce <acquire>
  np->parent = p;
    80001364:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001368:	8526                	mv	a0,s1
    8000136a:	00005097          	auipc	ra,0x5
    8000136e:	e18080e7          	jalr	-488(ra) # 80006182 <release>
  acquire(&np->lock);
    80001372:	8552                	mv	a0,s4
    80001374:	00005097          	auipc	ra,0x5
    80001378:	d5a080e7          	jalr	-678(ra) # 800060ce <acquire>
  np->state = RUNNABLE;
    8000137c:	478d                	li	a5,3
    8000137e:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001382:	8552                	mv	a0,s4
    80001384:	00005097          	auipc	ra,0x5
    80001388:	dfe080e7          	jalr	-514(ra) # 80006182 <release>
}
    8000138c:	854a                	mv	a0,s2
    8000138e:	70e2                	ld	ra,56(sp)
    80001390:	7442                	ld	s0,48(sp)
    80001392:	74a2                	ld	s1,40(sp)
    80001394:	7902                	ld	s2,32(sp)
    80001396:	69e2                	ld	s3,24(sp)
    80001398:	6a42                	ld	s4,16(sp)
    8000139a:	6aa2                	ld	s5,8(sp)
    8000139c:	6121                	add	sp,sp,64
    8000139e:	8082                	ret
    return -1;
    800013a0:	597d                	li	s2,-1
    800013a2:	b7ed                	j	8000138c <fork+0x128>

00000000800013a4 <scheduler>:
{
    800013a4:	7139                	add	sp,sp,-64
    800013a6:	fc06                	sd	ra,56(sp)
    800013a8:	f822                	sd	s0,48(sp)
    800013aa:	f426                	sd	s1,40(sp)
    800013ac:	f04a                	sd	s2,32(sp)
    800013ae:	ec4e                	sd	s3,24(sp)
    800013b0:	e852                	sd	s4,16(sp)
    800013b2:	e456                	sd	s5,8(sp)
    800013b4:	e05a                	sd	s6,0(sp)
    800013b6:	0080                	add	s0,sp,64
    800013b8:	8792                	mv	a5,tp
  int id = r_tp();
    800013ba:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013bc:	00779a93          	sll	s5,a5,0x7
    800013c0:	00007717          	auipc	a4,0x7
    800013c4:	56070713          	add	a4,a4,1376 # 80008920 <pid_lock>
    800013c8:	9756                	add	a4,a4,s5
    800013ca:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013ce:	00007717          	auipc	a4,0x7
    800013d2:	58a70713          	add	a4,a4,1418 # 80008958 <cpus+0x8>
    800013d6:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800013d8:	498d                	li	s3,3
        p->state = RUNNING;
    800013da:	4b11                	li	s6,4
        c->proc = p;
    800013dc:	079e                	sll	a5,a5,0x7
    800013de:	00007a17          	auipc	s4,0x7
    800013e2:	542a0a13          	add	s4,s4,1346 # 80008920 <pid_lock>
    800013e6:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800013e8:	0000d917          	auipc	s2,0xd
    800013ec:	36890913          	add	s2,s2,872 # 8000e750 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013f0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013f4:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013f8:	10079073          	csrw	sstatus,a5
    800013fc:	00008497          	auipc	s1,0x8
    80001400:	95448493          	add	s1,s1,-1708 # 80008d50 <proc>
    80001404:	a811                	j	80001418 <scheduler+0x74>
      release(&p->lock);
    80001406:	8526                	mv	a0,s1
    80001408:	00005097          	auipc	ra,0x5
    8000140c:	d7a080e7          	jalr	-646(ra) # 80006182 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001410:	16848493          	add	s1,s1,360
    80001414:	fd248ee3          	beq	s1,s2,800013f0 <scheduler+0x4c>
      acquire(&p->lock);
    80001418:	8526                	mv	a0,s1
    8000141a:	00005097          	auipc	ra,0x5
    8000141e:	cb4080e7          	jalr	-844(ra) # 800060ce <acquire>
      if(p->state == RUNNABLE) {
    80001422:	4c9c                	lw	a5,24(s1)
    80001424:	ff3791e3          	bne	a5,s3,80001406 <scheduler+0x62>
        p->state = RUNNING;
    80001428:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    8000142c:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001430:	06048593          	add	a1,s1,96
    80001434:	8556                	mv	a0,s5
    80001436:	00000097          	auipc	ra,0x0
    8000143a:	684080e7          	jalr	1668(ra) # 80001aba <swtch>
        c->proc = 0;
    8000143e:	020a3823          	sd	zero,48(s4)
    80001442:	b7d1                	j	80001406 <scheduler+0x62>

0000000080001444 <sched>:
{
    80001444:	7179                	add	sp,sp,-48
    80001446:	f406                	sd	ra,40(sp)
    80001448:	f022                	sd	s0,32(sp)
    8000144a:	ec26                	sd	s1,24(sp)
    8000144c:	e84a                	sd	s2,16(sp)
    8000144e:	e44e                	sd	s3,8(sp)
    80001450:	1800                	add	s0,sp,48
  struct proc *p = myproc();
    80001452:	00000097          	auipc	ra,0x0
    80001456:	a58080e7          	jalr	-1448(ra) # 80000eaa <myproc>
    8000145a:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000145c:	00005097          	auipc	ra,0x5
    80001460:	bf8080e7          	jalr	-1032(ra) # 80006054 <holding>
    80001464:	c93d                	beqz	a0,800014da <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001466:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001468:	2781                	sext.w	a5,a5
    8000146a:	079e                	sll	a5,a5,0x7
    8000146c:	00007717          	auipc	a4,0x7
    80001470:	4b470713          	add	a4,a4,1204 # 80008920 <pid_lock>
    80001474:	97ba                	add	a5,a5,a4
    80001476:	0a87a703          	lw	a4,168(a5)
    8000147a:	4785                	li	a5,1
    8000147c:	06f71763          	bne	a4,a5,800014ea <sched+0xa6>
  if(p->state == RUNNING)
    80001480:	4c98                	lw	a4,24(s1)
    80001482:	4791                	li	a5,4
    80001484:	06f70b63          	beq	a4,a5,800014fa <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001488:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000148c:	8b89                	and	a5,a5,2
  if(intr_get())
    8000148e:	efb5                	bnez	a5,8000150a <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001490:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001492:	00007917          	auipc	s2,0x7
    80001496:	48e90913          	add	s2,s2,1166 # 80008920 <pid_lock>
    8000149a:	2781                	sext.w	a5,a5
    8000149c:	079e                	sll	a5,a5,0x7
    8000149e:	97ca                	add	a5,a5,s2
    800014a0:	0ac7a983          	lw	s3,172(a5)
    800014a4:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800014a6:	2781                	sext.w	a5,a5
    800014a8:	079e                	sll	a5,a5,0x7
    800014aa:	00007597          	auipc	a1,0x7
    800014ae:	4ae58593          	add	a1,a1,1198 # 80008958 <cpus+0x8>
    800014b2:	95be                	add	a1,a1,a5
    800014b4:	06048513          	add	a0,s1,96
    800014b8:	00000097          	auipc	ra,0x0
    800014bc:	602080e7          	jalr	1538(ra) # 80001aba <swtch>
    800014c0:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014c2:	2781                	sext.w	a5,a5
    800014c4:	079e                	sll	a5,a5,0x7
    800014c6:	993e                	add	s2,s2,a5
    800014c8:	0b392623          	sw	s3,172(s2)
}
    800014cc:	70a2                	ld	ra,40(sp)
    800014ce:	7402                	ld	s0,32(sp)
    800014d0:	64e2                	ld	s1,24(sp)
    800014d2:	6942                	ld	s2,16(sp)
    800014d4:	69a2                	ld	s3,8(sp)
    800014d6:	6145                	add	sp,sp,48
    800014d8:	8082                	ret
    panic("sched p->lock");
    800014da:	00007517          	auipc	a0,0x7
    800014de:	cfe50513          	add	a0,a0,-770 # 800081d8 <etext+0x1d8>
    800014e2:	00004097          	auipc	ra,0x4
    800014e6:	6b4080e7          	jalr	1716(ra) # 80005b96 <panic>
    panic("sched locks");
    800014ea:	00007517          	auipc	a0,0x7
    800014ee:	cfe50513          	add	a0,a0,-770 # 800081e8 <etext+0x1e8>
    800014f2:	00004097          	auipc	ra,0x4
    800014f6:	6a4080e7          	jalr	1700(ra) # 80005b96 <panic>
    panic("sched running");
    800014fa:	00007517          	auipc	a0,0x7
    800014fe:	cfe50513          	add	a0,a0,-770 # 800081f8 <etext+0x1f8>
    80001502:	00004097          	auipc	ra,0x4
    80001506:	694080e7          	jalr	1684(ra) # 80005b96 <panic>
    panic("sched interruptible");
    8000150a:	00007517          	auipc	a0,0x7
    8000150e:	cfe50513          	add	a0,a0,-770 # 80008208 <etext+0x208>
    80001512:	00004097          	auipc	ra,0x4
    80001516:	684080e7          	jalr	1668(ra) # 80005b96 <panic>

000000008000151a <yield>:
{
    8000151a:	1101                	add	sp,sp,-32
    8000151c:	ec06                	sd	ra,24(sp)
    8000151e:	e822                	sd	s0,16(sp)
    80001520:	e426                	sd	s1,8(sp)
    80001522:	1000                	add	s0,sp,32
  struct proc *p = myproc();
    80001524:	00000097          	auipc	ra,0x0
    80001528:	986080e7          	jalr	-1658(ra) # 80000eaa <myproc>
    8000152c:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000152e:	00005097          	auipc	ra,0x5
    80001532:	ba0080e7          	jalr	-1120(ra) # 800060ce <acquire>
  p->state = RUNNABLE;
    80001536:	478d                	li	a5,3
    80001538:	cc9c                	sw	a5,24(s1)
  sched();
    8000153a:	00000097          	auipc	ra,0x0
    8000153e:	f0a080e7          	jalr	-246(ra) # 80001444 <sched>
  release(&p->lock);
    80001542:	8526                	mv	a0,s1
    80001544:	00005097          	auipc	ra,0x5
    80001548:	c3e080e7          	jalr	-962(ra) # 80006182 <release>
}
    8000154c:	60e2                	ld	ra,24(sp)
    8000154e:	6442                	ld	s0,16(sp)
    80001550:	64a2                	ld	s1,8(sp)
    80001552:	6105                	add	sp,sp,32
    80001554:	8082                	ret

0000000080001556 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001556:	7179                	add	sp,sp,-48
    80001558:	f406                	sd	ra,40(sp)
    8000155a:	f022                	sd	s0,32(sp)
    8000155c:	ec26                	sd	s1,24(sp)
    8000155e:	e84a                	sd	s2,16(sp)
    80001560:	e44e                	sd	s3,8(sp)
    80001562:	1800                	add	s0,sp,48
    80001564:	89aa                	mv	s3,a0
    80001566:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001568:	00000097          	auipc	ra,0x0
    8000156c:	942080e7          	jalr	-1726(ra) # 80000eaa <myproc>
    80001570:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001572:	00005097          	auipc	ra,0x5
    80001576:	b5c080e7          	jalr	-1188(ra) # 800060ce <acquire>
  release(lk);
    8000157a:	854a                	mv	a0,s2
    8000157c:	00005097          	auipc	ra,0x5
    80001580:	c06080e7          	jalr	-1018(ra) # 80006182 <release>

  // Go to sleep.
  p->chan = chan;
    80001584:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001588:	4789                	li	a5,2
    8000158a:	cc9c                	sw	a5,24(s1)

  sched();
    8000158c:	00000097          	auipc	ra,0x0
    80001590:	eb8080e7          	jalr	-328(ra) # 80001444 <sched>

  // Tidy up.
  p->chan = 0;
    80001594:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001598:	8526                	mv	a0,s1
    8000159a:	00005097          	auipc	ra,0x5
    8000159e:	be8080e7          	jalr	-1048(ra) # 80006182 <release>
  acquire(lk);
    800015a2:	854a                	mv	a0,s2
    800015a4:	00005097          	auipc	ra,0x5
    800015a8:	b2a080e7          	jalr	-1238(ra) # 800060ce <acquire>
}
    800015ac:	70a2                	ld	ra,40(sp)
    800015ae:	7402                	ld	s0,32(sp)
    800015b0:	64e2                	ld	s1,24(sp)
    800015b2:	6942                	ld	s2,16(sp)
    800015b4:	69a2                	ld	s3,8(sp)
    800015b6:	6145                	add	sp,sp,48
    800015b8:	8082                	ret

00000000800015ba <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800015ba:	7139                	add	sp,sp,-64
    800015bc:	fc06                	sd	ra,56(sp)
    800015be:	f822                	sd	s0,48(sp)
    800015c0:	f426                	sd	s1,40(sp)
    800015c2:	f04a                	sd	s2,32(sp)
    800015c4:	ec4e                	sd	s3,24(sp)
    800015c6:	e852                	sd	s4,16(sp)
    800015c8:	e456                	sd	s5,8(sp)
    800015ca:	0080                	add	s0,sp,64
    800015cc:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800015ce:	00007497          	auipc	s1,0x7
    800015d2:	78248493          	add	s1,s1,1922 # 80008d50 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800015d6:	4989                	li	s3,2
        p->state = RUNNABLE;
    800015d8:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800015da:	0000d917          	auipc	s2,0xd
    800015de:	17690913          	add	s2,s2,374 # 8000e750 <tickslock>
    800015e2:	a811                	j	800015f6 <wakeup+0x3c>
      }
      release(&p->lock);
    800015e4:	8526                	mv	a0,s1
    800015e6:	00005097          	auipc	ra,0x5
    800015ea:	b9c080e7          	jalr	-1124(ra) # 80006182 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800015ee:	16848493          	add	s1,s1,360
    800015f2:	03248663          	beq	s1,s2,8000161e <wakeup+0x64>
    if(p != myproc()){
    800015f6:	00000097          	auipc	ra,0x0
    800015fa:	8b4080e7          	jalr	-1868(ra) # 80000eaa <myproc>
    800015fe:	fea488e3          	beq	s1,a0,800015ee <wakeup+0x34>
      acquire(&p->lock);
    80001602:	8526                	mv	a0,s1
    80001604:	00005097          	auipc	ra,0x5
    80001608:	aca080e7          	jalr	-1334(ra) # 800060ce <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000160c:	4c9c                	lw	a5,24(s1)
    8000160e:	fd379be3          	bne	a5,s3,800015e4 <wakeup+0x2a>
    80001612:	709c                	ld	a5,32(s1)
    80001614:	fd4798e3          	bne	a5,s4,800015e4 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001618:	0154ac23          	sw	s5,24(s1)
    8000161c:	b7e1                	j	800015e4 <wakeup+0x2a>
    }
  }
}
    8000161e:	70e2                	ld	ra,56(sp)
    80001620:	7442                	ld	s0,48(sp)
    80001622:	74a2                	ld	s1,40(sp)
    80001624:	7902                	ld	s2,32(sp)
    80001626:	69e2                	ld	s3,24(sp)
    80001628:	6a42                	ld	s4,16(sp)
    8000162a:	6aa2                	ld	s5,8(sp)
    8000162c:	6121                	add	sp,sp,64
    8000162e:	8082                	ret

0000000080001630 <reparent>:
{
    80001630:	7179                	add	sp,sp,-48
    80001632:	f406                	sd	ra,40(sp)
    80001634:	f022                	sd	s0,32(sp)
    80001636:	ec26                	sd	s1,24(sp)
    80001638:	e84a                	sd	s2,16(sp)
    8000163a:	e44e                	sd	s3,8(sp)
    8000163c:	e052                	sd	s4,0(sp)
    8000163e:	1800                	add	s0,sp,48
    80001640:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001642:	00007497          	auipc	s1,0x7
    80001646:	70e48493          	add	s1,s1,1806 # 80008d50 <proc>
      pp->parent = initproc;
    8000164a:	00007a17          	auipc	s4,0x7
    8000164e:	296a0a13          	add	s4,s4,662 # 800088e0 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001652:	0000d997          	auipc	s3,0xd
    80001656:	0fe98993          	add	s3,s3,254 # 8000e750 <tickslock>
    8000165a:	a029                	j	80001664 <reparent+0x34>
    8000165c:	16848493          	add	s1,s1,360
    80001660:	01348d63          	beq	s1,s3,8000167a <reparent+0x4a>
    if(pp->parent == p){
    80001664:	7c9c                	ld	a5,56(s1)
    80001666:	ff279be3          	bne	a5,s2,8000165c <reparent+0x2c>
      pp->parent = initproc;
    8000166a:	000a3503          	ld	a0,0(s4)
    8000166e:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001670:	00000097          	auipc	ra,0x0
    80001674:	f4a080e7          	jalr	-182(ra) # 800015ba <wakeup>
    80001678:	b7d5                	j	8000165c <reparent+0x2c>
}
    8000167a:	70a2                	ld	ra,40(sp)
    8000167c:	7402                	ld	s0,32(sp)
    8000167e:	64e2                	ld	s1,24(sp)
    80001680:	6942                	ld	s2,16(sp)
    80001682:	69a2                	ld	s3,8(sp)
    80001684:	6a02                	ld	s4,0(sp)
    80001686:	6145                	add	sp,sp,48
    80001688:	8082                	ret

000000008000168a <exit>:
{
    8000168a:	7179                	add	sp,sp,-48
    8000168c:	f406                	sd	ra,40(sp)
    8000168e:	f022                	sd	s0,32(sp)
    80001690:	ec26                	sd	s1,24(sp)
    80001692:	e84a                	sd	s2,16(sp)
    80001694:	e44e                	sd	s3,8(sp)
    80001696:	e052                	sd	s4,0(sp)
    80001698:	1800                	add	s0,sp,48
    8000169a:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000169c:	00000097          	auipc	ra,0x0
    800016a0:	80e080e7          	jalr	-2034(ra) # 80000eaa <myproc>
    800016a4:	89aa                	mv	s3,a0
  if(p == initproc)
    800016a6:	00007797          	auipc	a5,0x7
    800016aa:	23a7b783          	ld	a5,570(a5) # 800088e0 <initproc>
    800016ae:	0d050493          	add	s1,a0,208
    800016b2:	15050913          	add	s2,a0,336
    800016b6:	02a79363          	bne	a5,a0,800016dc <exit+0x52>
    panic("init exiting");
    800016ba:	00007517          	auipc	a0,0x7
    800016be:	b6650513          	add	a0,a0,-1178 # 80008220 <etext+0x220>
    800016c2:	00004097          	auipc	ra,0x4
    800016c6:	4d4080e7          	jalr	1236(ra) # 80005b96 <panic>
      fileclose(f);
    800016ca:	00002097          	auipc	ra,0x2
    800016ce:	2d8080e7          	jalr	728(ra) # 800039a2 <fileclose>
      p->ofile[fd] = 0;
    800016d2:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800016d6:	04a1                	add	s1,s1,8
    800016d8:	01248563          	beq	s1,s2,800016e2 <exit+0x58>
    if(p->ofile[fd]){
    800016dc:	6088                	ld	a0,0(s1)
    800016de:	f575                	bnez	a0,800016ca <exit+0x40>
    800016e0:	bfdd                	j	800016d6 <exit+0x4c>
  begin_op();
    800016e2:	00002097          	auipc	ra,0x2
    800016e6:	dfc080e7          	jalr	-516(ra) # 800034de <begin_op>
  iput(p->cwd);
    800016ea:	1509b503          	ld	a0,336(s3)
    800016ee:	00001097          	auipc	ra,0x1
    800016f2:	604080e7          	jalr	1540(ra) # 80002cf2 <iput>
  end_op();
    800016f6:	00002097          	auipc	ra,0x2
    800016fa:	e62080e7          	jalr	-414(ra) # 80003558 <end_op>
  p->cwd = 0;
    800016fe:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001702:	00007497          	auipc	s1,0x7
    80001706:	23648493          	add	s1,s1,566 # 80008938 <wait_lock>
    8000170a:	8526                	mv	a0,s1
    8000170c:	00005097          	auipc	ra,0x5
    80001710:	9c2080e7          	jalr	-1598(ra) # 800060ce <acquire>
  reparent(p);
    80001714:	854e                	mv	a0,s3
    80001716:	00000097          	auipc	ra,0x0
    8000171a:	f1a080e7          	jalr	-230(ra) # 80001630 <reparent>
  wakeup(p->parent);
    8000171e:	0389b503          	ld	a0,56(s3)
    80001722:	00000097          	auipc	ra,0x0
    80001726:	e98080e7          	jalr	-360(ra) # 800015ba <wakeup>
  acquire(&p->lock);
    8000172a:	854e                	mv	a0,s3
    8000172c:	00005097          	auipc	ra,0x5
    80001730:	9a2080e7          	jalr	-1630(ra) # 800060ce <acquire>
  p->xstate = status;
    80001734:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001738:	4795                	li	a5,5
    8000173a:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000173e:	8526                	mv	a0,s1
    80001740:	00005097          	auipc	ra,0x5
    80001744:	a42080e7          	jalr	-1470(ra) # 80006182 <release>
  sched();
    80001748:	00000097          	auipc	ra,0x0
    8000174c:	cfc080e7          	jalr	-772(ra) # 80001444 <sched>
  panic("zombie exit");
    80001750:	00007517          	auipc	a0,0x7
    80001754:	ae050513          	add	a0,a0,-1312 # 80008230 <etext+0x230>
    80001758:	00004097          	auipc	ra,0x4
    8000175c:	43e080e7          	jalr	1086(ra) # 80005b96 <panic>

0000000080001760 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001760:	7179                	add	sp,sp,-48
    80001762:	f406                	sd	ra,40(sp)
    80001764:	f022                	sd	s0,32(sp)
    80001766:	ec26                	sd	s1,24(sp)
    80001768:	e84a                	sd	s2,16(sp)
    8000176a:	e44e                	sd	s3,8(sp)
    8000176c:	1800                	add	s0,sp,48
    8000176e:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001770:	00007497          	auipc	s1,0x7
    80001774:	5e048493          	add	s1,s1,1504 # 80008d50 <proc>
    80001778:	0000d997          	auipc	s3,0xd
    8000177c:	fd898993          	add	s3,s3,-40 # 8000e750 <tickslock>
    acquire(&p->lock);
    80001780:	8526                	mv	a0,s1
    80001782:	00005097          	auipc	ra,0x5
    80001786:	94c080e7          	jalr	-1716(ra) # 800060ce <acquire>
    if(p->pid == pid){
    8000178a:	589c                	lw	a5,48(s1)
    8000178c:	01278d63          	beq	a5,s2,800017a6 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001790:	8526                	mv	a0,s1
    80001792:	00005097          	auipc	ra,0x5
    80001796:	9f0080e7          	jalr	-1552(ra) # 80006182 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000179a:	16848493          	add	s1,s1,360
    8000179e:	ff3491e3          	bne	s1,s3,80001780 <kill+0x20>
  }
  return -1;
    800017a2:	557d                	li	a0,-1
    800017a4:	a829                	j	800017be <kill+0x5e>
      p->killed = 1;
    800017a6:	4785                	li	a5,1
    800017a8:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800017aa:	4c98                	lw	a4,24(s1)
    800017ac:	4789                	li	a5,2
    800017ae:	00f70f63          	beq	a4,a5,800017cc <kill+0x6c>
      release(&p->lock);
    800017b2:	8526                	mv	a0,s1
    800017b4:	00005097          	auipc	ra,0x5
    800017b8:	9ce080e7          	jalr	-1586(ra) # 80006182 <release>
      return 0;
    800017bc:	4501                	li	a0,0
}
    800017be:	70a2                	ld	ra,40(sp)
    800017c0:	7402                	ld	s0,32(sp)
    800017c2:	64e2                	ld	s1,24(sp)
    800017c4:	6942                	ld	s2,16(sp)
    800017c6:	69a2                	ld	s3,8(sp)
    800017c8:	6145                	add	sp,sp,48
    800017ca:	8082                	ret
        p->state = RUNNABLE;
    800017cc:	478d                	li	a5,3
    800017ce:	cc9c                	sw	a5,24(s1)
    800017d0:	b7cd                	j	800017b2 <kill+0x52>

00000000800017d2 <setkilled>:

void
setkilled(struct proc *p)
{
    800017d2:	1101                	add	sp,sp,-32
    800017d4:	ec06                	sd	ra,24(sp)
    800017d6:	e822                	sd	s0,16(sp)
    800017d8:	e426                	sd	s1,8(sp)
    800017da:	1000                	add	s0,sp,32
    800017dc:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800017de:	00005097          	auipc	ra,0x5
    800017e2:	8f0080e7          	jalr	-1808(ra) # 800060ce <acquire>
  p->killed = 1;
    800017e6:	4785                	li	a5,1
    800017e8:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800017ea:	8526                	mv	a0,s1
    800017ec:	00005097          	auipc	ra,0x5
    800017f0:	996080e7          	jalr	-1642(ra) # 80006182 <release>
}
    800017f4:	60e2                	ld	ra,24(sp)
    800017f6:	6442                	ld	s0,16(sp)
    800017f8:	64a2                	ld	s1,8(sp)
    800017fa:	6105                	add	sp,sp,32
    800017fc:	8082                	ret

00000000800017fe <killed>:

int
killed(struct proc *p)
{
    800017fe:	1101                	add	sp,sp,-32
    80001800:	ec06                	sd	ra,24(sp)
    80001802:	e822                	sd	s0,16(sp)
    80001804:	e426                	sd	s1,8(sp)
    80001806:	e04a                	sd	s2,0(sp)
    80001808:	1000                	add	s0,sp,32
    8000180a:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    8000180c:	00005097          	auipc	ra,0x5
    80001810:	8c2080e7          	jalr	-1854(ra) # 800060ce <acquire>
  k = p->killed;
    80001814:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001818:	8526                	mv	a0,s1
    8000181a:	00005097          	auipc	ra,0x5
    8000181e:	968080e7          	jalr	-1688(ra) # 80006182 <release>
  return k;
}
    80001822:	854a                	mv	a0,s2
    80001824:	60e2                	ld	ra,24(sp)
    80001826:	6442                	ld	s0,16(sp)
    80001828:	64a2                	ld	s1,8(sp)
    8000182a:	6902                	ld	s2,0(sp)
    8000182c:	6105                	add	sp,sp,32
    8000182e:	8082                	ret

0000000080001830 <wait>:
{
    80001830:	715d                	add	sp,sp,-80
    80001832:	e486                	sd	ra,72(sp)
    80001834:	e0a2                	sd	s0,64(sp)
    80001836:	fc26                	sd	s1,56(sp)
    80001838:	f84a                	sd	s2,48(sp)
    8000183a:	f44e                	sd	s3,40(sp)
    8000183c:	f052                	sd	s4,32(sp)
    8000183e:	ec56                	sd	s5,24(sp)
    80001840:	e85a                	sd	s6,16(sp)
    80001842:	e45e                	sd	s7,8(sp)
    80001844:	e062                	sd	s8,0(sp)
    80001846:	0880                	add	s0,sp,80
    80001848:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000184a:	fffff097          	auipc	ra,0xfffff
    8000184e:	660080e7          	jalr	1632(ra) # 80000eaa <myproc>
    80001852:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001854:	00007517          	auipc	a0,0x7
    80001858:	0e450513          	add	a0,a0,228 # 80008938 <wait_lock>
    8000185c:	00005097          	auipc	ra,0x5
    80001860:	872080e7          	jalr	-1934(ra) # 800060ce <acquire>
    havekids = 0;
    80001864:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80001866:	4a15                	li	s4,5
        havekids = 1;
    80001868:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000186a:	0000d997          	auipc	s3,0xd
    8000186e:	ee698993          	add	s3,s3,-282 # 8000e750 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001872:	00007c17          	auipc	s8,0x7
    80001876:	0c6c0c13          	add	s8,s8,198 # 80008938 <wait_lock>
    8000187a:	a0d1                	j	8000193e <wait+0x10e>
          pid = pp->pid;
    8000187c:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001880:	000b0e63          	beqz	s6,8000189c <wait+0x6c>
    80001884:	4691                	li	a3,4
    80001886:	02c48613          	add	a2,s1,44
    8000188a:	85da                	mv	a1,s6
    8000188c:	05093503          	ld	a0,80(s2)
    80001890:	fffff097          	auipc	ra,0xfffff
    80001894:	2a6080e7          	jalr	678(ra) # 80000b36 <copyout>
    80001898:	04054163          	bltz	a0,800018da <wait+0xaa>
          freeproc(pp);
    8000189c:	8526                	mv	a0,s1
    8000189e:	fffff097          	auipc	ra,0xfffff
    800018a2:	7c2080e7          	jalr	1986(ra) # 80001060 <freeproc>
          release(&pp->lock);
    800018a6:	8526                	mv	a0,s1
    800018a8:	00005097          	auipc	ra,0x5
    800018ac:	8da080e7          	jalr	-1830(ra) # 80006182 <release>
          release(&wait_lock);
    800018b0:	00007517          	auipc	a0,0x7
    800018b4:	08850513          	add	a0,a0,136 # 80008938 <wait_lock>
    800018b8:	00005097          	auipc	ra,0x5
    800018bc:	8ca080e7          	jalr	-1846(ra) # 80006182 <release>
}
    800018c0:	854e                	mv	a0,s3
    800018c2:	60a6                	ld	ra,72(sp)
    800018c4:	6406                	ld	s0,64(sp)
    800018c6:	74e2                	ld	s1,56(sp)
    800018c8:	7942                	ld	s2,48(sp)
    800018ca:	79a2                	ld	s3,40(sp)
    800018cc:	7a02                	ld	s4,32(sp)
    800018ce:	6ae2                	ld	s5,24(sp)
    800018d0:	6b42                	ld	s6,16(sp)
    800018d2:	6ba2                	ld	s7,8(sp)
    800018d4:	6c02                	ld	s8,0(sp)
    800018d6:	6161                	add	sp,sp,80
    800018d8:	8082                	ret
            release(&pp->lock);
    800018da:	8526                	mv	a0,s1
    800018dc:	00005097          	auipc	ra,0x5
    800018e0:	8a6080e7          	jalr	-1882(ra) # 80006182 <release>
            release(&wait_lock);
    800018e4:	00007517          	auipc	a0,0x7
    800018e8:	05450513          	add	a0,a0,84 # 80008938 <wait_lock>
    800018ec:	00005097          	auipc	ra,0x5
    800018f0:	896080e7          	jalr	-1898(ra) # 80006182 <release>
            return -1;
    800018f4:	59fd                	li	s3,-1
    800018f6:	b7e9                	j	800018c0 <wait+0x90>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800018f8:	16848493          	add	s1,s1,360
    800018fc:	03348463          	beq	s1,s3,80001924 <wait+0xf4>
      if(pp->parent == p){
    80001900:	7c9c                	ld	a5,56(s1)
    80001902:	ff279be3          	bne	a5,s2,800018f8 <wait+0xc8>
        acquire(&pp->lock);
    80001906:	8526                	mv	a0,s1
    80001908:	00004097          	auipc	ra,0x4
    8000190c:	7c6080e7          	jalr	1990(ra) # 800060ce <acquire>
        if(pp->state == ZOMBIE){
    80001910:	4c9c                	lw	a5,24(s1)
    80001912:	f74785e3          	beq	a5,s4,8000187c <wait+0x4c>
        release(&pp->lock);
    80001916:	8526                	mv	a0,s1
    80001918:	00005097          	auipc	ra,0x5
    8000191c:	86a080e7          	jalr	-1942(ra) # 80006182 <release>
        havekids = 1;
    80001920:	8756                	mv	a4,s5
    80001922:	bfd9                	j	800018f8 <wait+0xc8>
    if(!havekids || killed(p)){
    80001924:	c31d                	beqz	a4,8000194a <wait+0x11a>
    80001926:	854a                	mv	a0,s2
    80001928:	00000097          	auipc	ra,0x0
    8000192c:	ed6080e7          	jalr	-298(ra) # 800017fe <killed>
    80001930:	ed09                	bnez	a0,8000194a <wait+0x11a>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001932:	85e2                	mv	a1,s8
    80001934:	854a                	mv	a0,s2
    80001936:	00000097          	auipc	ra,0x0
    8000193a:	c20080e7          	jalr	-992(ra) # 80001556 <sleep>
    havekids = 0;
    8000193e:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001940:	00007497          	auipc	s1,0x7
    80001944:	41048493          	add	s1,s1,1040 # 80008d50 <proc>
    80001948:	bf65                	j	80001900 <wait+0xd0>
      release(&wait_lock);
    8000194a:	00007517          	auipc	a0,0x7
    8000194e:	fee50513          	add	a0,a0,-18 # 80008938 <wait_lock>
    80001952:	00005097          	auipc	ra,0x5
    80001956:	830080e7          	jalr	-2000(ra) # 80006182 <release>
      return -1;
    8000195a:	59fd                	li	s3,-1
    8000195c:	b795                	j	800018c0 <wait+0x90>

000000008000195e <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000195e:	7179                	add	sp,sp,-48
    80001960:	f406                	sd	ra,40(sp)
    80001962:	f022                	sd	s0,32(sp)
    80001964:	ec26                	sd	s1,24(sp)
    80001966:	e84a                	sd	s2,16(sp)
    80001968:	e44e                	sd	s3,8(sp)
    8000196a:	e052                	sd	s4,0(sp)
    8000196c:	1800                	add	s0,sp,48
    8000196e:	84aa                	mv	s1,a0
    80001970:	892e                	mv	s2,a1
    80001972:	89b2                	mv	s3,a2
    80001974:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001976:	fffff097          	auipc	ra,0xfffff
    8000197a:	534080e7          	jalr	1332(ra) # 80000eaa <myproc>
  if(user_dst){
    8000197e:	c08d                	beqz	s1,800019a0 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001980:	86d2                	mv	a3,s4
    80001982:	864e                	mv	a2,s3
    80001984:	85ca                	mv	a1,s2
    80001986:	6928                	ld	a0,80(a0)
    80001988:	fffff097          	auipc	ra,0xfffff
    8000198c:	1ae080e7          	jalr	430(ra) # 80000b36 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001990:	70a2                	ld	ra,40(sp)
    80001992:	7402                	ld	s0,32(sp)
    80001994:	64e2                	ld	s1,24(sp)
    80001996:	6942                	ld	s2,16(sp)
    80001998:	69a2                	ld	s3,8(sp)
    8000199a:	6a02                	ld	s4,0(sp)
    8000199c:	6145                	add	sp,sp,48
    8000199e:	8082                	ret
    memmove((char *)dst, src, len);
    800019a0:	000a061b          	sext.w	a2,s4
    800019a4:	85ce                	mv	a1,s3
    800019a6:	854a                	mv	a0,s2
    800019a8:	fffff097          	auipc	ra,0xfffff
    800019ac:	82e080e7          	jalr	-2002(ra) # 800001d6 <memmove>
    return 0;
    800019b0:	8526                	mv	a0,s1
    800019b2:	bff9                	j	80001990 <either_copyout+0x32>

00000000800019b4 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800019b4:	7179                	add	sp,sp,-48
    800019b6:	f406                	sd	ra,40(sp)
    800019b8:	f022                	sd	s0,32(sp)
    800019ba:	ec26                	sd	s1,24(sp)
    800019bc:	e84a                	sd	s2,16(sp)
    800019be:	e44e                	sd	s3,8(sp)
    800019c0:	e052                	sd	s4,0(sp)
    800019c2:	1800                	add	s0,sp,48
    800019c4:	892a                	mv	s2,a0
    800019c6:	84ae                	mv	s1,a1
    800019c8:	89b2                	mv	s3,a2
    800019ca:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800019cc:	fffff097          	auipc	ra,0xfffff
    800019d0:	4de080e7          	jalr	1246(ra) # 80000eaa <myproc>
  if(user_src){
    800019d4:	c08d                	beqz	s1,800019f6 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    800019d6:	86d2                	mv	a3,s4
    800019d8:	864e                	mv	a2,s3
    800019da:	85ca                	mv	a1,s2
    800019dc:	6928                	ld	a0,80(a0)
    800019de:	fffff097          	auipc	ra,0xfffff
    800019e2:	218080e7          	jalr	536(ra) # 80000bf6 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800019e6:	70a2                	ld	ra,40(sp)
    800019e8:	7402                	ld	s0,32(sp)
    800019ea:	64e2                	ld	s1,24(sp)
    800019ec:	6942                	ld	s2,16(sp)
    800019ee:	69a2                	ld	s3,8(sp)
    800019f0:	6a02                	ld	s4,0(sp)
    800019f2:	6145                	add	sp,sp,48
    800019f4:	8082                	ret
    memmove(dst, (char*)src, len);
    800019f6:	000a061b          	sext.w	a2,s4
    800019fa:	85ce                	mv	a1,s3
    800019fc:	854a                	mv	a0,s2
    800019fe:	ffffe097          	auipc	ra,0xffffe
    80001a02:	7d8080e7          	jalr	2008(ra) # 800001d6 <memmove>
    return 0;
    80001a06:	8526                	mv	a0,s1
    80001a08:	bff9                	j	800019e6 <either_copyin+0x32>

0000000080001a0a <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001a0a:	715d                	add	sp,sp,-80
    80001a0c:	e486                	sd	ra,72(sp)
    80001a0e:	e0a2                	sd	s0,64(sp)
    80001a10:	fc26                	sd	s1,56(sp)
    80001a12:	f84a                	sd	s2,48(sp)
    80001a14:	f44e                	sd	s3,40(sp)
    80001a16:	f052                	sd	s4,32(sp)
    80001a18:	ec56                	sd	s5,24(sp)
    80001a1a:	e85a                	sd	s6,16(sp)
    80001a1c:	e45e                	sd	s7,8(sp)
    80001a1e:	0880                	add	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001a20:	00006517          	auipc	a0,0x6
    80001a24:	62850513          	add	a0,a0,1576 # 80008048 <etext+0x48>
    80001a28:	00004097          	auipc	ra,0x4
    80001a2c:	1b8080e7          	jalr	440(ra) # 80005be0 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a30:	00007497          	auipc	s1,0x7
    80001a34:	47848493          	add	s1,s1,1144 # 80008ea8 <proc+0x158>
    80001a38:	0000d917          	auipc	s2,0xd
    80001a3c:	e7090913          	add	s2,s2,-400 # 8000e8a8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a40:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001a42:	00006997          	auipc	s3,0x6
    80001a46:	7fe98993          	add	s3,s3,2046 # 80008240 <etext+0x240>
    printf("%d %s %s", p->pid, state, p->name);
    80001a4a:	00006a97          	auipc	s5,0x6
    80001a4e:	7fea8a93          	add	s5,s5,2046 # 80008248 <etext+0x248>
    printf("\n");
    80001a52:	00006a17          	auipc	s4,0x6
    80001a56:	5f6a0a13          	add	s4,s4,1526 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a5a:	00007b97          	auipc	s7,0x7
    80001a5e:	82eb8b93          	add	s7,s7,-2002 # 80008288 <states.0>
    80001a62:	a00d                	j	80001a84 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a64:	ed86a583          	lw	a1,-296(a3)
    80001a68:	8556                	mv	a0,s5
    80001a6a:	00004097          	auipc	ra,0x4
    80001a6e:	176080e7          	jalr	374(ra) # 80005be0 <printf>
    printf("\n");
    80001a72:	8552                	mv	a0,s4
    80001a74:	00004097          	auipc	ra,0x4
    80001a78:	16c080e7          	jalr	364(ra) # 80005be0 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a7c:	16848493          	add	s1,s1,360
    80001a80:	03248263          	beq	s1,s2,80001aa4 <procdump+0x9a>
    if(p->state == UNUSED)
    80001a84:	86a6                	mv	a3,s1
    80001a86:	ec04a783          	lw	a5,-320(s1)
    80001a8a:	dbed                	beqz	a5,80001a7c <procdump+0x72>
      state = "???";
    80001a8c:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a8e:	fcfb6be3          	bltu	s6,a5,80001a64 <procdump+0x5a>
    80001a92:	02079713          	sll	a4,a5,0x20
    80001a96:	01d75793          	srl	a5,a4,0x1d
    80001a9a:	97de                	add	a5,a5,s7
    80001a9c:	6390                	ld	a2,0(a5)
    80001a9e:	f279                	bnez	a2,80001a64 <procdump+0x5a>
      state = "???";
    80001aa0:	864e                	mv	a2,s3
    80001aa2:	b7c9                	j	80001a64 <procdump+0x5a>
  }
}
    80001aa4:	60a6                	ld	ra,72(sp)
    80001aa6:	6406                	ld	s0,64(sp)
    80001aa8:	74e2                	ld	s1,56(sp)
    80001aaa:	7942                	ld	s2,48(sp)
    80001aac:	79a2                	ld	s3,40(sp)
    80001aae:	7a02                	ld	s4,32(sp)
    80001ab0:	6ae2                	ld	s5,24(sp)
    80001ab2:	6b42                	ld	s6,16(sp)
    80001ab4:	6ba2                	ld	s7,8(sp)
    80001ab6:	6161                	add	sp,sp,80
    80001ab8:	8082                	ret

0000000080001aba <swtch>:
    80001aba:	00153023          	sd	ra,0(a0)
    80001abe:	00253423          	sd	sp,8(a0)
    80001ac2:	e900                	sd	s0,16(a0)
    80001ac4:	ed04                	sd	s1,24(a0)
    80001ac6:	03253023          	sd	s2,32(a0)
    80001aca:	03353423          	sd	s3,40(a0)
    80001ace:	03453823          	sd	s4,48(a0)
    80001ad2:	03553c23          	sd	s5,56(a0)
    80001ad6:	05653023          	sd	s6,64(a0)
    80001ada:	05753423          	sd	s7,72(a0)
    80001ade:	05853823          	sd	s8,80(a0)
    80001ae2:	05953c23          	sd	s9,88(a0)
    80001ae6:	07a53023          	sd	s10,96(a0)
    80001aea:	07b53423          	sd	s11,104(a0)
    80001aee:	0005b083          	ld	ra,0(a1)
    80001af2:	0085b103          	ld	sp,8(a1)
    80001af6:	6980                	ld	s0,16(a1)
    80001af8:	6d84                	ld	s1,24(a1)
    80001afa:	0205b903          	ld	s2,32(a1)
    80001afe:	0285b983          	ld	s3,40(a1)
    80001b02:	0305ba03          	ld	s4,48(a1)
    80001b06:	0385ba83          	ld	s5,56(a1)
    80001b0a:	0405bb03          	ld	s6,64(a1)
    80001b0e:	0485bb83          	ld	s7,72(a1)
    80001b12:	0505bc03          	ld	s8,80(a1)
    80001b16:	0585bc83          	ld	s9,88(a1)
    80001b1a:	0605bd03          	ld	s10,96(a1)
    80001b1e:	0685bd83          	ld	s11,104(a1)
    80001b22:	8082                	ret

0000000080001b24 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001b24:	1141                	add	sp,sp,-16
    80001b26:	e406                	sd	ra,8(sp)
    80001b28:	e022                	sd	s0,0(sp)
    80001b2a:	0800                	add	s0,sp,16
  initlock(&tickslock, "time");
    80001b2c:	00006597          	auipc	a1,0x6
    80001b30:	78c58593          	add	a1,a1,1932 # 800082b8 <states.0+0x30>
    80001b34:	0000d517          	auipc	a0,0xd
    80001b38:	c1c50513          	add	a0,a0,-996 # 8000e750 <tickslock>
    80001b3c:	00004097          	auipc	ra,0x4
    80001b40:	502080e7          	jalr	1282(ra) # 8000603e <initlock>
}
    80001b44:	60a2                	ld	ra,8(sp)
    80001b46:	6402                	ld	s0,0(sp)
    80001b48:	0141                	add	sp,sp,16
    80001b4a:	8082                	ret

0000000080001b4c <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001b4c:	1141                	add	sp,sp,-16
    80001b4e:	e422                	sd	s0,8(sp)
    80001b50:	0800                	add	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b52:	00003797          	auipc	a5,0x3
    80001b56:	47e78793          	add	a5,a5,1150 # 80004fd0 <kernelvec>
    80001b5a:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001b5e:	6422                	ld	s0,8(sp)
    80001b60:	0141                	add	sp,sp,16
    80001b62:	8082                	ret

0000000080001b64 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b64:	1141                	add	sp,sp,-16
    80001b66:	e406                	sd	ra,8(sp)
    80001b68:	e022                	sd	s0,0(sp)
    80001b6a:	0800                	add	s0,sp,16
  struct proc *p = myproc();
    80001b6c:	fffff097          	auipc	ra,0xfffff
    80001b70:	33e080e7          	jalr	830(ra) # 80000eaa <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b74:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b78:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b7a:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001b7e:	00005697          	auipc	a3,0x5
    80001b82:	48268693          	add	a3,a3,1154 # 80007000 <_trampoline>
    80001b86:	00005717          	auipc	a4,0x5
    80001b8a:	47a70713          	add	a4,a4,1146 # 80007000 <_trampoline>
    80001b8e:	8f15                	sub	a4,a4,a3
    80001b90:	040007b7          	lui	a5,0x4000
    80001b94:	17fd                	add	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001b96:	07b2                	sll	a5,a5,0xc
    80001b98:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b9a:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b9e:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001ba0:	18002673          	csrr	a2,satp
    80001ba4:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001ba6:	6d30                	ld	a2,88(a0)
    80001ba8:	6138                	ld	a4,64(a0)
    80001baa:	6585                	lui	a1,0x1
    80001bac:	972e                	add	a4,a4,a1
    80001bae:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001bb0:	6d38                	ld	a4,88(a0)
    80001bb2:	00000617          	auipc	a2,0x0
    80001bb6:	13460613          	add	a2,a2,308 # 80001ce6 <usertrap>
    80001bba:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001bbc:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001bbe:	8612                	mv	a2,tp
    80001bc0:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bc2:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001bc6:	eff77713          	and	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001bca:	02076713          	or	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bce:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001bd2:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001bd4:	6f18                	ld	a4,24(a4)
    80001bd6:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001bda:	6928                	ld	a0,80(a0)
    80001bdc:	8131                	srl	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001bde:	00005717          	auipc	a4,0x5
    80001be2:	4be70713          	add	a4,a4,1214 # 8000709c <userret>
    80001be6:	8f15                	sub	a4,a4,a3
    80001be8:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001bea:	577d                	li	a4,-1
    80001bec:	177e                	sll	a4,a4,0x3f
    80001bee:	8d59                	or	a0,a0,a4
    80001bf0:	9782                	jalr	a5
}
    80001bf2:	60a2                	ld	ra,8(sp)
    80001bf4:	6402                	ld	s0,0(sp)
    80001bf6:	0141                	add	sp,sp,16
    80001bf8:	8082                	ret

0000000080001bfa <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001bfa:	1101                	add	sp,sp,-32
    80001bfc:	ec06                	sd	ra,24(sp)
    80001bfe:	e822                	sd	s0,16(sp)
    80001c00:	e426                	sd	s1,8(sp)
    80001c02:	1000                	add	s0,sp,32
  acquire(&tickslock);
    80001c04:	0000d497          	auipc	s1,0xd
    80001c08:	b4c48493          	add	s1,s1,-1204 # 8000e750 <tickslock>
    80001c0c:	8526                	mv	a0,s1
    80001c0e:	00004097          	auipc	ra,0x4
    80001c12:	4c0080e7          	jalr	1216(ra) # 800060ce <acquire>
  ticks++;
    80001c16:	00007517          	auipc	a0,0x7
    80001c1a:	cd250513          	add	a0,a0,-814 # 800088e8 <ticks>
    80001c1e:	411c                	lw	a5,0(a0)
    80001c20:	2785                	addw	a5,a5,1
    80001c22:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001c24:	00000097          	auipc	ra,0x0
    80001c28:	996080e7          	jalr	-1642(ra) # 800015ba <wakeup>
  release(&tickslock);
    80001c2c:	8526                	mv	a0,s1
    80001c2e:	00004097          	auipc	ra,0x4
    80001c32:	554080e7          	jalr	1364(ra) # 80006182 <release>
}
    80001c36:	60e2                	ld	ra,24(sp)
    80001c38:	6442                	ld	s0,16(sp)
    80001c3a:	64a2                	ld	s1,8(sp)
    80001c3c:	6105                	add	sp,sp,32
    80001c3e:	8082                	ret

0000000080001c40 <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c40:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001c44:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80001c46:	0807df63          	bgez	a5,80001ce4 <devintr+0xa4>
{
    80001c4a:	1101                	add	sp,sp,-32
    80001c4c:	ec06                	sd	ra,24(sp)
    80001c4e:	e822                	sd	s0,16(sp)
    80001c50:	e426                	sd	s1,8(sp)
    80001c52:	1000                	add	s0,sp,32
     (scause & 0xff) == 9){
    80001c54:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80001c58:	46a5                	li	a3,9
    80001c5a:	00d70d63          	beq	a4,a3,80001c74 <devintr+0x34>
  } else if(scause == 0x8000000000000001L){
    80001c5e:	577d                	li	a4,-1
    80001c60:	177e                	sll	a4,a4,0x3f
    80001c62:	0705                	add	a4,a4,1
    return 0;
    80001c64:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001c66:	04e78e63          	beq	a5,a4,80001cc2 <devintr+0x82>
  }
}
    80001c6a:	60e2                	ld	ra,24(sp)
    80001c6c:	6442                	ld	s0,16(sp)
    80001c6e:	64a2                	ld	s1,8(sp)
    80001c70:	6105                	add	sp,sp,32
    80001c72:	8082                	ret
    int irq = plic_claim();
    80001c74:	00003097          	auipc	ra,0x3
    80001c78:	464080e7          	jalr	1124(ra) # 800050d8 <plic_claim>
    80001c7c:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c7e:	47a9                	li	a5,10
    80001c80:	02f50763          	beq	a0,a5,80001cae <devintr+0x6e>
    } else if(irq == VIRTIO0_IRQ){
    80001c84:	4785                	li	a5,1
    80001c86:	02f50963          	beq	a0,a5,80001cb8 <devintr+0x78>
    return 1;
    80001c8a:	4505                	li	a0,1
    } else if(irq){
    80001c8c:	dcf9                	beqz	s1,80001c6a <devintr+0x2a>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c8e:	85a6                	mv	a1,s1
    80001c90:	00006517          	auipc	a0,0x6
    80001c94:	63050513          	add	a0,a0,1584 # 800082c0 <states.0+0x38>
    80001c98:	00004097          	auipc	ra,0x4
    80001c9c:	f48080e7          	jalr	-184(ra) # 80005be0 <printf>
      plic_complete(irq);
    80001ca0:	8526                	mv	a0,s1
    80001ca2:	00003097          	auipc	ra,0x3
    80001ca6:	45a080e7          	jalr	1114(ra) # 800050fc <plic_complete>
    return 1;
    80001caa:	4505                	li	a0,1
    80001cac:	bf7d                	j	80001c6a <devintr+0x2a>
      uartintr();
    80001cae:	00004097          	auipc	ra,0x4
    80001cb2:	340080e7          	jalr	832(ra) # 80005fee <uartintr>
    if(irq)
    80001cb6:	b7ed                	j	80001ca0 <devintr+0x60>
      virtio_disk_intr();
    80001cb8:	00004097          	auipc	ra,0x4
    80001cbc:	90a080e7          	jalr	-1782(ra) # 800055c2 <virtio_disk_intr>
    if(irq)
    80001cc0:	b7c5                	j	80001ca0 <devintr+0x60>
    if(cpuid() == 0){
    80001cc2:	fffff097          	auipc	ra,0xfffff
    80001cc6:	1bc080e7          	jalr	444(ra) # 80000e7e <cpuid>
    80001cca:	c901                	beqz	a0,80001cda <devintr+0x9a>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001ccc:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001cd0:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001cd2:	14479073          	csrw	sip,a5
    return 2;
    80001cd6:	4509                	li	a0,2
    80001cd8:	bf49                	j	80001c6a <devintr+0x2a>
      clockintr();
    80001cda:	00000097          	auipc	ra,0x0
    80001cde:	f20080e7          	jalr	-224(ra) # 80001bfa <clockintr>
    80001ce2:	b7ed                	j	80001ccc <devintr+0x8c>
}
    80001ce4:	8082                	ret

0000000080001ce6 <usertrap>:
{
    80001ce6:	1101                	add	sp,sp,-32
    80001ce8:	ec06                	sd	ra,24(sp)
    80001cea:	e822                	sd	s0,16(sp)
    80001cec:	e426                	sd	s1,8(sp)
    80001cee:	e04a                	sd	s2,0(sp)
    80001cf0:	1000                	add	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cf2:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001cf6:	1007f793          	and	a5,a5,256
    80001cfa:	e3b1                	bnez	a5,80001d3e <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cfc:	00003797          	auipc	a5,0x3
    80001d00:	2d478793          	add	a5,a5,724 # 80004fd0 <kernelvec>
    80001d04:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001d08:	fffff097          	auipc	ra,0xfffff
    80001d0c:	1a2080e7          	jalr	418(ra) # 80000eaa <myproc>
    80001d10:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001d12:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d14:	14102773          	csrr	a4,sepc
    80001d18:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d1a:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001d1e:	47a1                	li	a5,8
    80001d20:	02f70763          	beq	a4,a5,80001d4e <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80001d24:	00000097          	auipc	ra,0x0
    80001d28:	f1c080e7          	jalr	-228(ra) # 80001c40 <devintr>
    80001d2c:	892a                	mv	s2,a0
    80001d2e:	c151                	beqz	a0,80001db2 <usertrap+0xcc>
  if(killed(p))
    80001d30:	8526                	mv	a0,s1
    80001d32:	00000097          	auipc	ra,0x0
    80001d36:	acc080e7          	jalr	-1332(ra) # 800017fe <killed>
    80001d3a:	c929                	beqz	a0,80001d8c <usertrap+0xa6>
    80001d3c:	a099                	j	80001d82 <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80001d3e:	00006517          	auipc	a0,0x6
    80001d42:	5a250513          	add	a0,a0,1442 # 800082e0 <states.0+0x58>
    80001d46:	00004097          	auipc	ra,0x4
    80001d4a:	e50080e7          	jalr	-432(ra) # 80005b96 <panic>
    if(killed(p))
    80001d4e:	00000097          	auipc	ra,0x0
    80001d52:	ab0080e7          	jalr	-1360(ra) # 800017fe <killed>
    80001d56:	e921                	bnez	a0,80001da6 <usertrap+0xc0>
    p->trapframe->epc += 4;
    80001d58:	6cb8                	ld	a4,88(s1)
    80001d5a:	6f1c                	ld	a5,24(a4)
    80001d5c:	0791                	add	a5,a5,4
    80001d5e:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d60:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d64:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d68:	10079073          	csrw	sstatus,a5
    syscall();
    80001d6c:	00000097          	auipc	ra,0x0
    80001d70:	2d4080e7          	jalr	724(ra) # 80002040 <syscall>
  if(killed(p))
    80001d74:	8526                	mv	a0,s1
    80001d76:	00000097          	auipc	ra,0x0
    80001d7a:	a88080e7          	jalr	-1400(ra) # 800017fe <killed>
    80001d7e:	c911                	beqz	a0,80001d92 <usertrap+0xac>
    80001d80:	4901                	li	s2,0
    exit(-1);
    80001d82:	557d                	li	a0,-1
    80001d84:	00000097          	auipc	ra,0x0
    80001d88:	906080e7          	jalr	-1786(ra) # 8000168a <exit>
  if(which_dev == 2)
    80001d8c:	4789                	li	a5,2
    80001d8e:	04f90f63          	beq	s2,a5,80001dec <usertrap+0x106>
  usertrapret();
    80001d92:	00000097          	auipc	ra,0x0
    80001d96:	dd2080e7          	jalr	-558(ra) # 80001b64 <usertrapret>
}
    80001d9a:	60e2                	ld	ra,24(sp)
    80001d9c:	6442                	ld	s0,16(sp)
    80001d9e:	64a2                	ld	s1,8(sp)
    80001da0:	6902                	ld	s2,0(sp)
    80001da2:	6105                	add	sp,sp,32
    80001da4:	8082                	ret
      exit(-1);
    80001da6:	557d                	li	a0,-1
    80001da8:	00000097          	auipc	ra,0x0
    80001dac:	8e2080e7          	jalr	-1822(ra) # 8000168a <exit>
    80001db0:	b765                	j	80001d58 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001db2:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001db6:	5890                	lw	a2,48(s1)
    80001db8:	00006517          	auipc	a0,0x6
    80001dbc:	54850513          	add	a0,a0,1352 # 80008300 <states.0+0x78>
    80001dc0:	00004097          	auipc	ra,0x4
    80001dc4:	e20080e7          	jalr	-480(ra) # 80005be0 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001dc8:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001dcc:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001dd0:	00006517          	auipc	a0,0x6
    80001dd4:	56050513          	add	a0,a0,1376 # 80008330 <states.0+0xa8>
    80001dd8:	00004097          	auipc	ra,0x4
    80001ddc:	e08080e7          	jalr	-504(ra) # 80005be0 <printf>
    setkilled(p);
    80001de0:	8526                	mv	a0,s1
    80001de2:	00000097          	auipc	ra,0x0
    80001de6:	9f0080e7          	jalr	-1552(ra) # 800017d2 <setkilled>
    80001dea:	b769                	j	80001d74 <usertrap+0x8e>
    yield();
    80001dec:	fffff097          	auipc	ra,0xfffff
    80001df0:	72e080e7          	jalr	1838(ra) # 8000151a <yield>
    80001df4:	bf79                	j	80001d92 <usertrap+0xac>

0000000080001df6 <kerneltrap>:
{
    80001df6:	7179                	add	sp,sp,-48
    80001df8:	f406                	sd	ra,40(sp)
    80001dfa:	f022                	sd	s0,32(sp)
    80001dfc:	ec26                	sd	s1,24(sp)
    80001dfe:	e84a                	sd	s2,16(sp)
    80001e00:	e44e                	sd	s3,8(sp)
    80001e02:	1800                	add	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e04:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e08:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e0c:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001e10:	1004f793          	and	a5,s1,256
    80001e14:	cb85                	beqz	a5,80001e44 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e16:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e1a:	8b89                	and	a5,a5,2
  if(intr_get() != 0)
    80001e1c:	ef85                	bnez	a5,80001e54 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001e1e:	00000097          	auipc	ra,0x0
    80001e22:	e22080e7          	jalr	-478(ra) # 80001c40 <devintr>
    80001e26:	cd1d                	beqz	a0,80001e64 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e28:	4789                	li	a5,2
    80001e2a:	06f50a63          	beq	a0,a5,80001e9e <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001e2e:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e32:	10049073          	csrw	sstatus,s1
}
    80001e36:	70a2                	ld	ra,40(sp)
    80001e38:	7402                	ld	s0,32(sp)
    80001e3a:	64e2                	ld	s1,24(sp)
    80001e3c:	6942                	ld	s2,16(sp)
    80001e3e:	69a2                	ld	s3,8(sp)
    80001e40:	6145                	add	sp,sp,48
    80001e42:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001e44:	00006517          	auipc	a0,0x6
    80001e48:	50c50513          	add	a0,a0,1292 # 80008350 <states.0+0xc8>
    80001e4c:	00004097          	auipc	ra,0x4
    80001e50:	d4a080e7          	jalr	-694(ra) # 80005b96 <panic>
    panic("kerneltrap: interrupts enabled");
    80001e54:	00006517          	auipc	a0,0x6
    80001e58:	52450513          	add	a0,a0,1316 # 80008378 <states.0+0xf0>
    80001e5c:	00004097          	auipc	ra,0x4
    80001e60:	d3a080e7          	jalr	-710(ra) # 80005b96 <panic>
    printf("scause %p\n", scause);
    80001e64:	85ce                	mv	a1,s3
    80001e66:	00006517          	auipc	a0,0x6
    80001e6a:	53250513          	add	a0,a0,1330 # 80008398 <states.0+0x110>
    80001e6e:	00004097          	auipc	ra,0x4
    80001e72:	d72080e7          	jalr	-654(ra) # 80005be0 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e76:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e7a:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e7e:	00006517          	auipc	a0,0x6
    80001e82:	52a50513          	add	a0,a0,1322 # 800083a8 <states.0+0x120>
    80001e86:	00004097          	auipc	ra,0x4
    80001e8a:	d5a080e7          	jalr	-678(ra) # 80005be0 <printf>
    panic("kerneltrap");
    80001e8e:	00006517          	auipc	a0,0x6
    80001e92:	53250513          	add	a0,a0,1330 # 800083c0 <states.0+0x138>
    80001e96:	00004097          	auipc	ra,0x4
    80001e9a:	d00080e7          	jalr	-768(ra) # 80005b96 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e9e:	fffff097          	auipc	ra,0xfffff
    80001ea2:	00c080e7          	jalr	12(ra) # 80000eaa <myproc>
    80001ea6:	d541                	beqz	a0,80001e2e <kerneltrap+0x38>
    80001ea8:	fffff097          	auipc	ra,0xfffff
    80001eac:	002080e7          	jalr	2(ra) # 80000eaa <myproc>
    80001eb0:	4d18                	lw	a4,24(a0)
    80001eb2:	4791                	li	a5,4
    80001eb4:	f6f71de3          	bne	a4,a5,80001e2e <kerneltrap+0x38>
    yield();
    80001eb8:	fffff097          	auipc	ra,0xfffff
    80001ebc:	662080e7          	jalr	1634(ra) # 8000151a <yield>
    80001ec0:	b7bd                	j	80001e2e <kerneltrap+0x38>

0000000080001ec2 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001ec2:	1101                	add	sp,sp,-32
    80001ec4:	ec06                	sd	ra,24(sp)
    80001ec6:	e822                	sd	s0,16(sp)
    80001ec8:	e426                	sd	s1,8(sp)
    80001eca:	1000                	add	s0,sp,32
    80001ecc:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001ece:	fffff097          	auipc	ra,0xfffff
    80001ed2:	fdc080e7          	jalr	-36(ra) # 80000eaa <myproc>
  switch (n) {
    80001ed6:	4795                	li	a5,5
    80001ed8:	0497e163          	bltu	a5,s1,80001f1a <argraw+0x58>
    80001edc:	048a                	sll	s1,s1,0x2
    80001ede:	00006717          	auipc	a4,0x6
    80001ee2:	51a70713          	add	a4,a4,1306 # 800083f8 <states.0+0x170>
    80001ee6:	94ba                	add	s1,s1,a4
    80001ee8:	409c                	lw	a5,0(s1)
    80001eea:	97ba                	add	a5,a5,a4
    80001eec:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001eee:	6d3c                	ld	a5,88(a0)
    80001ef0:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001ef2:	60e2                	ld	ra,24(sp)
    80001ef4:	6442                	ld	s0,16(sp)
    80001ef6:	64a2                	ld	s1,8(sp)
    80001ef8:	6105                	add	sp,sp,32
    80001efa:	8082                	ret
    return p->trapframe->a1;
    80001efc:	6d3c                	ld	a5,88(a0)
    80001efe:	7fa8                	ld	a0,120(a5)
    80001f00:	bfcd                	j	80001ef2 <argraw+0x30>
    return p->trapframe->a2;
    80001f02:	6d3c                	ld	a5,88(a0)
    80001f04:	63c8                	ld	a0,128(a5)
    80001f06:	b7f5                	j	80001ef2 <argraw+0x30>
    return p->trapframe->a3;
    80001f08:	6d3c                	ld	a5,88(a0)
    80001f0a:	67c8                	ld	a0,136(a5)
    80001f0c:	b7dd                	j	80001ef2 <argraw+0x30>
    return p->trapframe->a4;
    80001f0e:	6d3c                	ld	a5,88(a0)
    80001f10:	6bc8                	ld	a0,144(a5)
    80001f12:	b7c5                	j	80001ef2 <argraw+0x30>
    return p->trapframe->a5;
    80001f14:	6d3c                	ld	a5,88(a0)
    80001f16:	6fc8                	ld	a0,152(a5)
    80001f18:	bfe9                	j	80001ef2 <argraw+0x30>
  panic("argraw");
    80001f1a:	00006517          	auipc	a0,0x6
    80001f1e:	4b650513          	add	a0,a0,1206 # 800083d0 <states.0+0x148>
    80001f22:	00004097          	auipc	ra,0x4
    80001f26:	c74080e7          	jalr	-908(ra) # 80005b96 <panic>

0000000080001f2a <fetchaddr>:
{
    80001f2a:	1101                	add	sp,sp,-32
    80001f2c:	ec06                	sd	ra,24(sp)
    80001f2e:	e822                	sd	s0,16(sp)
    80001f30:	e426                	sd	s1,8(sp)
    80001f32:	e04a                	sd	s2,0(sp)
    80001f34:	1000                	add	s0,sp,32
    80001f36:	84aa                	mv	s1,a0
    80001f38:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f3a:	fffff097          	auipc	ra,0xfffff
    80001f3e:	f70080e7          	jalr	-144(ra) # 80000eaa <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001f42:	653c                	ld	a5,72(a0)
    80001f44:	02f4f863          	bgeu	s1,a5,80001f74 <fetchaddr+0x4a>
    80001f48:	00848713          	add	a4,s1,8
    80001f4c:	02e7e663          	bltu	a5,a4,80001f78 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001f50:	46a1                	li	a3,8
    80001f52:	8626                	mv	a2,s1
    80001f54:	85ca                	mv	a1,s2
    80001f56:	6928                	ld	a0,80(a0)
    80001f58:	fffff097          	auipc	ra,0xfffff
    80001f5c:	c9e080e7          	jalr	-866(ra) # 80000bf6 <copyin>
    80001f60:	00a03533          	snez	a0,a0
    80001f64:	40a00533          	neg	a0,a0
}
    80001f68:	60e2                	ld	ra,24(sp)
    80001f6a:	6442                	ld	s0,16(sp)
    80001f6c:	64a2                	ld	s1,8(sp)
    80001f6e:	6902                	ld	s2,0(sp)
    80001f70:	6105                	add	sp,sp,32
    80001f72:	8082                	ret
    return -1;
    80001f74:	557d                	li	a0,-1
    80001f76:	bfcd                	j	80001f68 <fetchaddr+0x3e>
    80001f78:	557d                	li	a0,-1
    80001f7a:	b7fd                	j	80001f68 <fetchaddr+0x3e>

0000000080001f7c <fetchstr>:
{
    80001f7c:	7179                	add	sp,sp,-48
    80001f7e:	f406                	sd	ra,40(sp)
    80001f80:	f022                	sd	s0,32(sp)
    80001f82:	ec26                	sd	s1,24(sp)
    80001f84:	e84a                	sd	s2,16(sp)
    80001f86:	e44e                	sd	s3,8(sp)
    80001f88:	1800                	add	s0,sp,48
    80001f8a:	892a                	mv	s2,a0
    80001f8c:	84ae                	mv	s1,a1
    80001f8e:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f90:	fffff097          	auipc	ra,0xfffff
    80001f94:	f1a080e7          	jalr	-230(ra) # 80000eaa <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001f98:	86ce                	mv	a3,s3
    80001f9a:	864a                	mv	a2,s2
    80001f9c:	85a6                	mv	a1,s1
    80001f9e:	6928                	ld	a0,80(a0)
    80001fa0:	fffff097          	auipc	ra,0xfffff
    80001fa4:	ce4080e7          	jalr	-796(ra) # 80000c84 <copyinstr>
    80001fa8:	00054e63          	bltz	a0,80001fc4 <fetchstr+0x48>
  return strlen(buf);
    80001fac:	8526                	mv	a0,s1
    80001fae:	ffffe097          	auipc	ra,0xffffe
    80001fb2:	346080e7          	jalr	838(ra) # 800002f4 <strlen>
}
    80001fb6:	70a2                	ld	ra,40(sp)
    80001fb8:	7402                	ld	s0,32(sp)
    80001fba:	64e2                	ld	s1,24(sp)
    80001fbc:	6942                	ld	s2,16(sp)
    80001fbe:	69a2                	ld	s3,8(sp)
    80001fc0:	6145                	add	sp,sp,48
    80001fc2:	8082                	ret
    return -1;
    80001fc4:	557d                	li	a0,-1
    80001fc6:	bfc5                	j	80001fb6 <fetchstr+0x3a>

0000000080001fc8 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001fc8:	1101                	add	sp,sp,-32
    80001fca:	ec06                	sd	ra,24(sp)
    80001fcc:	e822                	sd	s0,16(sp)
    80001fce:	e426                	sd	s1,8(sp)
    80001fd0:	1000                	add	s0,sp,32
    80001fd2:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001fd4:	00000097          	auipc	ra,0x0
    80001fd8:	eee080e7          	jalr	-274(ra) # 80001ec2 <argraw>
    80001fdc:	c088                	sw	a0,0(s1)
}
    80001fde:	60e2                	ld	ra,24(sp)
    80001fe0:	6442                	ld	s0,16(sp)
    80001fe2:	64a2                	ld	s1,8(sp)
    80001fe4:	6105                	add	sp,sp,32
    80001fe6:	8082                	ret

0000000080001fe8 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001fe8:	1101                	add	sp,sp,-32
    80001fea:	ec06                	sd	ra,24(sp)
    80001fec:	e822                	sd	s0,16(sp)
    80001fee:	e426                	sd	s1,8(sp)
    80001ff0:	1000                	add	s0,sp,32
    80001ff2:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001ff4:	00000097          	auipc	ra,0x0
    80001ff8:	ece080e7          	jalr	-306(ra) # 80001ec2 <argraw>
    80001ffc:	e088                	sd	a0,0(s1)
}
    80001ffe:	60e2                	ld	ra,24(sp)
    80002000:	6442                	ld	s0,16(sp)
    80002002:	64a2                	ld	s1,8(sp)
    80002004:	6105                	add	sp,sp,32
    80002006:	8082                	ret

0000000080002008 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002008:	7179                	add	sp,sp,-48
    8000200a:	f406                	sd	ra,40(sp)
    8000200c:	f022                	sd	s0,32(sp)
    8000200e:	ec26                	sd	s1,24(sp)
    80002010:	e84a                	sd	s2,16(sp)
    80002012:	1800                	add	s0,sp,48
    80002014:	84ae                	mv	s1,a1
    80002016:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002018:	fd840593          	add	a1,s0,-40
    8000201c:	00000097          	auipc	ra,0x0
    80002020:	fcc080e7          	jalr	-52(ra) # 80001fe8 <argaddr>
  return fetchstr(addr, buf, max);
    80002024:	864a                	mv	a2,s2
    80002026:	85a6                	mv	a1,s1
    80002028:	fd843503          	ld	a0,-40(s0)
    8000202c:	00000097          	auipc	ra,0x0
    80002030:	f50080e7          	jalr	-176(ra) # 80001f7c <fetchstr>
}
    80002034:	70a2                	ld	ra,40(sp)
    80002036:	7402                	ld	s0,32(sp)
    80002038:	64e2                	ld	s1,24(sp)
    8000203a:	6942                	ld	s2,16(sp)
    8000203c:	6145                	add	sp,sp,48
    8000203e:	8082                	ret

0000000080002040 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80002040:	1101                	add	sp,sp,-32
    80002042:	ec06                	sd	ra,24(sp)
    80002044:	e822                	sd	s0,16(sp)
    80002046:	e426                	sd	s1,8(sp)
    80002048:	e04a                	sd	s2,0(sp)
    8000204a:	1000                	add	s0,sp,32
  int num;
  struct proc *p = myproc();
    8000204c:	fffff097          	auipc	ra,0xfffff
    80002050:	e5e080e7          	jalr	-418(ra) # 80000eaa <myproc>
    80002054:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002056:	05853903          	ld	s2,88(a0)
    8000205a:	0a893783          	ld	a5,168(s2)
    8000205e:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002062:	37fd                	addw	a5,a5,-1
    80002064:	4751                	li	a4,20
    80002066:	00f76f63          	bltu	a4,a5,80002084 <syscall+0x44>
    8000206a:	00369713          	sll	a4,a3,0x3
    8000206e:	00006797          	auipc	a5,0x6
    80002072:	3a278793          	add	a5,a5,930 # 80008410 <syscalls>
    80002076:	97ba                	add	a5,a5,a4
    80002078:	639c                	ld	a5,0(a5)
    8000207a:	c789                	beqz	a5,80002084 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    8000207c:	9782                	jalr	a5
    8000207e:	06a93823          	sd	a0,112(s2)
    80002082:	a839                	j	800020a0 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002084:	15848613          	add	a2,s1,344
    80002088:	588c                	lw	a1,48(s1)
    8000208a:	00006517          	auipc	a0,0x6
    8000208e:	34e50513          	add	a0,a0,846 # 800083d8 <states.0+0x150>
    80002092:	00004097          	auipc	ra,0x4
    80002096:	b4e080e7          	jalr	-1202(ra) # 80005be0 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8000209a:	6cbc                	ld	a5,88(s1)
    8000209c:	577d                	li	a4,-1
    8000209e:	fbb8                	sd	a4,112(a5)
  }
}
    800020a0:	60e2                	ld	ra,24(sp)
    800020a2:	6442                	ld	s0,16(sp)
    800020a4:	64a2                	ld	s1,8(sp)
    800020a6:	6902                	ld	s2,0(sp)
    800020a8:	6105                	add	sp,sp,32
    800020aa:	8082                	ret

00000000800020ac <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800020ac:	1101                	add	sp,sp,-32
    800020ae:	ec06                	sd	ra,24(sp)
    800020b0:	e822                	sd	s0,16(sp)
    800020b2:	1000                	add	s0,sp,32
  int n;
  argint(0, &n);
    800020b4:	fec40593          	add	a1,s0,-20
    800020b8:	4501                	li	a0,0
    800020ba:	00000097          	auipc	ra,0x0
    800020be:	f0e080e7          	jalr	-242(ra) # 80001fc8 <argint>
  exit(n);
    800020c2:	fec42503          	lw	a0,-20(s0)
    800020c6:	fffff097          	auipc	ra,0xfffff
    800020ca:	5c4080e7          	jalr	1476(ra) # 8000168a <exit>
  return 0;  // not reached
}
    800020ce:	4501                	li	a0,0
    800020d0:	60e2                	ld	ra,24(sp)
    800020d2:	6442                	ld	s0,16(sp)
    800020d4:	6105                	add	sp,sp,32
    800020d6:	8082                	ret

00000000800020d8 <sys_getpid>:

uint64
sys_getpid(void)
{
    800020d8:	1141                	add	sp,sp,-16
    800020da:	e406                	sd	ra,8(sp)
    800020dc:	e022                	sd	s0,0(sp)
    800020de:	0800                	add	s0,sp,16
  return myproc()->pid;
    800020e0:	fffff097          	auipc	ra,0xfffff
    800020e4:	dca080e7          	jalr	-566(ra) # 80000eaa <myproc>
}
    800020e8:	5908                	lw	a0,48(a0)
    800020ea:	60a2                	ld	ra,8(sp)
    800020ec:	6402                	ld	s0,0(sp)
    800020ee:	0141                	add	sp,sp,16
    800020f0:	8082                	ret

00000000800020f2 <sys_fork>:

uint64
sys_fork(void)
{
    800020f2:	1141                	add	sp,sp,-16
    800020f4:	e406                	sd	ra,8(sp)
    800020f6:	e022                	sd	s0,0(sp)
    800020f8:	0800                	add	s0,sp,16
  return fork();
    800020fa:	fffff097          	auipc	ra,0xfffff
    800020fe:	16a080e7          	jalr	362(ra) # 80001264 <fork>
}
    80002102:	60a2                	ld	ra,8(sp)
    80002104:	6402                	ld	s0,0(sp)
    80002106:	0141                	add	sp,sp,16
    80002108:	8082                	ret

000000008000210a <sys_wait>:

uint64
sys_wait(void)
{
    8000210a:	1101                	add	sp,sp,-32
    8000210c:	ec06                	sd	ra,24(sp)
    8000210e:	e822                	sd	s0,16(sp)
    80002110:	1000                	add	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002112:	fe840593          	add	a1,s0,-24
    80002116:	4501                	li	a0,0
    80002118:	00000097          	auipc	ra,0x0
    8000211c:	ed0080e7          	jalr	-304(ra) # 80001fe8 <argaddr>
  return wait(p);
    80002120:	fe843503          	ld	a0,-24(s0)
    80002124:	fffff097          	auipc	ra,0xfffff
    80002128:	70c080e7          	jalr	1804(ra) # 80001830 <wait>
}
    8000212c:	60e2                	ld	ra,24(sp)
    8000212e:	6442                	ld	s0,16(sp)
    80002130:	6105                	add	sp,sp,32
    80002132:	8082                	ret

0000000080002134 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002134:	7179                	add	sp,sp,-48
    80002136:	f406                	sd	ra,40(sp)
    80002138:	f022                	sd	s0,32(sp)
    8000213a:	ec26                	sd	s1,24(sp)
    8000213c:	1800                	add	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    8000213e:	fdc40593          	add	a1,s0,-36
    80002142:	4501                	li	a0,0
    80002144:	00000097          	auipc	ra,0x0
    80002148:	e84080e7          	jalr	-380(ra) # 80001fc8 <argint>
  addr = myproc()->sz;
    8000214c:	fffff097          	auipc	ra,0xfffff
    80002150:	d5e080e7          	jalr	-674(ra) # 80000eaa <myproc>
    80002154:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002156:	fdc42503          	lw	a0,-36(s0)
    8000215a:	fffff097          	auipc	ra,0xfffff
    8000215e:	0ae080e7          	jalr	174(ra) # 80001208 <growproc>
    80002162:	00054863          	bltz	a0,80002172 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80002166:	8526                	mv	a0,s1
    80002168:	70a2                	ld	ra,40(sp)
    8000216a:	7402                	ld	s0,32(sp)
    8000216c:	64e2                	ld	s1,24(sp)
    8000216e:	6145                	add	sp,sp,48
    80002170:	8082                	ret
    return -1;
    80002172:	54fd                	li	s1,-1
    80002174:	bfcd                	j	80002166 <sys_sbrk+0x32>

0000000080002176 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002176:	7139                	add	sp,sp,-64
    80002178:	fc06                	sd	ra,56(sp)
    8000217a:	f822                	sd	s0,48(sp)
    8000217c:	f426                	sd	s1,40(sp)
    8000217e:	f04a                	sd	s2,32(sp)
    80002180:	ec4e                	sd	s3,24(sp)
    80002182:	0080                	add	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002184:	fcc40593          	add	a1,s0,-52
    80002188:	4501                	li	a0,0
    8000218a:	00000097          	auipc	ra,0x0
    8000218e:	e3e080e7          	jalr	-450(ra) # 80001fc8 <argint>
  if(n < 0)
    80002192:	fcc42783          	lw	a5,-52(s0)
    80002196:	0607cf63          	bltz	a5,80002214 <sys_sleep+0x9e>
    n = 0;
  acquire(&tickslock);
    8000219a:	0000c517          	auipc	a0,0xc
    8000219e:	5b650513          	add	a0,a0,1462 # 8000e750 <tickslock>
    800021a2:	00004097          	auipc	ra,0x4
    800021a6:	f2c080e7          	jalr	-212(ra) # 800060ce <acquire>
  ticks0 = ticks;
    800021aa:	00006917          	auipc	s2,0x6
    800021ae:	73e92903          	lw	s2,1854(s2) # 800088e8 <ticks>
  while(ticks - ticks0 < n){
    800021b2:	fcc42783          	lw	a5,-52(s0)
    800021b6:	cf9d                	beqz	a5,800021f4 <sys_sleep+0x7e>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800021b8:	0000c997          	auipc	s3,0xc
    800021bc:	59898993          	add	s3,s3,1432 # 8000e750 <tickslock>
    800021c0:	00006497          	auipc	s1,0x6
    800021c4:	72848493          	add	s1,s1,1832 # 800088e8 <ticks>
    if(killed(myproc())){
    800021c8:	fffff097          	auipc	ra,0xfffff
    800021cc:	ce2080e7          	jalr	-798(ra) # 80000eaa <myproc>
    800021d0:	fffff097          	auipc	ra,0xfffff
    800021d4:	62e080e7          	jalr	1582(ra) # 800017fe <killed>
    800021d8:	e129                	bnez	a0,8000221a <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    800021da:	85ce                	mv	a1,s3
    800021dc:	8526                	mv	a0,s1
    800021de:	fffff097          	auipc	ra,0xfffff
    800021e2:	378080e7          	jalr	888(ra) # 80001556 <sleep>
  while(ticks - ticks0 < n){
    800021e6:	409c                	lw	a5,0(s1)
    800021e8:	412787bb          	subw	a5,a5,s2
    800021ec:	fcc42703          	lw	a4,-52(s0)
    800021f0:	fce7ece3          	bltu	a5,a4,800021c8 <sys_sleep+0x52>
  }
  release(&tickslock);
    800021f4:	0000c517          	auipc	a0,0xc
    800021f8:	55c50513          	add	a0,a0,1372 # 8000e750 <tickslock>
    800021fc:	00004097          	auipc	ra,0x4
    80002200:	f86080e7          	jalr	-122(ra) # 80006182 <release>
  return 0;
    80002204:	4501                	li	a0,0
}
    80002206:	70e2                	ld	ra,56(sp)
    80002208:	7442                	ld	s0,48(sp)
    8000220a:	74a2                	ld	s1,40(sp)
    8000220c:	7902                	ld	s2,32(sp)
    8000220e:	69e2                	ld	s3,24(sp)
    80002210:	6121                	add	sp,sp,64
    80002212:	8082                	ret
    n = 0;
    80002214:	fc042623          	sw	zero,-52(s0)
    80002218:	b749                	j	8000219a <sys_sleep+0x24>
      release(&tickslock);
    8000221a:	0000c517          	auipc	a0,0xc
    8000221e:	53650513          	add	a0,a0,1334 # 8000e750 <tickslock>
    80002222:	00004097          	auipc	ra,0x4
    80002226:	f60080e7          	jalr	-160(ra) # 80006182 <release>
      return -1;
    8000222a:	557d                	li	a0,-1
    8000222c:	bfe9                	j	80002206 <sys_sleep+0x90>

000000008000222e <sys_kill>:

uint64
sys_kill(void)
{
    8000222e:	1101                	add	sp,sp,-32
    80002230:	ec06                	sd	ra,24(sp)
    80002232:	e822                	sd	s0,16(sp)
    80002234:	1000                	add	s0,sp,32
  int pid;

  argint(0, &pid);
    80002236:	fec40593          	add	a1,s0,-20
    8000223a:	4501                	li	a0,0
    8000223c:	00000097          	auipc	ra,0x0
    80002240:	d8c080e7          	jalr	-628(ra) # 80001fc8 <argint>
  return kill(pid);
    80002244:	fec42503          	lw	a0,-20(s0)
    80002248:	fffff097          	auipc	ra,0xfffff
    8000224c:	518080e7          	jalr	1304(ra) # 80001760 <kill>
}
    80002250:	60e2                	ld	ra,24(sp)
    80002252:	6442                	ld	s0,16(sp)
    80002254:	6105                	add	sp,sp,32
    80002256:	8082                	ret

0000000080002258 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002258:	1101                	add	sp,sp,-32
    8000225a:	ec06                	sd	ra,24(sp)
    8000225c:	e822                	sd	s0,16(sp)
    8000225e:	e426                	sd	s1,8(sp)
    80002260:	1000                	add	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002262:	0000c517          	auipc	a0,0xc
    80002266:	4ee50513          	add	a0,a0,1262 # 8000e750 <tickslock>
    8000226a:	00004097          	auipc	ra,0x4
    8000226e:	e64080e7          	jalr	-412(ra) # 800060ce <acquire>
  xticks = ticks;
    80002272:	00006497          	auipc	s1,0x6
    80002276:	6764a483          	lw	s1,1654(s1) # 800088e8 <ticks>
  release(&tickslock);
    8000227a:	0000c517          	auipc	a0,0xc
    8000227e:	4d650513          	add	a0,a0,1238 # 8000e750 <tickslock>
    80002282:	00004097          	auipc	ra,0x4
    80002286:	f00080e7          	jalr	-256(ra) # 80006182 <release>
  return xticks;
}
    8000228a:	02049513          	sll	a0,s1,0x20
    8000228e:	9101                	srl	a0,a0,0x20
    80002290:	60e2                	ld	ra,24(sp)
    80002292:	6442                	ld	s0,16(sp)
    80002294:	64a2                	ld	s1,8(sp)
    80002296:	6105                	add	sp,sp,32
    80002298:	8082                	ret

000000008000229a <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000229a:	7179                	add	sp,sp,-48
    8000229c:	f406                	sd	ra,40(sp)
    8000229e:	f022                	sd	s0,32(sp)
    800022a0:	ec26                	sd	s1,24(sp)
    800022a2:	e84a                	sd	s2,16(sp)
    800022a4:	e44e                	sd	s3,8(sp)
    800022a6:	e052                	sd	s4,0(sp)
    800022a8:	1800                	add	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800022aa:	00006597          	auipc	a1,0x6
    800022ae:	21658593          	add	a1,a1,534 # 800084c0 <syscalls+0xb0>
    800022b2:	0000c517          	auipc	a0,0xc
    800022b6:	4b650513          	add	a0,a0,1206 # 8000e768 <bcache>
    800022ba:	00004097          	auipc	ra,0x4
    800022be:	d84080e7          	jalr	-636(ra) # 8000603e <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800022c2:	00014797          	auipc	a5,0x14
    800022c6:	4a678793          	add	a5,a5,1190 # 80016768 <bcache+0x8000>
    800022ca:	00014717          	auipc	a4,0x14
    800022ce:	70670713          	add	a4,a4,1798 # 800169d0 <bcache+0x8268>
    800022d2:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800022d6:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800022da:	0000c497          	auipc	s1,0xc
    800022de:	4a648493          	add	s1,s1,1190 # 8000e780 <bcache+0x18>
    b->next = bcache.head.next;
    800022e2:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800022e4:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800022e6:	00006a17          	auipc	s4,0x6
    800022ea:	1e2a0a13          	add	s4,s4,482 # 800084c8 <syscalls+0xb8>
    b->next = bcache.head.next;
    800022ee:	2b893783          	ld	a5,696(s2)
    800022f2:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800022f4:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800022f8:	85d2                	mv	a1,s4
    800022fa:	01048513          	add	a0,s1,16
    800022fe:	00001097          	auipc	ra,0x1
    80002302:	496080e7          	jalr	1174(ra) # 80003794 <initsleeplock>
    bcache.head.next->prev = b;
    80002306:	2b893783          	ld	a5,696(s2)
    8000230a:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000230c:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002310:	45848493          	add	s1,s1,1112
    80002314:	fd349de3          	bne	s1,s3,800022ee <binit+0x54>
  }
}
    80002318:	70a2                	ld	ra,40(sp)
    8000231a:	7402                	ld	s0,32(sp)
    8000231c:	64e2                	ld	s1,24(sp)
    8000231e:	6942                	ld	s2,16(sp)
    80002320:	69a2                	ld	s3,8(sp)
    80002322:	6a02                	ld	s4,0(sp)
    80002324:	6145                	add	sp,sp,48
    80002326:	8082                	ret

0000000080002328 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002328:	7179                	add	sp,sp,-48
    8000232a:	f406                	sd	ra,40(sp)
    8000232c:	f022                	sd	s0,32(sp)
    8000232e:	ec26                	sd	s1,24(sp)
    80002330:	e84a                	sd	s2,16(sp)
    80002332:	e44e                	sd	s3,8(sp)
    80002334:	1800                	add	s0,sp,48
    80002336:	892a                	mv	s2,a0
    80002338:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000233a:	0000c517          	auipc	a0,0xc
    8000233e:	42e50513          	add	a0,a0,1070 # 8000e768 <bcache>
    80002342:	00004097          	auipc	ra,0x4
    80002346:	d8c080e7          	jalr	-628(ra) # 800060ce <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000234a:	00014497          	auipc	s1,0x14
    8000234e:	6d64b483          	ld	s1,1750(s1) # 80016a20 <bcache+0x82b8>
    80002352:	00014797          	auipc	a5,0x14
    80002356:	67e78793          	add	a5,a5,1662 # 800169d0 <bcache+0x8268>
    8000235a:	02f48f63          	beq	s1,a5,80002398 <bread+0x70>
    8000235e:	873e                	mv	a4,a5
    80002360:	a021                	j	80002368 <bread+0x40>
    80002362:	68a4                	ld	s1,80(s1)
    80002364:	02e48a63          	beq	s1,a4,80002398 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002368:	449c                	lw	a5,8(s1)
    8000236a:	ff279ce3          	bne	a5,s2,80002362 <bread+0x3a>
    8000236e:	44dc                	lw	a5,12(s1)
    80002370:	ff3799e3          	bne	a5,s3,80002362 <bread+0x3a>
      b->refcnt++;
    80002374:	40bc                	lw	a5,64(s1)
    80002376:	2785                	addw	a5,a5,1
    80002378:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000237a:	0000c517          	auipc	a0,0xc
    8000237e:	3ee50513          	add	a0,a0,1006 # 8000e768 <bcache>
    80002382:	00004097          	auipc	ra,0x4
    80002386:	e00080e7          	jalr	-512(ra) # 80006182 <release>
      acquiresleep(&b->lock);
    8000238a:	01048513          	add	a0,s1,16
    8000238e:	00001097          	auipc	ra,0x1
    80002392:	440080e7          	jalr	1088(ra) # 800037ce <acquiresleep>
      return b;
    80002396:	a8b9                	j	800023f4 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002398:	00014497          	auipc	s1,0x14
    8000239c:	6804b483          	ld	s1,1664(s1) # 80016a18 <bcache+0x82b0>
    800023a0:	00014797          	auipc	a5,0x14
    800023a4:	63078793          	add	a5,a5,1584 # 800169d0 <bcache+0x8268>
    800023a8:	00f48863          	beq	s1,a5,800023b8 <bread+0x90>
    800023ac:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800023ae:	40bc                	lw	a5,64(s1)
    800023b0:	cf81                	beqz	a5,800023c8 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800023b2:	64a4                	ld	s1,72(s1)
    800023b4:	fee49de3          	bne	s1,a4,800023ae <bread+0x86>
  panic("bget: no buffers");
    800023b8:	00006517          	auipc	a0,0x6
    800023bc:	11850513          	add	a0,a0,280 # 800084d0 <syscalls+0xc0>
    800023c0:	00003097          	auipc	ra,0x3
    800023c4:	7d6080e7          	jalr	2006(ra) # 80005b96 <panic>
      b->dev = dev;
    800023c8:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800023cc:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800023d0:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800023d4:	4785                	li	a5,1
    800023d6:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800023d8:	0000c517          	auipc	a0,0xc
    800023dc:	39050513          	add	a0,a0,912 # 8000e768 <bcache>
    800023e0:	00004097          	auipc	ra,0x4
    800023e4:	da2080e7          	jalr	-606(ra) # 80006182 <release>
      acquiresleep(&b->lock);
    800023e8:	01048513          	add	a0,s1,16
    800023ec:	00001097          	auipc	ra,0x1
    800023f0:	3e2080e7          	jalr	994(ra) # 800037ce <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800023f4:	409c                	lw	a5,0(s1)
    800023f6:	cb89                	beqz	a5,80002408 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800023f8:	8526                	mv	a0,s1
    800023fa:	70a2                	ld	ra,40(sp)
    800023fc:	7402                	ld	s0,32(sp)
    800023fe:	64e2                	ld	s1,24(sp)
    80002400:	6942                	ld	s2,16(sp)
    80002402:	69a2                	ld	s3,8(sp)
    80002404:	6145                	add	sp,sp,48
    80002406:	8082                	ret
    virtio_disk_rw(b, 0);
    80002408:	4581                	li	a1,0
    8000240a:	8526                	mv	a0,s1
    8000240c:	00003097          	auipc	ra,0x3
    80002410:	f86080e7          	jalr	-122(ra) # 80005392 <virtio_disk_rw>
    b->valid = 1;
    80002414:	4785                	li	a5,1
    80002416:	c09c                	sw	a5,0(s1)
  return b;
    80002418:	b7c5                	j	800023f8 <bread+0xd0>

000000008000241a <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000241a:	1101                	add	sp,sp,-32
    8000241c:	ec06                	sd	ra,24(sp)
    8000241e:	e822                	sd	s0,16(sp)
    80002420:	e426                	sd	s1,8(sp)
    80002422:	1000                	add	s0,sp,32
    80002424:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002426:	0541                	add	a0,a0,16
    80002428:	00001097          	auipc	ra,0x1
    8000242c:	440080e7          	jalr	1088(ra) # 80003868 <holdingsleep>
    80002430:	cd01                	beqz	a0,80002448 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002432:	4585                	li	a1,1
    80002434:	8526                	mv	a0,s1
    80002436:	00003097          	auipc	ra,0x3
    8000243a:	f5c080e7          	jalr	-164(ra) # 80005392 <virtio_disk_rw>
}
    8000243e:	60e2                	ld	ra,24(sp)
    80002440:	6442                	ld	s0,16(sp)
    80002442:	64a2                	ld	s1,8(sp)
    80002444:	6105                	add	sp,sp,32
    80002446:	8082                	ret
    panic("bwrite");
    80002448:	00006517          	auipc	a0,0x6
    8000244c:	0a050513          	add	a0,a0,160 # 800084e8 <syscalls+0xd8>
    80002450:	00003097          	auipc	ra,0x3
    80002454:	746080e7          	jalr	1862(ra) # 80005b96 <panic>

0000000080002458 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002458:	1101                	add	sp,sp,-32
    8000245a:	ec06                	sd	ra,24(sp)
    8000245c:	e822                	sd	s0,16(sp)
    8000245e:	e426                	sd	s1,8(sp)
    80002460:	e04a                	sd	s2,0(sp)
    80002462:	1000                	add	s0,sp,32
    80002464:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002466:	01050913          	add	s2,a0,16
    8000246a:	854a                	mv	a0,s2
    8000246c:	00001097          	auipc	ra,0x1
    80002470:	3fc080e7          	jalr	1020(ra) # 80003868 <holdingsleep>
    80002474:	c925                	beqz	a0,800024e4 <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    80002476:	854a                	mv	a0,s2
    80002478:	00001097          	auipc	ra,0x1
    8000247c:	3ac080e7          	jalr	940(ra) # 80003824 <releasesleep>

  acquire(&bcache.lock);
    80002480:	0000c517          	auipc	a0,0xc
    80002484:	2e850513          	add	a0,a0,744 # 8000e768 <bcache>
    80002488:	00004097          	auipc	ra,0x4
    8000248c:	c46080e7          	jalr	-954(ra) # 800060ce <acquire>
  b->refcnt--;
    80002490:	40bc                	lw	a5,64(s1)
    80002492:	37fd                	addw	a5,a5,-1
    80002494:	0007871b          	sext.w	a4,a5
    80002498:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000249a:	e71d                	bnez	a4,800024c8 <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000249c:	68b8                	ld	a4,80(s1)
    8000249e:	64bc                	ld	a5,72(s1)
    800024a0:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    800024a2:	68b8                	ld	a4,80(s1)
    800024a4:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800024a6:	00014797          	auipc	a5,0x14
    800024aa:	2c278793          	add	a5,a5,706 # 80016768 <bcache+0x8000>
    800024ae:	2b87b703          	ld	a4,696(a5)
    800024b2:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800024b4:	00014717          	auipc	a4,0x14
    800024b8:	51c70713          	add	a4,a4,1308 # 800169d0 <bcache+0x8268>
    800024bc:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800024be:	2b87b703          	ld	a4,696(a5)
    800024c2:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800024c4:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800024c8:	0000c517          	auipc	a0,0xc
    800024cc:	2a050513          	add	a0,a0,672 # 8000e768 <bcache>
    800024d0:	00004097          	auipc	ra,0x4
    800024d4:	cb2080e7          	jalr	-846(ra) # 80006182 <release>
}
    800024d8:	60e2                	ld	ra,24(sp)
    800024da:	6442                	ld	s0,16(sp)
    800024dc:	64a2                	ld	s1,8(sp)
    800024de:	6902                	ld	s2,0(sp)
    800024e0:	6105                	add	sp,sp,32
    800024e2:	8082                	ret
    panic("brelse");
    800024e4:	00006517          	auipc	a0,0x6
    800024e8:	00c50513          	add	a0,a0,12 # 800084f0 <syscalls+0xe0>
    800024ec:	00003097          	auipc	ra,0x3
    800024f0:	6aa080e7          	jalr	1706(ra) # 80005b96 <panic>

00000000800024f4 <bpin>:

void
bpin(struct buf *b) {
    800024f4:	1101                	add	sp,sp,-32
    800024f6:	ec06                	sd	ra,24(sp)
    800024f8:	e822                	sd	s0,16(sp)
    800024fa:	e426                	sd	s1,8(sp)
    800024fc:	1000                	add	s0,sp,32
    800024fe:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002500:	0000c517          	auipc	a0,0xc
    80002504:	26850513          	add	a0,a0,616 # 8000e768 <bcache>
    80002508:	00004097          	auipc	ra,0x4
    8000250c:	bc6080e7          	jalr	-1082(ra) # 800060ce <acquire>
  b->refcnt++;
    80002510:	40bc                	lw	a5,64(s1)
    80002512:	2785                	addw	a5,a5,1
    80002514:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002516:	0000c517          	auipc	a0,0xc
    8000251a:	25250513          	add	a0,a0,594 # 8000e768 <bcache>
    8000251e:	00004097          	auipc	ra,0x4
    80002522:	c64080e7          	jalr	-924(ra) # 80006182 <release>
}
    80002526:	60e2                	ld	ra,24(sp)
    80002528:	6442                	ld	s0,16(sp)
    8000252a:	64a2                	ld	s1,8(sp)
    8000252c:	6105                	add	sp,sp,32
    8000252e:	8082                	ret

0000000080002530 <bunpin>:

void
bunpin(struct buf *b) {
    80002530:	1101                	add	sp,sp,-32
    80002532:	ec06                	sd	ra,24(sp)
    80002534:	e822                	sd	s0,16(sp)
    80002536:	e426                	sd	s1,8(sp)
    80002538:	1000                	add	s0,sp,32
    8000253a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000253c:	0000c517          	auipc	a0,0xc
    80002540:	22c50513          	add	a0,a0,556 # 8000e768 <bcache>
    80002544:	00004097          	auipc	ra,0x4
    80002548:	b8a080e7          	jalr	-1142(ra) # 800060ce <acquire>
  b->refcnt--;
    8000254c:	40bc                	lw	a5,64(s1)
    8000254e:	37fd                	addw	a5,a5,-1
    80002550:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002552:	0000c517          	auipc	a0,0xc
    80002556:	21650513          	add	a0,a0,534 # 8000e768 <bcache>
    8000255a:	00004097          	auipc	ra,0x4
    8000255e:	c28080e7          	jalr	-984(ra) # 80006182 <release>
}
    80002562:	60e2                	ld	ra,24(sp)
    80002564:	6442                	ld	s0,16(sp)
    80002566:	64a2                	ld	s1,8(sp)
    80002568:	6105                	add	sp,sp,32
    8000256a:	8082                	ret

000000008000256c <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000256c:	1101                	add	sp,sp,-32
    8000256e:	ec06                	sd	ra,24(sp)
    80002570:	e822                	sd	s0,16(sp)
    80002572:	e426                	sd	s1,8(sp)
    80002574:	e04a                	sd	s2,0(sp)
    80002576:	1000                	add	s0,sp,32
    80002578:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000257a:	00d5d59b          	srlw	a1,a1,0xd
    8000257e:	00015797          	auipc	a5,0x15
    80002582:	8c67a783          	lw	a5,-1850(a5) # 80016e44 <sb+0x1c>
    80002586:	9dbd                	addw	a1,a1,a5
    80002588:	00000097          	auipc	ra,0x0
    8000258c:	da0080e7          	jalr	-608(ra) # 80002328 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002590:	0074f713          	and	a4,s1,7
    80002594:	4785                	li	a5,1
    80002596:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000259a:	14ce                	sll	s1,s1,0x33
    8000259c:	90d9                	srl	s1,s1,0x36
    8000259e:	00950733          	add	a4,a0,s1
    800025a2:	05874703          	lbu	a4,88(a4)
    800025a6:	00e7f6b3          	and	a3,a5,a4
    800025aa:	c69d                	beqz	a3,800025d8 <bfree+0x6c>
    800025ac:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800025ae:	94aa                	add	s1,s1,a0
    800025b0:	fff7c793          	not	a5,a5
    800025b4:	8f7d                	and	a4,a4,a5
    800025b6:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800025ba:	00001097          	auipc	ra,0x1
    800025be:	0f6080e7          	jalr	246(ra) # 800036b0 <log_write>
  brelse(bp);
    800025c2:	854a                	mv	a0,s2
    800025c4:	00000097          	auipc	ra,0x0
    800025c8:	e94080e7          	jalr	-364(ra) # 80002458 <brelse>
}
    800025cc:	60e2                	ld	ra,24(sp)
    800025ce:	6442                	ld	s0,16(sp)
    800025d0:	64a2                	ld	s1,8(sp)
    800025d2:	6902                	ld	s2,0(sp)
    800025d4:	6105                	add	sp,sp,32
    800025d6:	8082                	ret
    panic("freeing free block");
    800025d8:	00006517          	auipc	a0,0x6
    800025dc:	f2050513          	add	a0,a0,-224 # 800084f8 <syscalls+0xe8>
    800025e0:	00003097          	auipc	ra,0x3
    800025e4:	5b6080e7          	jalr	1462(ra) # 80005b96 <panic>

00000000800025e8 <balloc>:
{
    800025e8:	711d                	add	sp,sp,-96
    800025ea:	ec86                	sd	ra,88(sp)
    800025ec:	e8a2                	sd	s0,80(sp)
    800025ee:	e4a6                	sd	s1,72(sp)
    800025f0:	e0ca                	sd	s2,64(sp)
    800025f2:	fc4e                	sd	s3,56(sp)
    800025f4:	f852                	sd	s4,48(sp)
    800025f6:	f456                	sd	s5,40(sp)
    800025f8:	f05a                	sd	s6,32(sp)
    800025fa:	ec5e                	sd	s7,24(sp)
    800025fc:	e862                	sd	s8,16(sp)
    800025fe:	e466                	sd	s9,8(sp)
    80002600:	1080                	add	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002602:	00015797          	auipc	a5,0x15
    80002606:	82a7a783          	lw	a5,-2006(a5) # 80016e2c <sb+0x4>
    8000260a:	cff5                	beqz	a5,80002706 <balloc+0x11e>
    8000260c:	8baa                	mv	s7,a0
    8000260e:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002610:	00015b17          	auipc	s6,0x15
    80002614:	818b0b13          	add	s6,s6,-2024 # 80016e28 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002618:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000261a:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000261c:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000261e:	6c89                	lui	s9,0x2
    80002620:	a061                	j	800026a8 <balloc+0xc0>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002622:	97ca                	add	a5,a5,s2
    80002624:	8e55                	or	a2,a2,a3
    80002626:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    8000262a:	854a                	mv	a0,s2
    8000262c:	00001097          	auipc	ra,0x1
    80002630:	084080e7          	jalr	132(ra) # 800036b0 <log_write>
        brelse(bp);
    80002634:	854a                	mv	a0,s2
    80002636:	00000097          	auipc	ra,0x0
    8000263a:	e22080e7          	jalr	-478(ra) # 80002458 <brelse>
  bp = bread(dev, bno);
    8000263e:	85a6                	mv	a1,s1
    80002640:	855e                	mv	a0,s7
    80002642:	00000097          	auipc	ra,0x0
    80002646:	ce6080e7          	jalr	-794(ra) # 80002328 <bread>
    8000264a:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000264c:	40000613          	li	a2,1024
    80002650:	4581                	li	a1,0
    80002652:	05850513          	add	a0,a0,88
    80002656:	ffffe097          	auipc	ra,0xffffe
    8000265a:	b24080e7          	jalr	-1244(ra) # 8000017a <memset>
  log_write(bp);
    8000265e:	854a                	mv	a0,s2
    80002660:	00001097          	auipc	ra,0x1
    80002664:	050080e7          	jalr	80(ra) # 800036b0 <log_write>
  brelse(bp);
    80002668:	854a                	mv	a0,s2
    8000266a:	00000097          	auipc	ra,0x0
    8000266e:	dee080e7          	jalr	-530(ra) # 80002458 <brelse>
}
    80002672:	8526                	mv	a0,s1
    80002674:	60e6                	ld	ra,88(sp)
    80002676:	6446                	ld	s0,80(sp)
    80002678:	64a6                	ld	s1,72(sp)
    8000267a:	6906                	ld	s2,64(sp)
    8000267c:	79e2                	ld	s3,56(sp)
    8000267e:	7a42                	ld	s4,48(sp)
    80002680:	7aa2                	ld	s5,40(sp)
    80002682:	7b02                	ld	s6,32(sp)
    80002684:	6be2                	ld	s7,24(sp)
    80002686:	6c42                	ld	s8,16(sp)
    80002688:	6ca2                	ld	s9,8(sp)
    8000268a:	6125                	add	sp,sp,96
    8000268c:	8082                	ret
    brelse(bp);
    8000268e:	854a                	mv	a0,s2
    80002690:	00000097          	auipc	ra,0x0
    80002694:	dc8080e7          	jalr	-568(ra) # 80002458 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002698:	015c87bb          	addw	a5,s9,s5
    8000269c:	00078a9b          	sext.w	s5,a5
    800026a0:	004b2703          	lw	a4,4(s6)
    800026a4:	06eaf163          	bgeu	s5,a4,80002706 <balloc+0x11e>
    bp = bread(dev, BBLOCK(b, sb));
    800026a8:	41fad79b          	sraw	a5,s5,0x1f
    800026ac:	0137d79b          	srlw	a5,a5,0x13
    800026b0:	015787bb          	addw	a5,a5,s5
    800026b4:	40d7d79b          	sraw	a5,a5,0xd
    800026b8:	01cb2583          	lw	a1,28(s6)
    800026bc:	9dbd                	addw	a1,a1,a5
    800026be:	855e                	mv	a0,s7
    800026c0:	00000097          	auipc	ra,0x0
    800026c4:	c68080e7          	jalr	-920(ra) # 80002328 <bread>
    800026c8:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026ca:	004b2503          	lw	a0,4(s6)
    800026ce:	000a849b          	sext.w	s1,s5
    800026d2:	8762                	mv	a4,s8
    800026d4:	faa4fde3          	bgeu	s1,a0,8000268e <balloc+0xa6>
      m = 1 << (bi % 8);
    800026d8:	00777693          	and	a3,a4,7
    800026dc:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800026e0:	41f7579b          	sraw	a5,a4,0x1f
    800026e4:	01d7d79b          	srlw	a5,a5,0x1d
    800026e8:	9fb9                	addw	a5,a5,a4
    800026ea:	4037d79b          	sraw	a5,a5,0x3
    800026ee:	00f90633          	add	a2,s2,a5
    800026f2:	05864603          	lbu	a2,88(a2)
    800026f6:	00c6f5b3          	and	a1,a3,a2
    800026fa:	d585                	beqz	a1,80002622 <balloc+0x3a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026fc:	2705                	addw	a4,a4,1
    800026fe:	2485                	addw	s1,s1,1
    80002700:	fd471ae3          	bne	a4,s4,800026d4 <balloc+0xec>
    80002704:	b769                	j	8000268e <balloc+0xa6>
  printf("balloc: out of blocks\n");
    80002706:	00006517          	auipc	a0,0x6
    8000270a:	e0a50513          	add	a0,a0,-502 # 80008510 <syscalls+0x100>
    8000270e:	00003097          	auipc	ra,0x3
    80002712:	4d2080e7          	jalr	1234(ra) # 80005be0 <printf>
  return 0;
    80002716:	4481                	li	s1,0
    80002718:	bfa9                	j	80002672 <balloc+0x8a>

000000008000271a <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    8000271a:	7179                	add	sp,sp,-48
    8000271c:	f406                	sd	ra,40(sp)
    8000271e:	f022                	sd	s0,32(sp)
    80002720:	ec26                	sd	s1,24(sp)
    80002722:	e84a                	sd	s2,16(sp)
    80002724:	e44e                	sd	s3,8(sp)
    80002726:	e052                	sd	s4,0(sp)
    80002728:	1800                	add	s0,sp,48
    8000272a:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000272c:	47ad                	li	a5,11
    8000272e:	02b7e863          	bltu	a5,a1,8000275e <bmap+0x44>
    if((addr = ip->addrs[bn]) == 0){
    80002732:	02059793          	sll	a5,a1,0x20
    80002736:	01e7d593          	srl	a1,a5,0x1e
    8000273a:	00b504b3          	add	s1,a0,a1
    8000273e:	0504a903          	lw	s2,80(s1)
    80002742:	06091e63          	bnez	s2,800027be <bmap+0xa4>
      addr = balloc(ip->dev);
    80002746:	4108                	lw	a0,0(a0)
    80002748:	00000097          	auipc	ra,0x0
    8000274c:	ea0080e7          	jalr	-352(ra) # 800025e8 <balloc>
    80002750:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002754:	06090563          	beqz	s2,800027be <bmap+0xa4>
        return 0;
      ip->addrs[bn] = addr;
    80002758:	0524a823          	sw	s2,80(s1)
    8000275c:	a08d                	j	800027be <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    8000275e:	ff45849b          	addw	s1,a1,-12
    80002762:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002766:	0ff00793          	li	a5,255
    8000276a:	08e7e563          	bltu	a5,a4,800027f4 <bmap+0xda>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    8000276e:	08052903          	lw	s2,128(a0)
    80002772:	00091d63          	bnez	s2,8000278c <bmap+0x72>
      addr = balloc(ip->dev);
    80002776:	4108                	lw	a0,0(a0)
    80002778:	00000097          	auipc	ra,0x0
    8000277c:	e70080e7          	jalr	-400(ra) # 800025e8 <balloc>
    80002780:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002784:	02090d63          	beqz	s2,800027be <bmap+0xa4>
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002788:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    8000278c:	85ca                	mv	a1,s2
    8000278e:	0009a503          	lw	a0,0(s3)
    80002792:	00000097          	auipc	ra,0x0
    80002796:	b96080e7          	jalr	-1130(ra) # 80002328 <bread>
    8000279a:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000279c:	05850793          	add	a5,a0,88
    if((addr = a[bn]) == 0){
    800027a0:	02049713          	sll	a4,s1,0x20
    800027a4:	01e75593          	srl	a1,a4,0x1e
    800027a8:	00b784b3          	add	s1,a5,a1
    800027ac:	0004a903          	lw	s2,0(s1)
    800027b0:	02090063          	beqz	s2,800027d0 <bmap+0xb6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800027b4:	8552                	mv	a0,s4
    800027b6:	00000097          	auipc	ra,0x0
    800027ba:	ca2080e7          	jalr	-862(ra) # 80002458 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800027be:	854a                	mv	a0,s2
    800027c0:	70a2                	ld	ra,40(sp)
    800027c2:	7402                	ld	s0,32(sp)
    800027c4:	64e2                	ld	s1,24(sp)
    800027c6:	6942                	ld	s2,16(sp)
    800027c8:	69a2                	ld	s3,8(sp)
    800027ca:	6a02                	ld	s4,0(sp)
    800027cc:	6145                	add	sp,sp,48
    800027ce:	8082                	ret
      addr = balloc(ip->dev);
    800027d0:	0009a503          	lw	a0,0(s3)
    800027d4:	00000097          	auipc	ra,0x0
    800027d8:	e14080e7          	jalr	-492(ra) # 800025e8 <balloc>
    800027dc:	0005091b          	sext.w	s2,a0
      if(addr){
    800027e0:	fc090ae3          	beqz	s2,800027b4 <bmap+0x9a>
        a[bn] = addr;
    800027e4:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    800027e8:	8552                	mv	a0,s4
    800027ea:	00001097          	auipc	ra,0x1
    800027ee:	ec6080e7          	jalr	-314(ra) # 800036b0 <log_write>
    800027f2:	b7c9                	j	800027b4 <bmap+0x9a>
  panic("bmap: out of range");
    800027f4:	00006517          	auipc	a0,0x6
    800027f8:	d3450513          	add	a0,a0,-716 # 80008528 <syscalls+0x118>
    800027fc:	00003097          	auipc	ra,0x3
    80002800:	39a080e7          	jalr	922(ra) # 80005b96 <panic>

0000000080002804 <iget>:
{
    80002804:	7179                	add	sp,sp,-48
    80002806:	f406                	sd	ra,40(sp)
    80002808:	f022                	sd	s0,32(sp)
    8000280a:	ec26                	sd	s1,24(sp)
    8000280c:	e84a                	sd	s2,16(sp)
    8000280e:	e44e                	sd	s3,8(sp)
    80002810:	e052                	sd	s4,0(sp)
    80002812:	1800                	add	s0,sp,48
    80002814:	89aa                	mv	s3,a0
    80002816:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002818:	00014517          	auipc	a0,0x14
    8000281c:	63050513          	add	a0,a0,1584 # 80016e48 <itable>
    80002820:	00004097          	auipc	ra,0x4
    80002824:	8ae080e7          	jalr	-1874(ra) # 800060ce <acquire>
  empty = 0;
    80002828:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000282a:	00014497          	auipc	s1,0x14
    8000282e:	63648493          	add	s1,s1,1590 # 80016e60 <itable+0x18>
    80002832:	00016697          	auipc	a3,0x16
    80002836:	0be68693          	add	a3,a3,190 # 800188f0 <log>
    8000283a:	a039                	j	80002848 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000283c:	02090b63          	beqz	s2,80002872 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002840:	08848493          	add	s1,s1,136
    80002844:	02d48a63          	beq	s1,a3,80002878 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002848:	449c                	lw	a5,8(s1)
    8000284a:	fef059e3          	blez	a5,8000283c <iget+0x38>
    8000284e:	4098                	lw	a4,0(s1)
    80002850:	ff3716e3          	bne	a4,s3,8000283c <iget+0x38>
    80002854:	40d8                	lw	a4,4(s1)
    80002856:	ff4713e3          	bne	a4,s4,8000283c <iget+0x38>
      ip->ref++;
    8000285a:	2785                	addw	a5,a5,1
    8000285c:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000285e:	00014517          	auipc	a0,0x14
    80002862:	5ea50513          	add	a0,a0,1514 # 80016e48 <itable>
    80002866:	00004097          	auipc	ra,0x4
    8000286a:	91c080e7          	jalr	-1764(ra) # 80006182 <release>
      return ip;
    8000286e:	8926                	mv	s2,s1
    80002870:	a03d                	j	8000289e <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002872:	f7f9                	bnez	a5,80002840 <iget+0x3c>
    80002874:	8926                	mv	s2,s1
    80002876:	b7e9                	j	80002840 <iget+0x3c>
  if(empty == 0)
    80002878:	02090c63          	beqz	s2,800028b0 <iget+0xac>
  ip->dev = dev;
    8000287c:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002880:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002884:	4785                	li	a5,1
    80002886:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000288a:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000288e:	00014517          	auipc	a0,0x14
    80002892:	5ba50513          	add	a0,a0,1466 # 80016e48 <itable>
    80002896:	00004097          	auipc	ra,0x4
    8000289a:	8ec080e7          	jalr	-1812(ra) # 80006182 <release>
}
    8000289e:	854a                	mv	a0,s2
    800028a0:	70a2                	ld	ra,40(sp)
    800028a2:	7402                	ld	s0,32(sp)
    800028a4:	64e2                	ld	s1,24(sp)
    800028a6:	6942                	ld	s2,16(sp)
    800028a8:	69a2                	ld	s3,8(sp)
    800028aa:	6a02                	ld	s4,0(sp)
    800028ac:	6145                	add	sp,sp,48
    800028ae:	8082                	ret
    panic("iget: no inodes");
    800028b0:	00006517          	auipc	a0,0x6
    800028b4:	c9050513          	add	a0,a0,-880 # 80008540 <syscalls+0x130>
    800028b8:	00003097          	auipc	ra,0x3
    800028bc:	2de080e7          	jalr	734(ra) # 80005b96 <panic>

00000000800028c0 <fsinit>:
fsinit(int dev) {
    800028c0:	7179                	add	sp,sp,-48
    800028c2:	f406                	sd	ra,40(sp)
    800028c4:	f022                	sd	s0,32(sp)
    800028c6:	ec26                	sd	s1,24(sp)
    800028c8:	e84a                	sd	s2,16(sp)
    800028ca:	e44e                	sd	s3,8(sp)
    800028cc:	1800                	add	s0,sp,48
    800028ce:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800028d0:	4585                	li	a1,1
    800028d2:	00000097          	auipc	ra,0x0
    800028d6:	a56080e7          	jalr	-1450(ra) # 80002328 <bread>
    800028da:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800028dc:	00014997          	auipc	s3,0x14
    800028e0:	54c98993          	add	s3,s3,1356 # 80016e28 <sb>
    800028e4:	02000613          	li	a2,32
    800028e8:	05850593          	add	a1,a0,88
    800028ec:	854e                	mv	a0,s3
    800028ee:	ffffe097          	auipc	ra,0xffffe
    800028f2:	8e8080e7          	jalr	-1816(ra) # 800001d6 <memmove>
  brelse(bp);
    800028f6:	8526                	mv	a0,s1
    800028f8:	00000097          	auipc	ra,0x0
    800028fc:	b60080e7          	jalr	-1184(ra) # 80002458 <brelse>
  if(sb.magic != FSMAGIC)
    80002900:	0009a703          	lw	a4,0(s3)
    80002904:	102037b7          	lui	a5,0x10203
    80002908:	04078793          	add	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000290c:	02f71263          	bne	a4,a5,80002930 <fsinit+0x70>
  initlog(dev, &sb);
    80002910:	00014597          	auipc	a1,0x14
    80002914:	51858593          	add	a1,a1,1304 # 80016e28 <sb>
    80002918:	854a                	mv	a0,s2
    8000291a:	00001097          	auipc	ra,0x1
    8000291e:	b2c080e7          	jalr	-1236(ra) # 80003446 <initlog>
}
    80002922:	70a2                	ld	ra,40(sp)
    80002924:	7402                	ld	s0,32(sp)
    80002926:	64e2                	ld	s1,24(sp)
    80002928:	6942                	ld	s2,16(sp)
    8000292a:	69a2                	ld	s3,8(sp)
    8000292c:	6145                	add	sp,sp,48
    8000292e:	8082                	ret
    panic("invalid file system");
    80002930:	00006517          	auipc	a0,0x6
    80002934:	c2050513          	add	a0,a0,-992 # 80008550 <syscalls+0x140>
    80002938:	00003097          	auipc	ra,0x3
    8000293c:	25e080e7          	jalr	606(ra) # 80005b96 <panic>

0000000080002940 <iinit>:
{
    80002940:	7179                	add	sp,sp,-48
    80002942:	f406                	sd	ra,40(sp)
    80002944:	f022                	sd	s0,32(sp)
    80002946:	ec26                	sd	s1,24(sp)
    80002948:	e84a                	sd	s2,16(sp)
    8000294a:	e44e                	sd	s3,8(sp)
    8000294c:	1800                	add	s0,sp,48
  initlock(&itable.lock, "itable");
    8000294e:	00006597          	auipc	a1,0x6
    80002952:	c1a58593          	add	a1,a1,-998 # 80008568 <syscalls+0x158>
    80002956:	00014517          	auipc	a0,0x14
    8000295a:	4f250513          	add	a0,a0,1266 # 80016e48 <itable>
    8000295e:	00003097          	auipc	ra,0x3
    80002962:	6e0080e7          	jalr	1760(ra) # 8000603e <initlock>
  for(i = 0; i < NINODE; i++) {
    80002966:	00014497          	auipc	s1,0x14
    8000296a:	50a48493          	add	s1,s1,1290 # 80016e70 <itable+0x28>
    8000296e:	00016997          	auipc	s3,0x16
    80002972:	f9298993          	add	s3,s3,-110 # 80018900 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002976:	00006917          	auipc	s2,0x6
    8000297a:	bfa90913          	add	s2,s2,-1030 # 80008570 <syscalls+0x160>
    8000297e:	85ca                	mv	a1,s2
    80002980:	8526                	mv	a0,s1
    80002982:	00001097          	auipc	ra,0x1
    80002986:	e12080e7          	jalr	-494(ra) # 80003794 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000298a:	08848493          	add	s1,s1,136
    8000298e:	ff3498e3          	bne	s1,s3,8000297e <iinit+0x3e>
}
    80002992:	70a2                	ld	ra,40(sp)
    80002994:	7402                	ld	s0,32(sp)
    80002996:	64e2                	ld	s1,24(sp)
    80002998:	6942                	ld	s2,16(sp)
    8000299a:	69a2                	ld	s3,8(sp)
    8000299c:	6145                	add	sp,sp,48
    8000299e:	8082                	ret

00000000800029a0 <ialloc>:
{
    800029a0:	7139                	add	sp,sp,-64
    800029a2:	fc06                	sd	ra,56(sp)
    800029a4:	f822                	sd	s0,48(sp)
    800029a6:	f426                	sd	s1,40(sp)
    800029a8:	f04a                	sd	s2,32(sp)
    800029aa:	ec4e                	sd	s3,24(sp)
    800029ac:	e852                	sd	s4,16(sp)
    800029ae:	e456                	sd	s5,8(sp)
    800029b0:	e05a                	sd	s6,0(sp)
    800029b2:	0080                	add	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800029b4:	00014717          	auipc	a4,0x14
    800029b8:	48072703          	lw	a4,1152(a4) # 80016e34 <sb+0xc>
    800029bc:	4785                	li	a5,1
    800029be:	04e7f863          	bgeu	a5,a4,80002a0e <ialloc+0x6e>
    800029c2:	8aaa                	mv	s5,a0
    800029c4:	8b2e                	mv	s6,a1
    800029c6:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    800029c8:	00014a17          	auipc	s4,0x14
    800029cc:	460a0a13          	add	s4,s4,1120 # 80016e28 <sb>
    800029d0:	00495593          	srl	a1,s2,0x4
    800029d4:	018a2783          	lw	a5,24(s4)
    800029d8:	9dbd                	addw	a1,a1,a5
    800029da:	8556                	mv	a0,s5
    800029dc:	00000097          	auipc	ra,0x0
    800029e0:	94c080e7          	jalr	-1716(ra) # 80002328 <bread>
    800029e4:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800029e6:	05850993          	add	s3,a0,88
    800029ea:	00f97793          	and	a5,s2,15
    800029ee:	079a                	sll	a5,a5,0x6
    800029f0:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800029f2:	00099783          	lh	a5,0(s3)
    800029f6:	cf9d                	beqz	a5,80002a34 <ialloc+0x94>
    brelse(bp);
    800029f8:	00000097          	auipc	ra,0x0
    800029fc:	a60080e7          	jalr	-1440(ra) # 80002458 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a00:	0905                	add	s2,s2,1
    80002a02:	00ca2703          	lw	a4,12(s4)
    80002a06:	0009079b          	sext.w	a5,s2
    80002a0a:	fce7e3e3          	bltu	a5,a4,800029d0 <ialloc+0x30>
  printf("ialloc: no inodes\n");
    80002a0e:	00006517          	auipc	a0,0x6
    80002a12:	b6a50513          	add	a0,a0,-1174 # 80008578 <syscalls+0x168>
    80002a16:	00003097          	auipc	ra,0x3
    80002a1a:	1ca080e7          	jalr	458(ra) # 80005be0 <printf>
  return 0;
    80002a1e:	4501                	li	a0,0
}
    80002a20:	70e2                	ld	ra,56(sp)
    80002a22:	7442                	ld	s0,48(sp)
    80002a24:	74a2                	ld	s1,40(sp)
    80002a26:	7902                	ld	s2,32(sp)
    80002a28:	69e2                	ld	s3,24(sp)
    80002a2a:	6a42                	ld	s4,16(sp)
    80002a2c:	6aa2                	ld	s5,8(sp)
    80002a2e:	6b02                	ld	s6,0(sp)
    80002a30:	6121                	add	sp,sp,64
    80002a32:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002a34:	04000613          	li	a2,64
    80002a38:	4581                	li	a1,0
    80002a3a:	854e                	mv	a0,s3
    80002a3c:	ffffd097          	auipc	ra,0xffffd
    80002a40:	73e080e7          	jalr	1854(ra) # 8000017a <memset>
      dip->type = type;
    80002a44:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002a48:	8526                	mv	a0,s1
    80002a4a:	00001097          	auipc	ra,0x1
    80002a4e:	c66080e7          	jalr	-922(ra) # 800036b0 <log_write>
      brelse(bp);
    80002a52:	8526                	mv	a0,s1
    80002a54:	00000097          	auipc	ra,0x0
    80002a58:	a04080e7          	jalr	-1532(ra) # 80002458 <brelse>
      return iget(dev, inum);
    80002a5c:	0009059b          	sext.w	a1,s2
    80002a60:	8556                	mv	a0,s5
    80002a62:	00000097          	auipc	ra,0x0
    80002a66:	da2080e7          	jalr	-606(ra) # 80002804 <iget>
    80002a6a:	bf5d                	j	80002a20 <ialloc+0x80>

0000000080002a6c <iupdate>:
{
    80002a6c:	1101                	add	sp,sp,-32
    80002a6e:	ec06                	sd	ra,24(sp)
    80002a70:	e822                	sd	s0,16(sp)
    80002a72:	e426                	sd	s1,8(sp)
    80002a74:	e04a                	sd	s2,0(sp)
    80002a76:	1000                	add	s0,sp,32
    80002a78:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002a7a:	415c                	lw	a5,4(a0)
    80002a7c:	0047d79b          	srlw	a5,a5,0x4
    80002a80:	00014597          	auipc	a1,0x14
    80002a84:	3c05a583          	lw	a1,960(a1) # 80016e40 <sb+0x18>
    80002a88:	9dbd                	addw	a1,a1,a5
    80002a8a:	4108                	lw	a0,0(a0)
    80002a8c:	00000097          	auipc	ra,0x0
    80002a90:	89c080e7          	jalr	-1892(ra) # 80002328 <bread>
    80002a94:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002a96:	05850793          	add	a5,a0,88
    80002a9a:	40d8                	lw	a4,4(s1)
    80002a9c:	8b3d                	and	a4,a4,15
    80002a9e:	071a                	sll	a4,a4,0x6
    80002aa0:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002aa2:	04449703          	lh	a4,68(s1)
    80002aa6:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002aaa:	04649703          	lh	a4,70(s1)
    80002aae:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002ab2:	04849703          	lh	a4,72(s1)
    80002ab6:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002aba:	04a49703          	lh	a4,74(s1)
    80002abe:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002ac2:	44f8                	lw	a4,76(s1)
    80002ac4:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002ac6:	03400613          	li	a2,52
    80002aca:	05048593          	add	a1,s1,80
    80002ace:	00c78513          	add	a0,a5,12
    80002ad2:	ffffd097          	auipc	ra,0xffffd
    80002ad6:	704080e7          	jalr	1796(ra) # 800001d6 <memmove>
  log_write(bp);
    80002ada:	854a                	mv	a0,s2
    80002adc:	00001097          	auipc	ra,0x1
    80002ae0:	bd4080e7          	jalr	-1068(ra) # 800036b0 <log_write>
  brelse(bp);
    80002ae4:	854a                	mv	a0,s2
    80002ae6:	00000097          	auipc	ra,0x0
    80002aea:	972080e7          	jalr	-1678(ra) # 80002458 <brelse>
}
    80002aee:	60e2                	ld	ra,24(sp)
    80002af0:	6442                	ld	s0,16(sp)
    80002af2:	64a2                	ld	s1,8(sp)
    80002af4:	6902                	ld	s2,0(sp)
    80002af6:	6105                	add	sp,sp,32
    80002af8:	8082                	ret

0000000080002afa <idup>:
{
    80002afa:	1101                	add	sp,sp,-32
    80002afc:	ec06                	sd	ra,24(sp)
    80002afe:	e822                	sd	s0,16(sp)
    80002b00:	e426                	sd	s1,8(sp)
    80002b02:	1000                	add	s0,sp,32
    80002b04:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002b06:	00014517          	auipc	a0,0x14
    80002b0a:	34250513          	add	a0,a0,834 # 80016e48 <itable>
    80002b0e:	00003097          	auipc	ra,0x3
    80002b12:	5c0080e7          	jalr	1472(ra) # 800060ce <acquire>
  ip->ref++;
    80002b16:	449c                	lw	a5,8(s1)
    80002b18:	2785                	addw	a5,a5,1
    80002b1a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002b1c:	00014517          	auipc	a0,0x14
    80002b20:	32c50513          	add	a0,a0,812 # 80016e48 <itable>
    80002b24:	00003097          	auipc	ra,0x3
    80002b28:	65e080e7          	jalr	1630(ra) # 80006182 <release>
}
    80002b2c:	8526                	mv	a0,s1
    80002b2e:	60e2                	ld	ra,24(sp)
    80002b30:	6442                	ld	s0,16(sp)
    80002b32:	64a2                	ld	s1,8(sp)
    80002b34:	6105                	add	sp,sp,32
    80002b36:	8082                	ret

0000000080002b38 <ilock>:
{
    80002b38:	1101                	add	sp,sp,-32
    80002b3a:	ec06                	sd	ra,24(sp)
    80002b3c:	e822                	sd	s0,16(sp)
    80002b3e:	e426                	sd	s1,8(sp)
    80002b40:	e04a                	sd	s2,0(sp)
    80002b42:	1000                	add	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002b44:	c115                	beqz	a0,80002b68 <ilock+0x30>
    80002b46:	84aa                	mv	s1,a0
    80002b48:	451c                	lw	a5,8(a0)
    80002b4a:	00f05f63          	blez	a5,80002b68 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002b4e:	0541                	add	a0,a0,16
    80002b50:	00001097          	auipc	ra,0x1
    80002b54:	c7e080e7          	jalr	-898(ra) # 800037ce <acquiresleep>
  if(ip->valid == 0){
    80002b58:	40bc                	lw	a5,64(s1)
    80002b5a:	cf99                	beqz	a5,80002b78 <ilock+0x40>
}
    80002b5c:	60e2                	ld	ra,24(sp)
    80002b5e:	6442                	ld	s0,16(sp)
    80002b60:	64a2                	ld	s1,8(sp)
    80002b62:	6902                	ld	s2,0(sp)
    80002b64:	6105                	add	sp,sp,32
    80002b66:	8082                	ret
    panic("ilock");
    80002b68:	00006517          	auipc	a0,0x6
    80002b6c:	a2850513          	add	a0,a0,-1496 # 80008590 <syscalls+0x180>
    80002b70:	00003097          	auipc	ra,0x3
    80002b74:	026080e7          	jalr	38(ra) # 80005b96 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b78:	40dc                	lw	a5,4(s1)
    80002b7a:	0047d79b          	srlw	a5,a5,0x4
    80002b7e:	00014597          	auipc	a1,0x14
    80002b82:	2c25a583          	lw	a1,706(a1) # 80016e40 <sb+0x18>
    80002b86:	9dbd                	addw	a1,a1,a5
    80002b88:	4088                	lw	a0,0(s1)
    80002b8a:	fffff097          	auipc	ra,0xfffff
    80002b8e:	79e080e7          	jalr	1950(ra) # 80002328 <bread>
    80002b92:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b94:	05850593          	add	a1,a0,88
    80002b98:	40dc                	lw	a5,4(s1)
    80002b9a:	8bbd                	and	a5,a5,15
    80002b9c:	079a                	sll	a5,a5,0x6
    80002b9e:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002ba0:	00059783          	lh	a5,0(a1)
    80002ba4:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002ba8:	00259783          	lh	a5,2(a1)
    80002bac:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002bb0:	00459783          	lh	a5,4(a1)
    80002bb4:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002bb8:	00659783          	lh	a5,6(a1)
    80002bbc:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002bc0:	459c                	lw	a5,8(a1)
    80002bc2:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002bc4:	03400613          	li	a2,52
    80002bc8:	05b1                	add	a1,a1,12
    80002bca:	05048513          	add	a0,s1,80
    80002bce:	ffffd097          	auipc	ra,0xffffd
    80002bd2:	608080e7          	jalr	1544(ra) # 800001d6 <memmove>
    brelse(bp);
    80002bd6:	854a                	mv	a0,s2
    80002bd8:	00000097          	auipc	ra,0x0
    80002bdc:	880080e7          	jalr	-1920(ra) # 80002458 <brelse>
    ip->valid = 1;
    80002be0:	4785                	li	a5,1
    80002be2:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002be4:	04449783          	lh	a5,68(s1)
    80002be8:	fbb5                	bnez	a5,80002b5c <ilock+0x24>
      panic("ilock: no type");
    80002bea:	00006517          	auipc	a0,0x6
    80002bee:	9ae50513          	add	a0,a0,-1618 # 80008598 <syscalls+0x188>
    80002bf2:	00003097          	auipc	ra,0x3
    80002bf6:	fa4080e7          	jalr	-92(ra) # 80005b96 <panic>

0000000080002bfa <iunlock>:
{
    80002bfa:	1101                	add	sp,sp,-32
    80002bfc:	ec06                	sd	ra,24(sp)
    80002bfe:	e822                	sd	s0,16(sp)
    80002c00:	e426                	sd	s1,8(sp)
    80002c02:	e04a                	sd	s2,0(sp)
    80002c04:	1000                	add	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002c06:	c905                	beqz	a0,80002c36 <iunlock+0x3c>
    80002c08:	84aa                	mv	s1,a0
    80002c0a:	01050913          	add	s2,a0,16
    80002c0e:	854a                	mv	a0,s2
    80002c10:	00001097          	auipc	ra,0x1
    80002c14:	c58080e7          	jalr	-936(ra) # 80003868 <holdingsleep>
    80002c18:	cd19                	beqz	a0,80002c36 <iunlock+0x3c>
    80002c1a:	449c                	lw	a5,8(s1)
    80002c1c:	00f05d63          	blez	a5,80002c36 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002c20:	854a                	mv	a0,s2
    80002c22:	00001097          	auipc	ra,0x1
    80002c26:	c02080e7          	jalr	-1022(ra) # 80003824 <releasesleep>
}
    80002c2a:	60e2                	ld	ra,24(sp)
    80002c2c:	6442                	ld	s0,16(sp)
    80002c2e:	64a2                	ld	s1,8(sp)
    80002c30:	6902                	ld	s2,0(sp)
    80002c32:	6105                	add	sp,sp,32
    80002c34:	8082                	ret
    panic("iunlock");
    80002c36:	00006517          	auipc	a0,0x6
    80002c3a:	97250513          	add	a0,a0,-1678 # 800085a8 <syscalls+0x198>
    80002c3e:	00003097          	auipc	ra,0x3
    80002c42:	f58080e7          	jalr	-168(ra) # 80005b96 <panic>

0000000080002c46 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002c46:	7179                	add	sp,sp,-48
    80002c48:	f406                	sd	ra,40(sp)
    80002c4a:	f022                	sd	s0,32(sp)
    80002c4c:	ec26                	sd	s1,24(sp)
    80002c4e:	e84a                	sd	s2,16(sp)
    80002c50:	e44e                	sd	s3,8(sp)
    80002c52:	e052                	sd	s4,0(sp)
    80002c54:	1800                	add	s0,sp,48
    80002c56:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002c58:	05050493          	add	s1,a0,80
    80002c5c:	08050913          	add	s2,a0,128
    80002c60:	a021                	j	80002c68 <itrunc+0x22>
    80002c62:	0491                	add	s1,s1,4
    80002c64:	01248d63          	beq	s1,s2,80002c7e <itrunc+0x38>
    if(ip->addrs[i]){
    80002c68:	408c                	lw	a1,0(s1)
    80002c6a:	dde5                	beqz	a1,80002c62 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002c6c:	0009a503          	lw	a0,0(s3)
    80002c70:	00000097          	auipc	ra,0x0
    80002c74:	8fc080e7          	jalr	-1796(ra) # 8000256c <bfree>
      ip->addrs[i] = 0;
    80002c78:	0004a023          	sw	zero,0(s1)
    80002c7c:	b7dd                	j	80002c62 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002c7e:	0809a583          	lw	a1,128(s3)
    80002c82:	e185                	bnez	a1,80002ca2 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002c84:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002c88:	854e                	mv	a0,s3
    80002c8a:	00000097          	auipc	ra,0x0
    80002c8e:	de2080e7          	jalr	-542(ra) # 80002a6c <iupdate>
}
    80002c92:	70a2                	ld	ra,40(sp)
    80002c94:	7402                	ld	s0,32(sp)
    80002c96:	64e2                	ld	s1,24(sp)
    80002c98:	6942                	ld	s2,16(sp)
    80002c9a:	69a2                	ld	s3,8(sp)
    80002c9c:	6a02                	ld	s4,0(sp)
    80002c9e:	6145                	add	sp,sp,48
    80002ca0:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002ca2:	0009a503          	lw	a0,0(s3)
    80002ca6:	fffff097          	auipc	ra,0xfffff
    80002caa:	682080e7          	jalr	1666(ra) # 80002328 <bread>
    80002cae:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002cb0:	05850493          	add	s1,a0,88
    80002cb4:	45850913          	add	s2,a0,1112
    80002cb8:	a021                	j	80002cc0 <itrunc+0x7a>
    80002cba:	0491                	add	s1,s1,4
    80002cbc:	01248b63          	beq	s1,s2,80002cd2 <itrunc+0x8c>
      if(a[j])
    80002cc0:	408c                	lw	a1,0(s1)
    80002cc2:	dde5                	beqz	a1,80002cba <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002cc4:	0009a503          	lw	a0,0(s3)
    80002cc8:	00000097          	auipc	ra,0x0
    80002ccc:	8a4080e7          	jalr	-1884(ra) # 8000256c <bfree>
    80002cd0:	b7ed                	j	80002cba <itrunc+0x74>
    brelse(bp);
    80002cd2:	8552                	mv	a0,s4
    80002cd4:	fffff097          	auipc	ra,0xfffff
    80002cd8:	784080e7          	jalr	1924(ra) # 80002458 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002cdc:	0809a583          	lw	a1,128(s3)
    80002ce0:	0009a503          	lw	a0,0(s3)
    80002ce4:	00000097          	auipc	ra,0x0
    80002ce8:	888080e7          	jalr	-1912(ra) # 8000256c <bfree>
    ip->addrs[NDIRECT] = 0;
    80002cec:	0809a023          	sw	zero,128(s3)
    80002cf0:	bf51                	j	80002c84 <itrunc+0x3e>

0000000080002cf2 <iput>:
{
    80002cf2:	1101                	add	sp,sp,-32
    80002cf4:	ec06                	sd	ra,24(sp)
    80002cf6:	e822                	sd	s0,16(sp)
    80002cf8:	e426                	sd	s1,8(sp)
    80002cfa:	e04a                	sd	s2,0(sp)
    80002cfc:	1000                	add	s0,sp,32
    80002cfe:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d00:	00014517          	auipc	a0,0x14
    80002d04:	14850513          	add	a0,a0,328 # 80016e48 <itable>
    80002d08:	00003097          	auipc	ra,0x3
    80002d0c:	3c6080e7          	jalr	966(ra) # 800060ce <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002d10:	4498                	lw	a4,8(s1)
    80002d12:	4785                	li	a5,1
    80002d14:	02f70363          	beq	a4,a5,80002d3a <iput+0x48>
  ip->ref--;
    80002d18:	449c                	lw	a5,8(s1)
    80002d1a:	37fd                	addw	a5,a5,-1
    80002d1c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d1e:	00014517          	auipc	a0,0x14
    80002d22:	12a50513          	add	a0,a0,298 # 80016e48 <itable>
    80002d26:	00003097          	auipc	ra,0x3
    80002d2a:	45c080e7          	jalr	1116(ra) # 80006182 <release>
}
    80002d2e:	60e2                	ld	ra,24(sp)
    80002d30:	6442                	ld	s0,16(sp)
    80002d32:	64a2                	ld	s1,8(sp)
    80002d34:	6902                	ld	s2,0(sp)
    80002d36:	6105                	add	sp,sp,32
    80002d38:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002d3a:	40bc                	lw	a5,64(s1)
    80002d3c:	dff1                	beqz	a5,80002d18 <iput+0x26>
    80002d3e:	04a49783          	lh	a5,74(s1)
    80002d42:	fbf9                	bnez	a5,80002d18 <iput+0x26>
    acquiresleep(&ip->lock);
    80002d44:	01048913          	add	s2,s1,16
    80002d48:	854a                	mv	a0,s2
    80002d4a:	00001097          	auipc	ra,0x1
    80002d4e:	a84080e7          	jalr	-1404(ra) # 800037ce <acquiresleep>
    release(&itable.lock);
    80002d52:	00014517          	auipc	a0,0x14
    80002d56:	0f650513          	add	a0,a0,246 # 80016e48 <itable>
    80002d5a:	00003097          	auipc	ra,0x3
    80002d5e:	428080e7          	jalr	1064(ra) # 80006182 <release>
    itrunc(ip);
    80002d62:	8526                	mv	a0,s1
    80002d64:	00000097          	auipc	ra,0x0
    80002d68:	ee2080e7          	jalr	-286(ra) # 80002c46 <itrunc>
    ip->type = 0;
    80002d6c:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002d70:	8526                	mv	a0,s1
    80002d72:	00000097          	auipc	ra,0x0
    80002d76:	cfa080e7          	jalr	-774(ra) # 80002a6c <iupdate>
    ip->valid = 0;
    80002d7a:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002d7e:	854a                	mv	a0,s2
    80002d80:	00001097          	auipc	ra,0x1
    80002d84:	aa4080e7          	jalr	-1372(ra) # 80003824 <releasesleep>
    acquire(&itable.lock);
    80002d88:	00014517          	auipc	a0,0x14
    80002d8c:	0c050513          	add	a0,a0,192 # 80016e48 <itable>
    80002d90:	00003097          	auipc	ra,0x3
    80002d94:	33e080e7          	jalr	830(ra) # 800060ce <acquire>
    80002d98:	b741                	j	80002d18 <iput+0x26>

0000000080002d9a <iunlockput>:
{
    80002d9a:	1101                	add	sp,sp,-32
    80002d9c:	ec06                	sd	ra,24(sp)
    80002d9e:	e822                	sd	s0,16(sp)
    80002da0:	e426                	sd	s1,8(sp)
    80002da2:	1000                	add	s0,sp,32
    80002da4:	84aa                	mv	s1,a0
  iunlock(ip);
    80002da6:	00000097          	auipc	ra,0x0
    80002daa:	e54080e7          	jalr	-428(ra) # 80002bfa <iunlock>
  iput(ip);
    80002dae:	8526                	mv	a0,s1
    80002db0:	00000097          	auipc	ra,0x0
    80002db4:	f42080e7          	jalr	-190(ra) # 80002cf2 <iput>
}
    80002db8:	60e2                	ld	ra,24(sp)
    80002dba:	6442                	ld	s0,16(sp)
    80002dbc:	64a2                	ld	s1,8(sp)
    80002dbe:	6105                	add	sp,sp,32
    80002dc0:	8082                	ret

0000000080002dc2 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002dc2:	1141                	add	sp,sp,-16
    80002dc4:	e422                	sd	s0,8(sp)
    80002dc6:	0800                	add	s0,sp,16
  st->dev = ip->dev;
    80002dc8:	411c                	lw	a5,0(a0)
    80002dca:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002dcc:	415c                	lw	a5,4(a0)
    80002dce:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002dd0:	04451783          	lh	a5,68(a0)
    80002dd4:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002dd8:	04a51783          	lh	a5,74(a0)
    80002ddc:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002de0:	04c56783          	lwu	a5,76(a0)
    80002de4:	e99c                	sd	a5,16(a1)
}
    80002de6:	6422                	ld	s0,8(sp)
    80002de8:	0141                	add	sp,sp,16
    80002dea:	8082                	ret

0000000080002dec <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002dec:	457c                	lw	a5,76(a0)
    80002dee:	0ed7e963          	bltu	a5,a3,80002ee0 <readi+0xf4>
{
    80002df2:	7159                	add	sp,sp,-112
    80002df4:	f486                	sd	ra,104(sp)
    80002df6:	f0a2                	sd	s0,96(sp)
    80002df8:	eca6                	sd	s1,88(sp)
    80002dfa:	e8ca                	sd	s2,80(sp)
    80002dfc:	e4ce                	sd	s3,72(sp)
    80002dfe:	e0d2                	sd	s4,64(sp)
    80002e00:	fc56                	sd	s5,56(sp)
    80002e02:	f85a                	sd	s6,48(sp)
    80002e04:	f45e                	sd	s7,40(sp)
    80002e06:	f062                	sd	s8,32(sp)
    80002e08:	ec66                	sd	s9,24(sp)
    80002e0a:	e86a                	sd	s10,16(sp)
    80002e0c:	e46e                	sd	s11,8(sp)
    80002e0e:	1880                	add	s0,sp,112
    80002e10:	8b2a                	mv	s6,a0
    80002e12:	8bae                	mv	s7,a1
    80002e14:	8a32                	mv	s4,a2
    80002e16:	84b6                	mv	s1,a3
    80002e18:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002e1a:	9f35                	addw	a4,a4,a3
    return 0;
    80002e1c:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002e1e:	0ad76063          	bltu	a4,a3,80002ebe <readi+0xd2>
  if(off + n > ip->size)
    80002e22:	00e7f463          	bgeu	a5,a4,80002e2a <readi+0x3e>
    n = ip->size - off;
    80002e26:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e2a:	0a0a8963          	beqz	s5,80002edc <readi+0xf0>
    80002e2e:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e30:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002e34:	5c7d                	li	s8,-1
    80002e36:	a82d                	j	80002e70 <readi+0x84>
    80002e38:	020d1d93          	sll	s11,s10,0x20
    80002e3c:	020ddd93          	srl	s11,s11,0x20
    80002e40:	05890613          	add	a2,s2,88
    80002e44:	86ee                	mv	a3,s11
    80002e46:	963a                	add	a2,a2,a4
    80002e48:	85d2                	mv	a1,s4
    80002e4a:	855e                	mv	a0,s7
    80002e4c:	fffff097          	auipc	ra,0xfffff
    80002e50:	b12080e7          	jalr	-1262(ra) # 8000195e <either_copyout>
    80002e54:	05850d63          	beq	a0,s8,80002eae <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002e58:	854a                	mv	a0,s2
    80002e5a:	fffff097          	auipc	ra,0xfffff
    80002e5e:	5fe080e7          	jalr	1534(ra) # 80002458 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e62:	013d09bb          	addw	s3,s10,s3
    80002e66:	009d04bb          	addw	s1,s10,s1
    80002e6a:	9a6e                	add	s4,s4,s11
    80002e6c:	0559f763          	bgeu	s3,s5,80002eba <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80002e70:	00a4d59b          	srlw	a1,s1,0xa
    80002e74:	855a                	mv	a0,s6
    80002e76:	00000097          	auipc	ra,0x0
    80002e7a:	8a4080e7          	jalr	-1884(ra) # 8000271a <bmap>
    80002e7e:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002e82:	cd85                	beqz	a1,80002eba <readi+0xce>
    bp = bread(ip->dev, addr);
    80002e84:	000b2503          	lw	a0,0(s6)
    80002e88:	fffff097          	auipc	ra,0xfffff
    80002e8c:	4a0080e7          	jalr	1184(ra) # 80002328 <bread>
    80002e90:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e92:	3ff4f713          	and	a4,s1,1023
    80002e96:	40ec87bb          	subw	a5,s9,a4
    80002e9a:	413a86bb          	subw	a3,s5,s3
    80002e9e:	8d3e                	mv	s10,a5
    80002ea0:	2781                	sext.w	a5,a5
    80002ea2:	0006861b          	sext.w	a2,a3
    80002ea6:	f8f679e3          	bgeu	a2,a5,80002e38 <readi+0x4c>
    80002eaa:	8d36                	mv	s10,a3
    80002eac:	b771                	j	80002e38 <readi+0x4c>
      brelse(bp);
    80002eae:	854a                	mv	a0,s2
    80002eb0:	fffff097          	auipc	ra,0xfffff
    80002eb4:	5a8080e7          	jalr	1448(ra) # 80002458 <brelse>
      tot = -1;
    80002eb8:	59fd                	li	s3,-1
  }
  return tot;
    80002eba:	0009851b          	sext.w	a0,s3
}
    80002ebe:	70a6                	ld	ra,104(sp)
    80002ec0:	7406                	ld	s0,96(sp)
    80002ec2:	64e6                	ld	s1,88(sp)
    80002ec4:	6946                	ld	s2,80(sp)
    80002ec6:	69a6                	ld	s3,72(sp)
    80002ec8:	6a06                	ld	s4,64(sp)
    80002eca:	7ae2                	ld	s5,56(sp)
    80002ecc:	7b42                	ld	s6,48(sp)
    80002ece:	7ba2                	ld	s7,40(sp)
    80002ed0:	7c02                	ld	s8,32(sp)
    80002ed2:	6ce2                	ld	s9,24(sp)
    80002ed4:	6d42                	ld	s10,16(sp)
    80002ed6:	6da2                	ld	s11,8(sp)
    80002ed8:	6165                	add	sp,sp,112
    80002eda:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002edc:	89d6                	mv	s3,s5
    80002ede:	bff1                	j	80002eba <readi+0xce>
    return 0;
    80002ee0:	4501                	li	a0,0
}
    80002ee2:	8082                	ret

0000000080002ee4 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002ee4:	457c                	lw	a5,76(a0)
    80002ee6:	10d7e863          	bltu	a5,a3,80002ff6 <writei+0x112>
{
    80002eea:	7159                	add	sp,sp,-112
    80002eec:	f486                	sd	ra,104(sp)
    80002eee:	f0a2                	sd	s0,96(sp)
    80002ef0:	eca6                	sd	s1,88(sp)
    80002ef2:	e8ca                	sd	s2,80(sp)
    80002ef4:	e4ce                	sd	s3,72(sp)
    80002ef6:	e0d2                	sd	s4,64(sp)
    80002ef8:	fc56                	sd	s5,56(sp)
    80002efa:	f85a                	sd	s6,48(sp)
    80002efc:	f45e                	sd	s7,40(sp)
    80002efe:	f062                	sd	s8,32(sp)
    80002f00:	ec66                	sd	s9,24(sp)
    80002f02:	e86a                	sd	s10,16(sp)
    80002f04:	e46e                	sd	s11,8(sp)
    80002f06:	1880                	add	s0,sp,112
    80002f08:	8aaa                	mv	s5,a0
    80002f0a:	8bae                	mv	s7,a1
    80002f0c:	8a32                	mv	s4,a2
    80002f0e:	8936                	mv	s2,a3
    80002f10:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002f12:	00e687bb          	addw	a5,a3,a4
    80002f16:	0ed7e263          	bltu	a5,a3,80002ffa <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002f1a:	00043737          	lui	a4,0x43
    80002f1e:	0ef76063          	bltu	a4,a5,80002ffe <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f22:	0c0b0863          	beqz	s6,80002ff2 <writei+0x10e>
    80002f26:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f28:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002f2c:	5c7d                	li	s8,-1
    80002f2e:	a091                	j	80002f72 <writei+0x8e>
    80002f30:	020d1d93          	sll	s11,s10,0x20
    80002f34:	020ddd93          	srl	s11,s11,0x20
    80002f38:	05848513          	add	a0,s1,88
    80002f3c:	86ee                	mv	a3,s11
    80002f3e:	8652                	mv	a2,s4
    80002f40:	85de                	mv	a1,s7
    80002f42:	953a                	add	a0,a0,a4
    80002f44:	fffff097          	auipc	ra,0xfffff
    80002f48:	a70080e7          	jalr	-1424(ra) # 800019b4 <either_copyin>
    80002f4c:	07850263          	beq	a0,s8,80002fb0 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002f50:	8526                	mv	a0,s1
    80002f52:	00000097          	auipc	ra,0x0
    80002f56:	75e080e7          	jalr	1886(ra) # 800036b0 <log_write>
    brelse(bp);
    80002f5a:	8526                	mv	a0,s1
    80002f5c:	fffff097          	auipc	ra,0xfffff
    80002f60:	4fc080e7          	jalr	1276(ra) # 80002458 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f64:	013d09bb          	addw	s3,s10,s3
    80002f68:	012d093b          	addw	s2,s10,s2
    80002f6c:	9a6e                	add	s4,s4,s11
    80002f6e:	0569f663          	bgeu	s3,s6,80002fba <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80002f72:	00a9559b          	srlw	a1,s2,0xa
    80002f76:	8556                	mv	a0,s5
    80002f78:	fffff097          	auipc	ra,0xfffff
    80002f7c:	7a2080e7          	jalr	1954(ra) # 8000271a <bmap>
    80002f80:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002f84:	c99d                	beqz	a1,80002fba <writei+0xd6>
    bp = bread(ip->dev, addr);
    80002f86:	000aa503          	lw	a0,0(s5)
    80002f8a:	fffff097          	auipc	ra,0xfffff
    80002f8e:	39e080e7          	jalr	926(ra) # 80002328 <bread>
    80002f92:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f94:	3ff97713          	and	a4,s2,1023
    80002f98:	40ec87bb          	subw	a5,s9,a4
    80002f9c:	413b06bb          	subw	a3,s6,s3
    80002fa0:	8d3e                	mv	s10,a5
    80002fa2:	2781                	sext.w	a5,a5
    80002fa4:	0006861b          	sext.w	a2,a3
    80002fa8:	f8f674e3          	bgeu	a2,a5,80002f30 <writei+0x4c>
    80002fac:	8d36                	mv	s10,a3
    80002fae:	b749                	j	80002f30 <writei+0x4c>
      brelse(bp);
    80002fb0:	8526                	mv	a0,s1
    80002fb2:	fffff097          	auipc	ra,0xfffff
    80002fb6:	4a6080e7          	jalr	1190(ra) # 80002458 <brelse>
  }

  if(off > ip->size)
    80002fba:	04caa783          	lw	a5,76(s5)
    80002fbe:	0127f463          	bgeu	a5,s2,80002fc6 <writei+0xe2>
    ip->size = off;
    80002fc2:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002fc6:	8556                	mv	a0,s5
    80002fc8:	00000097          	auipc	ra,0x0
    80002fcc:	aa4080e7          	jalr	-1372(ra) # 80002a6c <iupdate>

  return tot;
    80002fd0:	0009851b          	sext.w	a0,s3
}
    80002fd4:	70a6                	ld	ra,104(sp)
    80002fd6:	7406                	ld	s0,96(sp)
    80002fd8:	64e6                	ld	s1,88(sp)
    80002fda:	6946                	ld	s2,80(sp)
    80002fdc:	69a6                	ld	s3,72(sp)
    80002fde:	6a06                	ld	s4,64(sp)
    80002fe0:	7ae2                	ld	s5,56(sp)
    80002fe2:	7b42                	ld	s6,48(sp)
    80002fe4:	7ba2                	ld	s7,40(sp)
    80002fe6:	7c02                	ld	s8,32(sp)
    80002fe8:	6ce2                	ld	s9,24(sp)
    80002fea:	6d42                	ld	s10,16(sp)
    80002fec:	6da2                	ld	s11,8(sp)
    80002fee:	6165                	add	sp,sp,112
    80002ff0:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002ff2:	89da                	mv	s3,s6
    80002ff4:	bfc9                	j	80002fc6 <writei+0xe2>
    return -1;
    80002ff6:	557d                	li	a0,-1
}
    80002ff8:	8082                	ret
    return -1;
    80002ffa:	557d                	li	a0,-1
    80002ffc:	bfe1                	j	80002fd4 <writei+0xf0>
    return -1;
    80002ffe:	557d                	li	a0,-1
    80003000:	bfd1                	j	80002fd4 <writei+0xf0>

0000000080003002 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003002:	1141                	add	sp,sp,-16
    80003004:	e406                	sd	ra,8(sp)
    80003006:	e022                	sd	s0,0(sp)
    80003008:	0800                	add	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000300a:	4639                	li	a2,14
    8000300c:	ffffd097          	auipc	ra,0xffffd
    80003010:	23e080e7          	jalr	574(ra) # 8000024a <strncmp>
}
    80003014:	60a2                	ld	ra,8(sp)
    80003016:	6402                	ld	s0,0(sp)
    80003018:	0141                	add	sp,sp,16
    8000301a:	8082                	ret

000000008000301c <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000301c:	7139                	add	sp,sp,-64
    8000301e:	fc06                	sd	ra,56(sp)
    80003020:	f822                	sd	s0,48(sp)
    80003022:	f426                	sd	s1,40(sp)
    80003024:	f04a                	sd	s2,32(sp)
    80003026:	ec4e                	sd	s3,24(sp)
    80003028:	e852                	sd	s4,16(sp)
    8000302a:	0080                	add	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000302c:	04451703          	lh	a4,68(a0)
    80003030:	4785                	li	a5,1
    80003032:	00f71a63          	bne	a4,a5,80003046 <dirlookup+0x2a>
    80003036:	892a                	mv	s2,a0
    80003038:	89ae                	mv	s3,a1
    8000303a:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000303c:	457c                	lw	a5,76(a0)
    8000303e:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003040:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003042:	e79d                	bnez	a5,80003070 <dirlookup+0x54>
    80003044:	a8a5                	j	800030bc <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003046:	00005517          	auipc	a0,0x5
    8000304a:	56a50513          	add	a0,a0,1386 # 800085b0 <syscalls+0x1a0>
    8000304e:	00003097          	auipc	ra,0x3
    80003052:	b48080e7          	jalr	-1208(ra) # 80005b96 <panic>
      panic("dirlookup read");
    80003056:	00005517          	auipc	a0,0x5
    8000305a:	57250513          	add	a0,a0,1394 # 800085c8 <syscalls+0x1b8>
    8000305e:	00003097          	auipc	ra,0x3
    80003062:	b38080e7          	jalr	-1224(ra) # 80005b96 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003066:	24c1                	addw	s1,s1,16
    80003068:	04c92783          	lw	a5,76(s2)
    8000306c:	04f4f763          	bgeu	s1,a5,800030ba <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003070:	4741                	li	a4,16
    80003072:	86a6                	mv	a3,s1
    80003074:	fc040613          	add	a2,s0,-64
    80003078:	4581                	li	a1,0
    8000307a:	854a                	mv	a0,s2
    8000307c:	00000097          	auipc	ra,0x0
    80003080:	d70080e7          	jalr	-656(ra) # 80002dec <readi>
    80003084:	47c1                	li	a5,16
    80003086:	fcf518e3          	bne	a0,a5,80003056 <dirlookup+0x3a>
    if(de.inum == 0)
    8000308a:	fc045783          	lhu	a5,-64(s0)
    8000308e:	dfe1                	beqz	a5,80003066 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003090:	fc240593          	add	a1,s0,-62
    80003094:	854e                	mv	a0,s3
    80003096:	00000097          	auipc	ra,0x0
    8000309a:	f6c080e7          	jalr	-148(ra) # 80003002 <namecmp>
    8000309e:	f561                	bnez	a0,80003066 <dirlookup+0x4a>
      if(poff)
    800030a0:	000a0463          	beqz	s4,800030a8 <dirlookup+0x8c>
        *poff = off;
    800030a4:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800030a8:	fc045583          	lhu	a1,-64(s0)
    800030ac:	00092503          	lw	a0,0(s2)
    800030b0:	fffff097          	auipc	ra,0xfffff
    800030b4:	754080e7          	jalr	1876(ra) # 80002804 <iget>
    800030b8:	a011                	j	800030bc <dirlookup+0xa0>
  return 0;
    800030ba:	4501                	li	a0,0
}
    800030bc:	70e2                	ld	ra,56(sp)
    800030be:	7442                	ld	s0,48(sp)
    800030c0:	74a2                	ld	s1,40(sp)
    800030c2:	7902                	ld	s2,32(sp)
    800030c4:	69e2                	ld	s3,24(sp)
    800030c6:	6a42                	ld	s4,16(sp)
    800030c8:	6121                	add	sp,sp,64
    800030ca:	8082                	ret

00000000800030cc <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800030cc:	711d                	add	sp,sp,-96
    800030ce:	ec86                	sd	ra,88(sp)
    800030d0:	e8a2                	sd	s0,80(sp)
    800030d2:	e4a6                	sd	s1,72(sp)
    800030d4:	e0ca                	sd	s2,64(sp)
    800030d6:	fc4e                	sd	s3,56(sp)
    800030d8:	f852                	sd	s4,48(sp)
    800030da:	f456                	sd	s5,40(sp)
    800030dc:	f05a                	sd	s6,32(sp)
    800030de:	ec5e                	sd	s7,24(sp)
    800030e0:	e862                	sd	s8,16(sp)
    800030e2:	e466                	sd	s9,8(sp)
    800030e4:	1080                	add	s0,sp,96
    800030e6:	84aa                	mv	s1,a0
    800030e8:	8b2e                	mv	s6,a1
    800030ea:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800030ec:	00054703          	lbu	a4,0(a0)
    800030f0:	02f00793          	li	a5,47
    800030f4:	02f70263          	beq	a4,a5,80003118 <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800030f8:	ffffe097          	auipc	ra,0xffffe
    800030fc:	db2080e7          	jalr	-590(ra) # 80000eaa <myproc>
    80003100:	15053503          	ld	a0,336(a0)
    80003104:	00000097          	auipc	ra,0x0
    80003108:	9f6080e7          	jalr	-1546(ra) # 80002afa <idup>
    8000310c:	8a2a                	mv	s4,a0
  while(*path == '/')
    8000310e:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003112:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003114:	4b85                	li	s7,1
    80003116:	a875                	j	800031d2 <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    80003118:	4585                	li	a1,1
    8000311a:	4505                	li	a0,1
    8000311c:	fffff097          	auipc	ra,0xfffff
    80003120:	6e8080e7          	jalr	1768(ra) # 80002804 <iget>
    80003124:	8a2a                	mv	s4,a0
    80003126:	b7e5                	j	8000310e <namex+0x42>
      iunlockput(ip);
    80003128:	8552                	mv	a0,s4
    8000312a:	00000097          	auipc	ra,0x0
    8000312e:	c70080e7          	jalr	-912(ra) # 80002d9a <iunlockput>
      return 0;
    80003132:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003134:	8552                	mv	a0,s4
    80003136:	60e6                	ld	ra,88(sp)
    80003138:	6446                	ld	s0,80(sp)
    8000313a:	64a6                	ld	s1,72(sp)
    8000313c:	6906                	ld	s2,64(sp)
    8000313e:	79e2                	ld	s3,56(sp)
    80003140:	7a42                	ld	s4,48(sp)
    80003142:	7aa2                	ld	s5,40(sp)
    80003144:	7b02                	ld	s6,32(sp)
    80003146:	6be2                	ld	s7,24(sp)
    80003148:	6c42                	ld	s8,16(sp)
    8000314a:	6ca2                	ld	s9,8(sp)
    8000314c:	6125                	add	sp,sp,96
    8000314e:	8082                	ret
      iunlock(ip);
    80003150:	8552                	mv	a0,s4
    80003152:	00000097          	auipc	ra,0x0
    80003156:	aa8080e7          	jalr	-1368(ra) # 80002bfa <iunlock>
      return ip;
    8000315a:	bfe9                	j	80003134 <namex+0x68>
      iunlockput(ip);
    8000315c:	8552                	mv	a0,s4
    8000315e:	00000097          	auipc	ra,0x0
    80003162:	c3c080e7          	jalr	-964(ra) # 80002d9a <iunlockput>
      return 0;
    80003166:	8a4e                	mv	s4,s3
    80003168:	b7f1                	j	80003134 <namex+0x68>
  len = path - s;
    8000316a:	40998633          	sub	a2,s3,s1
    8000316e:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003172:	099c5863          	bge	s8,s9,80003202 <namex+0x136>
    memmove(name, s, DIRSIZ);
    80003176:	4639                	li	a2,14
    80003178:	85a6                	mv	a1,s1
    8000317a:	8556                	mv	a0,s5
    8000317c:	ffffd097          	auipc	ra,0xffffd
    80003180:	05a080e7          	jalr	90(ra) # 800001d6 <memmove>
    80003184:	84ce                	mv	s1,s3
  while(*path == '/')
    80003186:	0004c783          	lbu	a5,0(s1)
    8000318a:	01279763          	bne	a5,s2,80003198 <namex+0xcc>
    path++;
    8000318e:	0485                	add	s1,s1,1
  while(*path == '/')
    80003190:	0004c783          	lbu	a5,0(s1)
    80003194:	ff278de3          	beq	a5,s2,8000318e <namex+0xc2>
    ilock(ip);
    80003198:	8552                	mv	a0,s4
    8000319a:	00000097          	auipc	ra,0x0
    8000319e:	99e080e7          	jalr	-1634(ra) # 80002b38 <ilock>
    if(ip->type != T_DIR){
    800031a2:	044a1783          	lh	a5,68(s4)
    800031a6:	f97791e3          	bne	a5,s7,80003128 <namex+0x5c>
    if(nameiparent && *path == '\0'){
    800031aa:	000b0563          	beqz	s6,800031b4 <namex+0xe8>
    800031ae:	0004c783          	lbu	a5,0(s1)
    800031b2:	dfd9                	beqz	a5,80003150 <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    800031b4:	4601                	li	a2,0
    800031b6:	85d6                	mv	a1,s5
    800031b8:	8552                	mv	a0,s4
    800031ba:	00000097          	auipc	ra,0x0
    800031be:	e62080e7          	jalr	-414(ra) # 8000301c <dirlookup>
    800031c2:	89aa                	mv	s3,a0
    800031c4:	dd41                	beqz	a0,8000315c <namex+0x90>
    iunlockput(ip);
    800031c6:	8552                	mv	a0,s4
    800031c8:	00000097          	auipc	ra,0x0
    800031cc:	bd2080e7          	jalr	-1070(ra) # 80002d9a <iunlockput>
    ip = next;
    800031d0:	8a4e                	mv	s4,s3
  while(*path == '/')
    800031d2:	0004c783          	lbu	a5,0(s1)
    800031d6:	01279763          	bne	a5,s2,800031e4 <namex+0x118>
    path++;
    800031da:	0485                	add	s1,s1,1
  while(*path == '/')
    800031dc:	0004c783          	lbu	a5,0(s1)
    800031e0:	ff278de3          	beq	a5,s2,800031da <namex+0x10e>
  if(*path == 0)
    800031e4:	cb9d                	beqz	a5,8000321a <namex+0x14e>
  while(*path != '/' && *path != 0)
    800031e6:	0004c783          	lbu	a5,0(s1)
    800031ea:	89a6                	mv	s3,s1
  len = path - s;
    800031ec:	4c81                	li	s9,0
    800031ee:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    800031f0:	01278963          	beq	a5,s2,80003202 <namex+0x136>
    800031f4:	dbbd                	beqz	a5,8000316a <namex+0x9e>
    path++;
    800031f6:	0985                	add	s3,s3,1
  while(*path != '/' && *path != 0)
    800031f8:	0009c783          	lbu	a5,0(s3)
    800031fc:	ff279ce3          	bne	a5,s2,800031f4 <namex+0x128>
    80003200:	b7ad                	j	8000316a <namex+0x9e>
    memmove(name, s, len);
    80003202:	2601                	sext.w	a2,a2
    80003204:	85a6                	mv	a1,s1
    80003206:	8556                	mv	a0,s5
    80003208:	ffffd097          	auipc	ra,0xffffd
    8000320c:	fce080e7          	jalr	-50(ra) # 800001d6 <memmove>
    name[len] = 0;
    80003210:	9cd6                	add	s9,s9,s5
    80003212:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003216:	84ce                	mv	s1,s3
    80003218:	b7bd                	j	80003186 <namex+0xba>
  if(nameiparent){
    8000321a:	f00b0de3          	beqz	s6,80003134 <namex+0x68>
    iput(ip);
    8000321e:	8552                	mv	a0,s4
    80003220:	00000097          	auipc	ra,0x0
    80003224:	ad2080e7          	jalr	-1326(ra) # 80002cf2 <iput>
    return 0;
    80003228:	4a01                	li	s4,0
    8000322a:	b729                	j	80003134 <namex+0x68>

000000008000322c <dirlink>:
{
    8000322c:	7139                	add	sp,sp,-64
    8000322e:	fc06                	sd	ra,56(sp)
    80003230:	f822                	sd	s0,48(sp)
    80003232:	f426                	sd	s1,40(sp)
    80003234:	f04a                	sd	s2,32(sp)
    80003236:	ec4e                	sd	s3,24(sp)
    80003238:	e852                	sd	s4,16(sp)
    8000323a:	0080                	add	s0,sp,64
    8000323c:	892a                	mv	s2,a0
    8000323e:	8a2e                	mv	s4,a1
    80003240:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003242:	4601                	li	a2,0
    80003244:	00000097          	auipc	ra,0x0
    80003248:	dd8080e7          	jalr	-552(ra) # 8000301c <dirlookup>
    8000324c:	e93d                	bnez	a0,800032c2 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000324e:	04c92483          	lw	s1,76(s2)
    80003252:	c49d                	beqz	s1,80003280 <dirlink+0x54>
    80003254:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003256:	4741                	li	a4,16
    80003258:	86a6                	mv	a3,s1
    8000325a:	fc040613          	add	a2,s0,-64
    8000325e:	4581                	li	a1,0
    80003260:	854a                	mv	a0,s2
    80003262:	00000097          	auipc	ra,0x0
    80003266:	b8a080e7          	jalr	-1142(ra) # 80002dec <readi>
    8000326a:	47c1                	li	a5,16
    8000326c:	06f51163          	bne	a0,a5,800032ce <dirlink+0xa2>
    if(de.inum == 0)
    80003270:	fc045783          	lhu	a5,-64(s0)
    80003274:	c791                	beqz	a5,80003280 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003276:	24c1                	addw	s1,s1,16
    80003278:	04c92783          	lw	a5,76(s2)
    8000327c:	fcf4ede3          	bltu	s1,a5,80003256 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003280:	4639                	li	a2,14
    80003282:	85d2                	mv	a1,s4
    80003284:	fc240513          	add	a0,s0,-62
    80003288:	ffffd097          	auipc	ra,0xffffd
    8000328c:	ffe080e7          	jalr	-2(ra) # 80000286 <strncpy>
  de.inum = inum;
    80003290:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003294:	4741                	li	a4,16
    80003296:	86a6                	mv	a3,s1
    80003298:	fc040613          	add	a2,s0,-64
    8000329c:	4581                	li	a1,0
    8000329e:	854a                	mv	a0,s2
    800032a0:	00000097          	auipc	ra,0x0
    800032a4:	c44080e7          	jalr	-956(ra) # 80002ee4 <writei>
    800032a8:	1541                	add	a0,a0,-16
    800032aa:	00a03533          	snez	a0,a0
    800032ae:	40a00533          	neg	a0,a0
}
    800032b2:	70e2                	ld	ra,56(sp)
    800032b4:	7442                	ld	s0,48(sp)
    800032b6:	74a2                	ld	s1,40(sp)
    800032b8:	7902                	ld	s2,32(sp)
    800032ba:	69e2                	ld	s3,24(sp)
    800032bc:	6a42                	ld	s4,16(sp)
    800032be:	6121                	add	sp,sp,64
    800032c0:	8082                	ret
    iput(ip);
    800032c2:	00000097          	auipc	ra,0x0
    800032c6:	a30080e7          	jalr	-1488(ra) # 80002cf2 <iput>
    return -1;
    800032ca:	557d                	li	a0,-1
    800032cc:	b7dd                	j	800032b2 <dirlink+0x86>
      panic("dirlink read");
    800032ce:	00005517          	auipc	a0,0x5
    800032d2:	30a50513          	add	a0,a0,778 # 800085d8 <syscalls+0x1c8>
    800032d6:	00003097          	auipc	ra,0x3
    800032da:	8c0080e7          	jalr	-1856(ra) # 80005b96 <panic>

00000000800032de <namei>:

struct inode*
namei(char *path)
{
    800032de:	1101                	add	sp,sp,-32
    800032e0:	ec06                	sd	ra,24(sp)
    800032e2:	e822                	sd	s0,16(sp)
    800032e4:	1000                	add	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800032e6:	fe040613          	add	a2,s0,-32
    800032ea:	4581                	li	a1,0
    800032ec:	00000097          	auipc	ra,0x0
    800032f0:	de0080e7          	jalr	-544(ra) # 800030cc <namex>
}
    800032f4:	60e2                	ld	ra,24(sp)
    800032f6:	6442                	ld	s0,16(sp)
    800032f8:	6105                	add	sp,sp,32
    800032fa:	8082                	ret

00000000800032fc <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800032fc:	1141                	add	sp,sp,-16
    800032fe:	e406                	sd	ra,8(sp)
    80003300:	e022                	sd	s0,0(sp)
    80003302:	0800                	add	s0,sp,16
    80003304:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003306:	4585                	li	a1,1
    80003308:	00000097          	auipc	ra,0x0
    8000330c:	dc4080e7          	jalr	-572(ra) # 800030cc <namex>
}
    80003310:	60a2                	ld	ra,8(sp)
    80003312:	6402                	ld	s0,0(sp)
    80003314:	0141                	add	sp,sp,16
    80003316:	8082                	ret

0000000080003318 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003318:	1101                	add	sp,sp,-32
    8000331a:	ec06                	sd	ra,24(sp)
    8000331c:	e822                	sd	s0,16(sp)
    8000331e:	e426                	sd	s1,8(sp)
    80003320:	e04a                	sd	s2,0(sp)
    80003322:	1000                	add	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003324:	00015917          	auipc	s2,0x15
    80003328:	5cc90913          	add	s2,s2,1484 # 800188f0 <log>
    8000332c:	01892583          	lw	a1,24(s2)
    80003330:	02892503          	lw	a0,40(s2)
    80003334:	fffff097          	auipc	ra,0xfffff
    80003338:	ff4080e7          	jalr	-12(ra) # 80002328 <bread>
    8000333c:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    8000333e:	02c92603          	lw	a2,44(s2)
    80003342:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003344:	00c05f63          	blez	a2,80003362 <write_head+0x4a>
    80003348:	00015717          	auipc	a4,0x15
    8000334c:	5d870713          	add	a4,a4,1496 # 80018920 <log+0x30>
    80003350:	87aa                	mv	a5,a0
    80003352:	060a                	sll	a2,a2,0x2
    80003354:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003356:	4314                	lw	a3,0(a4)
    80003358:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    8000335a:	0711                	add	a4,a4,4
    8000335c:	0791                	add	a5,a5,4
    8000335e:	fec79ce3          	bne	a5,a2,80003356 <write_head+0x3e>
  }
  bwrite(buf);
    80003362:	8526                	mv	a0,s1
    80003364:	fffff097          	auipc	ra,0xfffff
    80003368:	0b6080e7          	jalr	182(ra) # 8000241a <bwrite>
  brelse(buf);
    8000336c:	8526                	mv	a0,s1
    8000336e:	fffff097          	auipc	ra,0xfffff
    80003372:	0ea080e7          	jalr	234(ra) # 80002458 <brelse>
}
    80003376:	60e2                	ld	ra,24(sp)
    80003378:	6442                	ld	s0,16(sp)
    8000337a:	64a2                	ld	s1,8(sp)
    8000337c:	6902                	ld	s2,0(sp)
    8000337e:	6105                	add	sp,sp,32
    80003380:	8082                	ret

0000000080003382 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003382:	00015797          	auipc	a5,0x15
    80003386:	59a7a783          	lw	a5,1434(a5) # 8001891c <log+0x2c>
    8000338a:	0af05d63          	blez	a5,80003444 <install_trans+0xc2>
{
    8000338e:	7139                	add	sp,sp,-64
    80003390:	fc06                	sd	ra,56(sp)
    80003392:	f822                	sd	s0,48(sp)
    80003394:	f426                	sd	s1,40(sp)
    80003396:	f04a                	sd	s2,32(sp)
    80003398:	ec4e                	sd	s3,24(sp)
    8000339a:	e852                	sd	s4,16(sp)
    8000339c:	e456                	sd	s5,8(sp)
    8000339e:	e05a                	sd	s6,0(sp)
    800033a0:	0080                	add	s0,sp,64
    800033a2:	8b2a                	mv	s6,a0
    800033a4:	00015a97          	auipc	s5,0x15
    800033a8:	57ca8a93          	add	s5,s5,1404 # 80018920 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800033ac:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800033ae:	00015997          	auipc	s3,0x15
    800033b2:	54298993          	add	s3,s3,1346 # 800188f0 <log>
    800033b6:	a00d                	j	800033d8 <install_trans+0x56>
    brelse(lbuf);
    800033b8:	854a                	mv	a0,s2
    800033ba:	fffff097          	auipc	ra,0xfffff
    800033be:	09e080e7          	jalr	158(ra) # 80002458 <brelse>
    brelse(dbuf);
    800033c2:	8526                	mv	a0,s1
    800033c4:	fffff097          	auipc	ra,0xfffff
    800033c8:	094080e7          	jalr	148(ra) # 80002458 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800033cc:	2a05                	addw	s4,s4,1
    800033ce:	0a91                	add	s5,s5,4
    800033d0:	02c9a783          	lw	a5,44(s3)
    800033d4:	04fa5e63          	bge	s4,a5,80003430 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800033d8:	0189a583          	lw	a1,24(s3)
    800033dc:	014585bb          	addw	a1,a1,s4
    800033e0:	2585                	addw	a1,a1,1
    800033e2:	0289a503          	lw	a0,40(s3)
    800033e6:	fffff097          	auipc	ra,0xfffff
    800033ea:	f42080e7          	jalr	-190(ra) # 80002328 <bread>
    800033ee:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800033f0:	000aa583          	lw	a1,0(s5)
    800033f4:	0289a503          	lw	a0,40(s3)
    800033f8:	fffff097          	auipc	ra,0xfffff
    800033fc:	f30080e7          	jalr	-208(ra) # 80002328 <bread>
    80003400:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003402:	40000613          	li	a2,1024
    80003406:	05890593          	add	a1,s2,88
    8000340a:	05850513          	add	a0,a0,88
    8000340e:	ffffd097          	auipc	ra,0xffffd
    80003412:	dc8080e7          	jalr	-568(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003416:	8526                	mv	a0,s1
    80003418:	fffff097          	auipc	ra,0xfffff
    8000341c:	002080e7          	jalr	2(ra) # 8000241a <bwrite>
    if(recovering == 0)
    80003420:	f80b1ce3          	bnez	s6,800033b8 <install_trans+0x36>
      bunpin(dbuf);
    80003424:	8526                	mv	a0,s1
    80003426:	fffff097          	auipc	ra,0xfffff
    8000342a:	10a080e7          	jalr	266(ra) # 80002530 <bunpin>
    8000342e:	b769                	j	800033b8 <install_trans+0x36>
}
    80003430:	70e2                	ld	ra,56(sp)
    80003432:	7442                	ld	s0,48(sp)
    80003434:	74a2                	ld	s1,40(sp)
    80003436:	7902                	ld	s2,32(sp)
    80003438:	69e2                	ld	s3,24(sp)
    8000343a:	6a42                	ld	s4,16(sp)
    8000343c:	6aa2                	ld	s5,8(sp)
    8000343e:	6b02                	ld	s6,0(sp)
    80003440:	6121                	add	sp,sp,64
    80003442:	8082                	ret
    80003444:	8082                	ret

0000000080003446 <initlog>:
{
    80003446:	7179                	add	sp,sp,-48
    80003448:	f406                	sd	ra,40(sp)
    8000344a:	f022                	sd	s0,32(sp)
    8000344c:	ec26                	sd	s1,24(sp)
    8000344e:	e84a                	sd	s2,16(sp)
    80003450:	e44e                	sd	s3,8(sp)
    80003452:	1800                	add	s0,sp,48
    80003454:	892a                	mv	s2,a0
    80003456:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003458:	00015497          	auipc	s1,0x15
    8000345c:	49848493          	add	s1,s1,1176 # 800188f0 <log>
    80003460:	00005597          	auipc	a1,0x5
    80003464:	18858593          	add	a1,a1,392 # 800085e8 <syscalls+0x1d8>
    80003468:	8526                	mv	a0,s1
    8000346a:	00003097          	auipc	ra,0x3
    8000346e:	bd4080e7          	jalr	-1068(ra) # 8000603e <initlock>
  log.start = sb->logstart;
    80003472:	0149a583          	lw	a1,20(s3)
    80003476:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003478:	0109a783          	lw	a5,16(s3)
    8000347c:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000347e:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003482:	854a                	mv	a0,s2
    80003484:	fffff097          	auipc	ra,0xfffff
    80003488:	ea4080e7          	jalr	-348(ra) # 80002328 <bread>
  log.lh.n = lh->n;
    8000348c:	4d30                	lw	a2,88(a0)
    8000348e:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003490:	00c05f63          	blez	a2,800034ae <initlog+0x68>
    80003494:	87aa                	mv	a5,a0
    80003496:	00015717          	auipc	a4,0x15
    8000349a:	48a70713          	add	a4,a4,1162 # 80018920 <log+0x30>
    8000349e:	060a                	sll	a2,a2,0x2
    800034a0:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800034a2:	4ff4                	lw	a3,92(a5)
    800034a4:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800034a6:	0791                	add	a5,a5,4
    800034a8:	0711                	add	a4,a4,4
    800034aa:	fec79ce3          	bne	a5,a2,800034a2 <initlog+0x5c>
  brelse(buf);
    800034ae:	fffff097          	auipc	ra,0xfffff
    800034b2:	faa080e7          	jalr	-86(ra) # 80002458 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800034b6:	4505                	li	a0,1
    800034b8:	00000097          	auipc	ra,0x0
    800034bc:	eca080e7          	jalr	-310(ra) # 80003382 <install_trans>
  log.lh.n = 0;
    800034c0:	00015797          	auipc	a5,0x15
    800034c4:	4407ae23          	sw	zero,1116(a5) # 8001891c <log+0x2c>
  write_head(); // clear the log
    800034c8:	00000097          	auipc	ra,0x0
    800034cc:	e50080e7          	jalr	-432(ra) # 80003318 <write_head>
}
    800034d0:	70a2                	ld	ra,40(sp)
    800034d2:	7402                	ld	s0,32(sp)
    800034d4:	64e2                	ld	s1,24(sp)
    800034d6:	6942                	ld	s2,16(sp)
    800034d8:	69a2                	ld	s3,8(sp)
    800034da:	6145                	add	sp,sp,48
    800034dc:	8082                	ret

00000000800034de <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800034de:	1101                	add	sp,sp,-32
    800034e0:	ec06                	sd	ra,24(sp)
    800034e2:	e822                	sd	s0,16(sp)
    800034e4:	e426                	sd	s1,8(sp)
    800034e6:	e04a                	sd	s2,0(sp)
    800034e8:	1000                	add	s0,sp,32
  acquire(&log.lock);
    800034ea:	00015517          	auipc	a0,0x15
    800034ee:	40650513          	add	a0,a0,1030 # 800188f0 <log>
    800034f2:	00003097          	auipc	ra,0x3
    800034f6:	bdc080e7          	jalr	-1060(ra) # 800060ce <acquire>
  while(1){
    if(log.committing){
    800034fa:	00015497          	auipc	s1,0x15
    800034fe:	3f648493          	add	s1,s1,1014 # 800188f0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003502:	4979                	li	s2,30
    80003504:	a039                	j	80003512 <begin_op+0x34>
      sleep(&log, &log.lock);
    80003506:	85a6                	mv	a1,s1
    80003508:	8526                	mv	a0,s1
    8000350a:	ffffe097          	auipc	ra,0xffffe
    8000350e:	04c080e7          	jalr	76(ra) # 80001556 <sleep>
    if(log.committing){
    80003512:	50dc                	lw	a5,36(s1)
    80003514:	fbed                	bnez	a5,80003506 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003516:	5098                	lw	a4,32(s1)
    80003518:	2705                	addw	a4,a4,1
    8000351a:	0027179b          	sllw	a5,a4,0x2
    8000351e:	9fb9                	addw	a5,a5,a4
    80003520:	0017979b          	sllw	a5,a5,0x1
    80003524:	54d4                	lw	a3,44(s1)
    80003526:	9fb5                	addw	a5,a5,a3
    80003528:	00f95963          	bge	s2,a5,8000353a <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000352c:	85a6                	mv	a1,s1
    8000352e:	8526                	mv	a0,s1
    80003530:	ffffe097          	auipc	ra,0xffffe
    80003534:	026080e7          	jalr	38(ra) # 80001556 <sleep>
    80003538:	bfe9                	j	80003512 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000353a:	00015517          	auipc	a0,0x15
    8000353e:	3b650513          	add	a0,a0,950 # 800188f0 <log>
    80003542:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003544:	00003097          	auipc	ra,0x3
    80003548:	c3e080e7          	jalr	-962(ra) # 80006182 <release>
      break;
    }
  }
}
    8000354c:	60e2                	ld	ra,24(sp)
    8000354e:	6442                	ld	s0,16(sp)
    80003550:	64a2                	ld	s1,8(sp)
    80003552:	6902                	ld	s2,0(sp)
    80003554:	6105                	add	sp,sp,32
    80003556:	8082                	ret

0000000080003558 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003558:	7139                	add	sp,sp,-64
    8000355a:	fc06                	sd	ra,56(sp)
    8000355c:	f822                	sd	s0,48(sp)
    8000355e:	f426                	sd	s1,40(sp)
    80003560:	f04a                	sd	s2,32(sp)
    80003562:	ec4e                	sd	s3,24(sp)
    80003564:	e852                	sd	s4,16(sp)
    80003566:	e456                	sd	s5,8(sp)
    80003568:	0080                	add	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000356a:	00015497          	auipc	s1,0x15
    8000356e:	38648493          	add	s1,s1,902 # 800188f0 <log>
    80003572:	8526                	mv	a0,s1
    80003574:	00003097          	auipc	ra,0x3
    80003578:	b5a080e7          	jalr	-1190(ra) # 800060ce <acquire>
  log.outstanding -= 1;
    8000357c:	509c                	lw	a5,32(s1)
    8000357e:	37fd                	addw	a5,a5,-1
    80003580:	0007891b          	sext.w	s2,a5
    80003584:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003586:	50dc                	lw	a5,36(s1)
    80003588:	e7b9                	bnez	a5,800035d6 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    8000358a:	04091e63          	bnez	s2,800035e6 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    8000358e:	00015497          	auipc	s1,0x15
    80003592:	36248493          	add	s1,s1,866 # 800188f0 <log>
    80003596:	4785                	li	a5,1
    80003598:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000359a:	8526                	mv	a0,s1
    8000359c:	00003097          	auipc	ra,0x3
    800035a0:	be6080e7          	jalr	-1050(ra) # 80006182 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800035a4:	54dc                	lw	a5,44(s1)
    800035a6:	06f04763          	bgtz	a5,80003614 <end_op+0xbc>
    acquire(&log.lock);
    800035aa:	00015497          	auipc	s1,0x15
    800035ae:	34648493          	add	s1,s1,838 # 800188f0 <log>
    800035b2:	8526                	mv	a0,s1
    800035b4:	00003097          	auipc	ra,0x3
    800035b8:	b1a080e7          	jalr	-1254(ra) # 800060ce <acquire>
    log.committing = 0;
    800035bc:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800035c0:	8526                	mv	a0,s1
    800035c2:	ffffe097          	auipc	ra,0xffffe
    800035c6:	ff8080e7          	jalr	-8(ra) # 800015ba <wakeup>
    release(&log.lock);
    800035ca:	8526                	mv	a0,s1
    800035cc:	00003097          	auipc	ra,0x3
    800035d0:	bb6080e7          	jalr	-1098(ra) # 80006182 <release>
}
    800035d4:	a03d                	j	80003602 <end_op+0xaa>
    panic("log.committing");
    800035d6:	00005517          	auipc	a0,0x5
    800035da:	01a50513          	add	a0,a0,26 # 800085f0 <syscalls+0x1e0>
    800035de:	00002097          	auipc	ra,0x2
    800035e2:	5b8080e7          	jalr	1464(ra) # 80005b96 <panic>
    wakeup(&log);
    800035e6:	00015497          	auipc	s1,0x15
    800035ea:	30a48493          	add	s1,s1,778 # 800188f0 <log>
    800035ee:	8526                	mv	a0,s1
    800035f0:	ffffe097          	auipc	ra,0xffffe
    800035f4:	fca080e7          	jalr	-54(ra) # 800015ba <wakeup>
  release(&log.lock);
    800035f8:	8526                	mv	a0,s1
    800035fa:	00003097          	auipc	ra,0x3
    800035fe:	b88080e7          	jalr	-1144(ra) # 80006182 <release>
}
    80003602:	70e2                	ld	ra,56(sp)
    80003604:	7442                	ld	s0,48(sp)
    80003606:	74a2                	ld	s1,40(sp)
    80003608:	7902                	ld	s2,32(sp)
    8000360a:	69e2                	ld	s3,24(sp)
    8000360c:	6a42                	ld	s4,16(sp)
    8000360e:	6aa2                	ld	s5,8(sp)
    80003610:	6121                	add	sp,sp,64
    80003612:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80003614:	00015a97          	auipc	s5,0x15
    80003618:	30ca8a93          	add	s5,s5,780 # 80018920 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000361c:	00015a17          	auipc	s4,0x15
    80003620:	2d4a0a13          	add	s4,s4,724 # 800188f0 <log>
    80003624:	018a2583          	lw	a1,24(s4)
    80003628:	012585bb          	addw	a1,a1,s2
    8000362c:	2585                	addw	a1,a1,1
    8000362e:	028a2503          	lw	a0,40(s4)
    80003632:	fffff097          	auipc	ra,0xfffff
    80003636:	cf6080e7          	jalr	-778(ra) # 80002328 <bread>
    8000363a:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000363c:	000aa583          	lw	a1,0(s5)
    80003640:	028a2503          	lw	a0,40(s4)
    80003644:	fffff097          	auipc	ra,0xfffff
    80003648:	ce4080e7          	jalr	-796(ra) # 80002328 <bread>
    8000364c:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000364e:	40000613          	li	a2,1024
    80003652:	05850593          	add	a1,a0,88
    80003656:	05848513          	add	a0,s1,88
    8000365a:	ffffd097          	auipc	ra,0xffffd
    8000365e:	b7c080e7          	jalr	-1156(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    80003662:	8526                	mv	a0,s1
    80003664:	fffff097          	auipc	ra,0xfffff
    80003668:	db6080e7          	jalr	-586(ra) # 8000241a <bwrite>
    brelse(from);
    8000366c:	854e                	mv	a0,s3
    8000366e:	fffff097          	auipc	ra,0xfffff
    80003672:	dea080e7          	jalr	-534(ra) # 80002458 <brelse>
    brelse(to);
    80003676:	8526                	mv	a0,s1
    80003678:	fffff097          	auipc	ra,0xfffff
    8000367c:	de0080e7          	jalr	-544(ra) # 80002458 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003680:	2905                	addw	s2,s2,1
    80003682:	0a91                	add	s5,s5,4
    80003684:	02ca2783          	lw	a5,44(s4)
    80003688:	f8f94ee3          	blt	s2,a5,80003624 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000368c:	00000097          	auipc	ra,0x0
    80003690:	c8c080e7          	jalr	-884(ra) # 80003318 <write_head>
    install_trans(0); // Now install writes to home locations
    80003694:	4501                	li	a0,0
    80003696:	00000097          	auipc	ra,0x0
    8000369a:	cec080e7          	jalr	-788(ra) # 80003382 <install_trans>
    log.lh.n = 0;
    8000369e:	00015797          	auipc	a5,0x15
    800036a2:	2607af23          	sw	zero,638(a5) # 8001891c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800036a6:	00000097          	auipc	ra,0x0
    800036aa:	c72080e7          	jalr	-910(ra) # 80003318 <write_head>
    800036ae:	bdf5                	j	800035aa <end_op+0x52>

00000000800036b0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800036b0:	1101                	add	sp,sp,-32
    800036b2:	ec06                	sd	ra,24(sp)
    800036b4:	e822                	sd	s0,16(sp)
    800036b6:	e426                	sd	s1,8(sp)
    800036b8:	e04a                	sd	s2,0(sp)
    800036ba:	1000                	add	s0,sp,32
    800036bc:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800036be:	00015917          	auipc	s2,0x15
    800036c2:	23290913          	add	s2,s2,562 # 800188f0 <log>
    800036c6:	854a                	mv	a0,s2
    800036c8:	00003097          	auipc	ra,0x3
    800036cc:	a06080e7          	jalr	-1530(ra) # 800060ce <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800036d0:	02c92603          	lw	a2,44(s2)
    800036d4:	47f5                	li	a5,29
    800036d6:	06c7c563          	blt	a5,a2,80003740 <log_write+0x90>
    800036da:	00015797          	auipc	a5,0x15
    800036de:	2327a783          	lw	a5,562(a5) # 8001890c <log+0x1c>
    800036e2:	37fd                	addw	a5,a5,-1
    800036e4:	04f65e63          	bge	a2,a5,80003740 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800036e8:	00015797          	auipc	a5,0x15
    800036ec:	2287a783          	lw	a5,552(a5) # 80018910 <log+0x20>
    800036f0:	06f05063          	blez	a5,80003750 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800036f4:	4781                	li	a5,0
    800036f6:	06c05563          	blez	a2,80003760 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800036fa:	44cc                	lw	a1,12(s1)
    800036fc:	00015717          	auipc	a4,0x15
    80003700:	22470713          	add	a4,a4,548 # 80018920 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003704:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003706:	4314                	lw	a3,0(a4)
    80003708:	04b68c63          	beq	a3,a1,80003760 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000370c:	2785                	addw	a5,a5,1
    8000370e:	0711                	add	a4,a4,4
    80003710:	fef61be3          	bne	a2,a5,80003706 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003714:	0621                	add	a2,a2,8
    80003716:	060a                	sll	a2,a2,0x2
    80003718:	00015797          	auipc	a5,0x15
    8000371c:	1d878793          	add	a5,a5,472 # 800188f0 <log>
    80003720:	97b2                	add	a5,a5,a2
    80003722:	44d8                	lw	a4,12(s1)
    80003724:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003726:	8526                	mv	a0,s1
    80003728:	fffff097          	auipc	ra,0xfffff
    8000372c:	dcc080e7          	jalr	-564(ra) # 800024f4 <bpin>
    log.lh.n++;
    80003730:	00015717          	auipc	a4,0x15
    80003734:	1c070713          	add	a4,a4,448 # 800188f0 <log>
    80003738:	575c                	lw	a5,44(a4)
    8000373a:	2785                	addw	a5,a5,1
    8000373c:	d75c                	sw	a5,44(a4)
    8000373e:	a82d                	j	80003778 <log_write+0xc8>
    panic("too big a transaction");
    80003740:	00005517          	auipc	a0,0x5
    80003744:	ec050513          	add	a0,a0,-320 # 80008600 <syscalls+0x1f0>
    80003748:	00002097          	auipc	ra,0x2
    8000374c:	44e080e7          	jalr	1102(ra) # 80005b96 <panic>
    panic("log_write outside of trans");
    80003750:	00005517          	auipc	a0,0x5
    80003754:	ec850513          	add	a0,a0,-312 # 80008618 <syscalls+0x208>
    80003758:	00002097          	auipc	ra,0x2
    8000375c:	43e080e7          	jalr	1086(ra) # 80005b96 <panic>
  log.lh.block[i] = b->blockno;
    80003760:	00878693          	add	a3,a5,8
    80003764:	068a                	sll	a3,a3,0x2
    80003766:	00015717          	auipc	a4,0x15
    8000376a:	18a70713          	add	a4,a4,394 # 800188f0 <log>
    8000376e:	9736                	add	a4,a4,a3
    80003770:	44d4                	lw	a3,12(s1)
    80003772:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003774:	faf609e3          	beq	a2,a5,80003726 <log_write+0x76>
  }
  release(&log.lock);
    80003778:	00015517          	auipc	a0,0x15
    8000377c:	17850513          	add	a0,a0,376 # 800188f0 <log>
    80003780:	00003097          	auipc	ra,0x3
    80003784:	a02080e7          	jalr	-1534(ra) # 80006182 <release>
}
    80003788:	60e2                	ld	ra,24(sp)
    8000378a:	6442                	ld	s0,16(sp)
    8000378c:	64a2                	ld	s1,8(sp)
    8000378e:	6902                	ld	s2,0(sp)
    80003790:	6105                	add	sp,sp,32
    80003792:	8082                	ret

0000000080003794 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003794:	1101                	add	sp,sp,-32
    80003796:	ec06                	sd	ra,24(sp)
    80003798:	e822                	sd	s0,16(sp)
    8000379a:	e426                	sd	s1,8(sp)
    8000379c:	e04a                	sd	s2,0(sp)
    8000379e:	1000                	add	s0,sp,32
    800037a0:	84aa                	mv	s1,a0
    800037a2:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800037a4:	00005597          	auipc	a1,0x5
    800037a8:	e9458593          	add	a1,a1,-364 # 80008638 <syscalls+0x228>
    800037ac:	0521                	add	a0,a0,8
    800037ae:	00003097          	auipc	ra,0x3
    800037b2:	890080e7          	jalr	-1904(ra) # 8000603e <initlock>
  lk->name = name;
    800037b6:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800037ba:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800037be:	0204a423          	sw	zero,40(s1)
}
    800037c2:	60e2                	ld	ra,24(sp)
    800037c4:	6442                	ld	s0,16(sp)
    800037c6:	64a2                	ld	s1,8(sp)
    800037c8:	6902                	ld	s2,0(sp)
    800037ca:	6105                	add	sp,sp,32
    800037cc:	8082                	ret

00000000800037ce <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800037ce:	1101                	add	sp,sp,-32
    800037d0:	ec06                	sd	ra,24(sp)
    800037d2:	e822                	sd	s0,16(sp)
    800037d4:	e426                	sd	s1,8(sp)
    800037d6:	e04a                	sd	s2,0(sp)
    800037d8:	1000                	add	s0,sp,32
    800037da:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800037dc:	00850913          	add	s2,a0,8
    800037e0:	854a                	mv	a0,s2
    800037e2:	00003097          	auipc	ra,0x3
    800037e6:	8ec080e7          	jalr	-1812(ra) # 800060ce <acquire>
  while (lk->locked) {
    800037ea:	409c                	lw	a5,0(s1)
    800037ec:	cb89                	beqz	a5,800037fe <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800037ee:	85ca                	mv	a1,s2
    800037f0:	8526                	mv	a0,s1
    800037f2:	ffffe097          	auipc	ra,0xffffe
    800037f6:	d64080e7          	jalr	-668(ra) # 80001556 <sleep>
  while (lk->locked) {
    800037fa:	409c                	lw	a5,0(s1)
    800037fc:	fbed                	bnez	a5,800037ee <acquiresleep+0x20>
  }
  lk->locked = 1;
    800037fe:	4785                	li	a5,1
    80003800:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003802:	ffffd097          	auipc	ra,0xffffd
    80003806:	6a8080e7          	jalr	1704(ra) # 80000eaa <myproc>
    8000380a:	591c                	lw	a5,48(a0)
    8000380c:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000380e:	854a                	mv	a0,s2
    80003810:	00003097          	auipc	ra,0x3
    80003814:	972080e7          	jalr	-1678(ra) # 80006182 <release>
}
    80003818:	60e2                	ld	ra,24(sp)
    8000381a:	6442                	ld	s0,16(sp)
    8000381c:	64a2                	ld	s1,8(sp)
    8000381e:	6902                	ld	s2,0(sp)
    80003820:	6105                	add	sp,sp,32
    80003822:	8082                	ret

0000000080003824 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003824:	1101                	add	sp,sp,-32
    80003826:	ec06                	sd	ra,24(sp)
    80003828:	e822                	sd	s0,16(sp)
    8000382a:	e426                	sd	s1,8(sp)
    8000382c:	e04a                	sd	s2,0(sp)
    8000382e:	1000                	add	s0,sp,32
    80003830:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003832:	00850913          	add	s2,a0,8
    80003836:	854a                	mv	a0,s2
    80003838:	00003097          	auipc	ra,0x3
    8000383c:	896080e7          	jalr	-1898(ra) # 800060ce <acquire>
  lk->locked = 0;
    80003840:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003844:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003848:	8526                	mv	a0,s1
    8000384a:	ffffe097          	auipc	ra,0xffffe
    8000384e:	d70080e7          	jalr	-656(ra) # 800015ba <wakeup>
  release(&lk->lk);
    80003852:	854a                	mv	a0,s2
    80003854:	00003097          	auipc	ra,0x3
    80003858:	92e080e7          	jalr	-1746(ra) # 80006182 <release>
}
    8000385c:	60e2                	ld	ra,24(sp)
    8000385e:	6442                	ld	s0,16(sp)
    80003860:	64a2                	ld	s1,8(sp)
    80003862:	6902                	ld	s2,0(sp)
    80003864:	6105                	add	sp,sp,32
    80003866:	8082                	ret

0000000080003868 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003868:	7179                	add	sp,sp,-48
    8000386a:	f406                	sd	ra,40(sp)
    8000386c:	f022                	sd	s0,32(sp)
    8000386e:	ec26                	sd	s1,24(sp)
    80003870:	e84a                	sd	s2,16(sp)
    80003872:	e44e                	sd	s3,8(sp)
    80003874:	1800                	add	s0,sp,48
    80003876:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003878:	00850913          	add	s2,a0,8
    8000387c:	854a                	mv	a0,s2
    8000387e:	00003097          	auipc	ra,0x3
    80003882:	850080e7          	jalr	-1968(ra) # 800060ce <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003886:	409c                	lw	a5,0(s1)
    80003888:	ef99                	bnez	a5,800038a6 <holdingsleep+0x3e>
    8000388a:	4481                	li	s1,0
  release(&lk->lk);
    8000388c:	854a                	mv	a0,s2
    8000388e:	00003097          	auipc	ra,0x3
    80003892:	8f4080e7          	jalr	-1804(ra) # 80006182 <release>
  return r;
}
    80003896:	8526                	mv	a0,s1
    80003898:	70a2                	ld	ra,40(sp)
    8000389a:	7402                	ld	s0,32(sp)
    8000389c:	64e2                	ld	s1,24(sp)
    8000389e:	6942                	ld	s2,16(sp)
    800038a0:	69a2                	ld	s3,8(sp)
    800038a2:	6145                	add	sp,sp,48
    800038a4:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    800038a6:	0284a983          	lw	s3,40(s1)
    800038aa:	ffffd097          	auipc	ra,0xffffd
    800038ae:	600080e7          	jalr	1536(ra) # 80000eaa <myproc>
    800038b2:	5904                	lw	s1,48(a0)
    800038b4:	413484b3          	sub	s1,s1,s3
    800038b8:	0014b493          	seqz	s1,s1
    800038bc:	bfc1                	j	8000388c <holdingsleep+0x24>

00000000800038be <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800038be:	1141                	add	sp,sp,-16
    800038c0:	e406                	sd	ra,8(sp)
    800038c2:	e022                	sd	s0,0(sp)
    800038c4:	0800                	add	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800038c6:	00005597          	auipc	a1,0x5
    800038ca:	d8258593          	add	a1,a1,-638 # 80008648 <syscalls+0x238>
    800038ce:	00015517          	auipc	a0,0x15
    800038d2:	16a50513          	add	a0,a0,362 # 80018a38 <ftable>
    800038d6:	00002097          	auipc	ra,0x2
    800038da:	768080e7          	jalr	1896(ra) # 8000603e <initlock>
}
    800038de:	60a2                	ld	ra,8(sp)
    800038e0:	6402                	ld	s0,0(sp)
    800038e2:	0141                	add	sp,sp,16
    800038e4:	8082                	ret

00000000800038e6 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800038e6:	1101                	add	sp,sp,-32
    800038e8:	ec06                	sd	ra,24(sp)
    800038ea:	e822                	sd	s0,16(sp)
    800038ec:	e426                	sd	s1,8(sp)
    800038ee:	1000                	add	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800038f0:	00015517          	auipc	a0,0x15
    800038f4:	14850513          	add	a0,a0,328 # 80018a38 <ftable>
    800038f8:	00002097          	auipc	ra,0x2
    800038fc:	7d6080e7          	jalr	2006(ra) # 800060ce <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003900:	00015497          	auipc	s1,0x15
    80003904:	15048493          	add	s1,s1,336 # 80018a50 <ftable+0x18>
    80003908:	00016717          	auipc	a4,0x16
    8000390c:	0e870713          	add	a4,a4,232 # 800199f0 <disk>
    if(f->ref == 0){
    80003910:	40dc                	lw	a5,4(s1)
    80003912:	cf99                	beqz	a5,80003930 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003914:	02848493          	add	s1,s1,40
    80003918:	fee49ce3          	bne	s1,a4,80003910 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000391c:	00015517          	auipc	a0,0x15
    80003920:	11c50513          	add	a0,a0,284 # 80018a38 <ftable>
    80003924:	00003097          	auipc	ra,0x3
    80003928:	85e080e7          	jalr	-1954(ra) # 80006182 <release>
  return 0;
    8000392c:	4481                	li	s1,0
    8000392e:	a819                	j	80003944 <filealloc+0x5e>
      f->ref = 1;
    80003930:	4785                	li	a5,1
    80003932:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003934:	00015517          	auipc	a0,0x15
    80003938:	10450513          	add	a0,a0,260 # 80018a38 <ftable>
    8000393c:	00003097          	auipc	ra,0x3
    80003940:	846080e7          	jalr	-1978(ra) # 80006182 <release>
}
    80003944:	8526                	mv	a0,s1
    80003946:	60e2                	ld	ra,24(sp)
    80003948:	6442                	ld	s0,16(sp)
    8000394a:	64a2                	ld	s1,8(sp)
    8000394c:	6105                	add	sp,sp,32
    8000394e:	8082                	ret

0000000080003950 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003950:	1101                	add	sp,sp,-32
    80003952:	ec06                	sd	ra,24(sp)
    80003954:	e822                	sd	s0,16(sp)
    80003956:	e426                	sd	s1,8(sp)
    80003958:	1000                	add	s0,sp,32
    8000395a:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    8000395c:	00015517          	auipc	a0,0x15
    80003960:	0dc50513          	add	a0,a0,220 # 80018a38 <ftable>
    80003964:	00002097          	auipc	ra,0x2
    80003968:	76a080e7          	jalr	1898(ra) # 800060ce <acquire>
  if(f->ref < 1)
    8000396c:	40dc                	lw	a5,4(s1)
    8000396e:	02f05263          	blez	a5,80003992 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003972:	2785                	addw	a5,a5,1
    80003974:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003976:	00015517          	auipc	a0,0x15
    8000397a:	0c250513          	add	a0,a0,194 # 80018a38 <ftable>
    8000397e:	00003097          	auipc	ra,0x3
    80003982:	804080e7          	jalr	-2044(ra) # 80006182 <release>
  return f;
}
    80003986:	8526                	mv	a0,s1
    80003988:	60e2                	ld	ra,24(sp)
    8000398a:	6442                	ld	s0,16(sp)
    8000398c:	64a2                	ld	s1,8(sp)
    8000398e:	6105                	add	sp,sp,32
    80003990:	8082                	ret
    panic("filedup");
    80003992:	00005517          	auipc	a0,0x5
    80003996:	cbe50513          	add	a0,a0,-834 # 80008650 <syscalls+0x240>
    8000399a:	00002097          	auipc	ra,0x2
    8000399e:	1fc080e7          	jalr	508(ra) # 80005b96 <panic>

00000000800039a2 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800039a2:	7139                	add	sp,sp,-64
    800039a4:	fc06                	sd	ra,56(sp)
    800039a6:	f822                	sd	s0,48(sp)
    800039a8:	f426                	sd	s1,40(sp)
    800039aa:	f04a                	sd	s2,32(sp)
    800039ac:	ec4e                	sd	s3,24(sp)
    800039ae:	e852                	sd	s4,16(sp)
    800039b0:	e456                	sd	s5,8(sp)
    800039b2:	0080                	add	s0,sp,64
    800039b4:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800039b6:	00015517          	auipc	a0,0x15
    800039ba:	08250513          	add	a0,a0,130 # 80018a38 <ftable>
    800039be:	00002097          	auipc	ra,0x2
    800039c2:	710080e7          	jalr	1808(ra) # 800060ce <acquire>
  if(f->ref < 1)
    800039c6:	40dc                	lw	a5,4(s1)
    800039c8:	06f05163          	blez	a5,80003a2a <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    800039cc:	37fd                	addw	a5,a5,-1
    800039ce:	0007871b          	sext.w	a4,a5
    800039d2:	c0dc                	sw	a5,4(s1)
    800039d4:	06e04363          	bgtz	a4,80003a3a <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800039d8:	0004a903          	lw	s2,0(s1)
    800039dc:	0094ca83          	lbu	s5,9(s1)
    800039e0:	0104ba03          	ld	s4,16(s1)
    800039e4:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800039e8:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800039ec:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800039f0:	00015517          	auipc	a0,0x15
    800039f4:	04850513          	add	a0,a0,72 # 80018a38 <ftable>
    800039f8:	00002097          	auipc	ra,0x2
    800039fc:	78a080e7          	jalr	1930(ra) # 80006182 <release>

  if(ff.type == FD_PIPE){
    80003a00:	4785                	li	a5,1
    80003a02:	04f90d63          	beq	s2,a5,80003a5c <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003a06:	3979                	addw	s2,s2,-2
    80003a08:	4785                	li	a5,1
    80003a0a:	0527e063          	bltu	a5,s2,80003a4a <fileclose+0xa8>
    begin_op();
    80003a0e:	00000097          	auipc	ra,0x0
    80003a12:	ad0080e7          	jalr	-1328(ra) # 800034de <begin_op>
    iput(ff.ip);
    80003a16:	854e                	mv	a0,s3
    80003a18:	fffff097          	auipc	ra,0xfffff
    80003a1c:	2da080e7          	jalr	730(ra) # 80002cf2 <iput>
    end_op();
    80003a20:	00000097          	auipc	ra,0x0
    80003a24:	b38080e7          	jalr	-1224(ra) # 80003558 <end_op>
    80003a28:	a00d                	j	80003a4a <fileclose+0xa8>
    panic("fileclose");
    80003a2a:	00005517          	auipc	a0,0x5
    80003a2e:	c2e50513          	add	a0,a0,-978 # 80008658 <syscalls+0x248>
    80003a32:	00002097          	auipc	ra,0x2
    80003a36:	164080e7          	jalr	356(ra) # 80005b96 <panic>
    release(&ftable.lock);
    80003a3a:	00015517          	auipc	a0,0x15
    80003a3e:	ffe50513          	add	a0,a0,-2 # 80018a38 <ftable>
    80003a42:	00002097          	auipc	ra,0x2
    80003a46:	740080e7          	jalr	1856(ra) # 80006182 <release>
  }
}
    80003a4a:	70e2                	ld	ra,56(sp)
    80003a4c:	7442                	ld	s0,48(sp)
    80003a4e:	74a2                	ld	s1,40(sp)
    80003a50:	7902                	ld	s2,32(sp)
    80003a52:	69e2                	ld	s3,24(sp)
    80003a54:	6a42                	ld	s4,16(sp)
    80003a56:	6aa2                	ld	s5,8(sp)
    80003a58:	6121                	add	sp,sp,64
    80003a5a:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003a5c:	85d6                	mv	a1,s5
    80003a5e:	8552                	mv	a0,s4
    80003a60:	00000097          	auipc	ra,0x0
    80003a64:	348080e7          	jalr	840(ra) # 80003da8 <pipeclose>
    80003a68:	b7cd                	j	80003a4a <fileclose+0xa8>

0000000080003a6a <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003a6a:	715d                	add	sp,sp,-80
    80003a6c:	e486                	sd	ra,72(sp)
    80003a6e:	e0a2                	sd	s0,64(sp)
    80003a70:	fc26                	sd	s1,56(sp)
    80003a72:	f84a                	sd	s2,48(sp)
    80003a74:	f44e                	sd	s3,40(sp)
    80003a76:	0880                	add	s0,sp,80
    80003a78:	84aa                	mv	s1,a0
    80003a7a:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003a7c:	ffffd097          	auipc	ra,0xffffd
    80003a80:	42e080e7          	jalr	1070(ra) # 80000eaa <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003a84:	409c                	lw	a5,0(s1)
    80003a86:	37f9                	addw	a5,a5,-2
    80003a88:	4705                	li	a4,1
    80003a8a:	04f76763          	bltu	a4,a5,80003ad8 <filestat+0x6e>
    80003a8e:	892a                	mv	s2,a0
    ilock(f->ip);
    80003a90:	6c88                	ld	a0,24(s1)
    80003a92:	fffff097          	auipc	ra,0xfffff
    80003a96:	0a6080e7          	jalr	166(ra) # 80002b38 <ilock>
    stati(f->ip, &st);
    80003a9a:	fb840593          	add	a1,s0,-72
    80003a9e:	6c88                	ld	a0,24(s1)
    80003aa0:	fffff097          	auipc	ra,0xfffff
    80003aa4:	322080e7          	jalr	802(ra) # 80002dc2 <stati>
    iunlock(f->ip);
    80003aa8:	6c88                	ld	a0,24(s1)
    80003aaa:	fffff097          	auipc	ra,0xfffff
    80003aae:	150080e7          	jalr	336(ra) # 80002bfa <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003ab2:	46e1                	li	a3,24
    80003ab4:	fb840613          	add	a2,s0,-72
    80003ab8:	85ce                	mv	a1,s3
    80003aba:	05093503          	ld	a0,80(s2)
    80003abe:	ffffd097          	auipc	ra,0xffffd
    80003ac2:	078080e7          	jalr	120(ra) # 80000b36 <copyout>
    80003ac6:	41f5551b          	sraw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003aca:	60a6                	ld	ra,72(sp)
    80003acc:	6406                	ld	s0,64(sp)
    80003ace:	74e2                	ld	s1,56(sp)
    80003ad0:	7942                	ld	s2,48(sp)
    80003ad2:	79a2                	ld	s3,40(sp)
    80003ad4:	6161                	add	sp,sp,80
    80003ad6:	8082                	ret
  return -1;
    80003ad8:	557d                	li	a0,-1
    80003ada:	bfc5                	j	80003aca <filestat+0x60>

0000000080003adc <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003adc:	7179                	add	sp,sp,-48
    80003ade:	f406                	sd	ra,40(sp)
    80003ae0:	f022                	sd	s0,32(sp)
    80003ae2:	ec26                	sd	s1,24(sp)
    80003ae4:	e84a                	sd	s2,16(sp)
    80003ae6:	e44e                	sd	s3,8(sp)
    80003ae8:	1800                	add	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003aea:	00854783          	lbu	a5,8(a0)
    80003aee:	c3d5                	beqz	a5,80003b92 <fileread+0xb6>
    80003af0:	84aa                	mv	s1,a0
    80003af2:	89ae                	mv	s3,a1
    80003af4:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003af6:	411c                	lw	a5,0(a0)
    80003af8:	4705                	li	a4,1
    80003afa:	04e78963          	beq	a5,a4,80003b4c <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003afe:	470d                	li	a4,3
    80003b00:	04e78d63          	beq	a5,a4,80003b5a <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003b04:	4709                	li	a4,2
    80003b06:	06e79e63          	bne	a5,a4,80003b82 <fileread+0xa6>
    ilock(f->ip);
    80003b0a:	6d08                	ld	a0,24(a0)
    80003b0c:	fffff097          	auipc	ra,0xfffff
    80003b10:	02c080e7          	jalr	44(ra) # 80002b38 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003b14:	874a                	mv	a4,s2
    80003b16:	5094                	lw	a3,32(s1)
    80003b18:	864e                	mv	a2,s3
    80003b1a:	4585                	li	a1,1
    80003b1c:	6c88                	ld	a0,24(s1)
    80003b1e:	fffff097          	auipc	ra,0xfffff
    80003b22:	2ce080e7          	jalr	718(ra) # 80002dec <readi>
    80003b26:	892a                	mv	s2,a0
    80003b28:	00a05563          	blez	a0,80003b32 <fileread+0x56>
      f->off += r;
    80003b2c:	509c                	lw	a5,32(s1)
    80003b2e:	9fa9                	addw	a5,a5,a0
    80003b30:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003b32:	6c88                	ld	a0,24(s1)
    80003b34:	fffff097          	auipc	ra,0xfffff
    80003b38:	0c6080e7          	jalr	198(ra) # 80002bfa <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003b3c:	854a                	mv	a0,s2
    80003b3e:	70a2                	ld	ra,40(sp)
    80003b40:	7402                	ld	s0,32(sp)
    80003b42:	64e2                	ld	s1,24(sp)
    80003b44:	6942                	ld	s2,16(sp)
    80003b46:	69a2                	ld	s3,8(sp)
    80003b48:	6145                	add	sp,sp,48
    80003b4a:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003b4c:	6908                	ld	a0,16(a0)
    80003b4e:	00000097          	auipc	ra,0x0
    80003b52:	3c2080e7          	jalr	962(ra) # 80003f10 <piperead>
    80003b56:	892a                	mv	s2,a0
    80003b58:	b7d5                	j	80003b3c <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003b5a:	02451783          	lh	a5,36(a0)
    80003b5e:	03079693          	sll	a3,a5,0x30
    80003b62:	92c1                	srl	a3,a3,0x30
    80003b64:	4725                	li	a4,9
    80003b66:	02d76863          	bltu	a4,a3,80003b96 <fileread+0xba>
    80003b6a:	0792                	sll	a5,a5,0x4
    80003b6c:	00015717          	auipc	a4,0x15
    80003b70:	e2c70713          	add	a4,a4,-468 # 80018998 <devsw>
    80003b74:	97ba                	add	a5,a5,a4
    80003b76:	639c                	ld	a5,0(a5)
    80003b78:	c38d                	beqz	a5,80003b9a <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003b7a:	4505                	li	a0,1
    80003b7c:	9782                	jalr	a5
    80003b7e:	892a                	mv	s2,a0
    80003b80:	bf75                	j	80003b3c <fileread+0x60>
    panic("fileread");
    80003b82:	00005517          	auipc	a0,0x5
    80003b86:	ae650513          	add	a0,a0,-1306 # 80008668 <syscalls+0x258>
    80003b8a:	00002097          	auipc	ra,0x2
    80003b8e:	00c080e7          	jalr	12(ra) # 80005b96 <panic>
    return -1;
    80003b92:	597d                	li	s2,-1
    80003b94:	b765                	j	80003b3c <fileread+0x60>
      return -1;
    80003b96:	597d                	li	s2,-1
    80003b98:	b755                	j	80003b3c <fileread+0x60>
    80003b9a:	597d                	li	s2,-1
    80003b9c:	b745                	j	80003b3c <fileread+0x60>

0000000080003b9e <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003b9e:	00954783          	lbu	a5,9(a0)
    80003ba2:	10078e63          	beqz	a5,80003cbe <filewrite+0x120>
{
    80003ba6:	715d                	add	sp,sp,-80
    80003ba8:	e486                	sd	ra,72(sp)
    80003baa:	e0a2                	sd	s0,64(sp)
    80003bac:	fc26                	sd	s1,56(sp)
    80003bae:	f84a                	sd	s2,48(sp)
    80003bb0:	f44e                	sd	s3,40(sp)
    80003bb2:	f052                	sd	s4,32(sp)
    80003bb4:	ec56                	sd	s5,24(sp)
    80003bb6:	e85a                	sd	s6,16(sp)
    80003bb8:	e45e                	sd	s7,8(sp)
    80003bba:	e062                	sd	s8,0(sp)
    80003bbc:	0880                	add	s0,sp,80
    80003bbe:	892a                	mv	s2,a0
    80003bc0:	8b2e                	mv	s6,a1
    80003bc2:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003bc4:	411c                	lw	a5,0(a0)
    80003bc6:	4705                	li	a4,1
    80003bc8:	02e78263          	beq	a5,a4,80003bec <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003bcc:	470d                	li	a4,3
    80003bce:	02e78563          	beq	a5,a4,80003bf8 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003bd2:	4709                	li	a4,2
    80003bd4:	0ce79d63          	bne	a5,a4,80003cae <filewrite+0x110>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003bd8:	0ac05b63          	blez	a2,80003c8e <filewrite+0xf0>
    int i = 0;
    80003bdc:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003bde:	6b85                	lui	s7,0x1
    80003be0:	c00b8b93          	add	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003be4:	6c05                	lui	s8,0x1
    80003be6:	c00c0c1b          	addw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003bea:	a851                	j	80003c7e <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80003bec:	6908                	ld	a0,16(a0)
    80003bee:	00000097          	auipc	ra,0x0
    80003bf2:	22a080e7          	jalr	554(ra) # 80003e18 <pipewrite>
    80003bf6:	a045                	j	80003c96 <filewrite+0xf8>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003bf8:	02451783          	lh	a5,36(a0)
    80003bfc:	03079693          	sll	a3,a5,0x30
    80003c00:	92c1                	srl	a3,a3,0x30
    80003c02:	4725                	li	a4,9
    80003c04:	0ad76f63          	bltu	a4,a3,80003cc2 <filewrite+0x124>
    80003c08:	0792                	sll	a5,a5,0x4
    80003c0a:	00015717          	auipc	a4,0x15
    80003c0e:	d8e70713          	add	a4,a4,-626 # 80018998 <devsw>
    80003c12:	97ba                	add	a5,a5,a4
    80003c14:	679c                	ld	a5,8(a5)
    80003c16:	cbc5                	beqz	a5,80003cc6 <filewrite+0x128>
    ret = devsw[f->major].write(1, addr, n);
    80003c18:	4505                	li	a0,1
    80003c1a:	9782                	jalr	a5
    80003c1c:	a8ad                	j	80003c96 <filewrite+0xf8>
      if(n1 > max)
    80003c1e:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003c22:	00000097          	auipc	ra,0x0
    80003c26:	8bc080e7          	jalr	-1860(ra) # 800034de <begin_op>
      ilock(f->ip);
    80003c2a:	01893503          	ld	a0,24(s2)
    80003c2e:	fffff097          	auipc	ra,0xfffff
    80003c32:	f0a080e7          	jalr	-246(ra) # 80002b38 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003c36:	8756                	mv	a4,s5
    80003c38:	02092683          	lw	a3,32(s2)
    80003c3c:	01698633          	add	a2,s3,s6
    80003c40:	4585                	li	a1,1
    80003c42:	01893503          	ld	a0,24(s2)
    80003c46:	fffff097          	auipc	ra,0xfffff
    80003c4a:	29e080e7          	jalr	670(ra) # 80002ee4 <writei>
    80003c4e:	84aa                	mv	s1,a0
    80003c50:	00a05763          	blez	a0,80003c5e <filewrite+0xc0>
        f->off += r;
    80003c54:	02092783          	lw	a5,32(s2)
    80003c58:	9fa9                	addw	a5,a5,a0
    80003c5a:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003c5e:	01893503          	ld	a0,24(s2)
    80003c62:	fffff097          	auipc	ra,0xfffff
    80003c66:	f98080e7          	jalr	-104(ra) # 80002bfa <iunlock>
      end_op();
    80003c6a:	00000097          	auipc	ra,0x0
    80003c6e:	8ee080e7          	jalr	-1810(ra) # 80003558 <end_op>

      if(r != n1){
    80003c72:	009a9f63          	bne	s5,s1,80003c90 <filewrite+0xf2>
        // error from writei
        break;
      }
      i += r;
    80003c76:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003c7a:	0149db63          	bge	s3,s4,80003c90 <filewrite+0xf2>
      int n1 = n - i;
    80003c7e:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003c82:	0004879b          	sext.w	a5,s1
    80003c86:	f8fbdce3          	bge	s7,a5,80003c1e <filewrite+0x80>
    80003c8a:	84e2                	mv	s1,s8
    80003c8c:	bf49                	j	80003c1e <filewrite+0x80>
    int i = 0;
    80003c8e:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003c90:	033a1d63          	bne	s4,s3,80003cca <filewrite+0x12c>
    80003c94:	8552                	mv	a0,s4
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003c96:	60a6                	ld	ra,72(sp)
    80003c98:	6406                	ld	s0,64(sp)
    80003c9a:	74e2                	ld	s1,56(sp)
    80003c9c:	7942                	ld	s2,48(sp)
    80003c9e:	79a2                	ld	s3,40(sp)
    80003ca0:	7a02                	ld	s4,32(sp)
    80003ca2:	6ae2                	ld	s5,24(sp)
    80003ca4:	6b42                	ld	s6,16(sp)
    80003ca6:	6ba2                	ld	s7,8(sp)
    80003ca8:	6c02                	ld	s8,0(sp)
    80003caa:	6161                	add	sp,sp,80
    80003cac:	8082                	ret
    panic("filewrite");
    80003cae:	00005517          	auipc	a0,0x5
    80003cb2:	9ca50513          	add	a0,a0,-1590 # 80008678 <syscalls+0x268>
    80003cb6:	00002097          	auipc	ra,0x2
    80003cba:	ee0080e7          	jalr	-288(ra) # 80005b96 <panic>
    return -1;
    80003cbe:	557d                	li	a0,-1
}
    80003cc0:	8082                	ret
      return -1;
    80003cc2:	557d                	li	a0,-1
    80003cc4:	bfc9                	j	80003c96 <filewrite+0xf8>
    80003cc6:	557d                	li	a0,-1
    80003cc8:	b7f9                	j	80003c96 <filewrite+0xf8>
    ret = (i == n ? n : -1);
    80003cca:	557d                	li	a0,-1
    80003ccc:	b7e9                	j	80003c96 <filewrite+0xf8>

0000000080003cce <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003cce:	7179                	add	sp,sp,-48
    80003cd0:	f406                	sd	ra,40(sp)
    80003cd2:	f022                	sd	s0,32(sp)
    80003cd4:	ec26                	sd	s1,24(sp)
    80003cd6:	e84a                	sd	s2,16(sp)
    80003cd8:	e44e                	sd	s3,8(sp)
    80003cda:	e052                	sd	s4,0(sp)
    80003cdc:	1800                	add	s0,sp,48
    80003cde:	84aa                	mv	s1,a0
    80003ce0:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003ce2:	0005b023          	sd	zero,0(a1)
    80003ce6:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003cea:	00000097          	auipc	ra,0x0
    80003cee:	bfc080e7          	jalr	-1028(ra) # 800038e6 <filealloc>
    80003cf2:	e088                	sd	a0,0(s1)
    80003cf4:	c551                	beqz	a0,80003d80 <pipealloc+0xb2>
    80003cf6:	00000097          	auipc	ra,0x0
    80003cfa:	bf0080e7          	jalr	-1040(ra) # 800038e6 <filealloc>
    80003cfe:	00aa3023          	sd	a0,0(s4)
    80003d02:	c92d                	beqz	a0,80003d74 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003d04:	ffffc097          	auipc	ra,0xffffc
    80003d08:	416080e7          	jalr	1046(ra) # 8000011a <kalloc>
    80003d0c:	892a                	mv	s2,a0
    80003d0e:	c125                	beqz	a0,80003d6e <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003d10:	4985                	li	s3,1
    80003d12:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003d16:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003d1a:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003d1e:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003d22:	00005597          	auipc	a1,0x5
    80003d26:	96658593          	add	a1,a1,-1690 # 80008688 <syscalls+0x278>
    80003d2a:	00002097          	auipc	ra,0x2
    80003d2e:	314080e7          	jalr	788(ra) # 8000603e <initlock>
  (*f0)->type = FD_PIPE;
    80003d32:	609c                	ld	a5,0(s1)
    80003d34:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003d38:	609c                	ld	a5,0(s1)
    80003d3a:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003d3e:	609c                	ld	a5,0(s1)
    80003d40:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003d44:	609c                	ld	a5,0(s1)
    80003d46:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003d4a:	000a3783          	ld	a5,0(s4)
    80003d4e:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003d52:	000a3783          	ld	a5,0(s4)
    80003d56:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003d5a:	000a3783          	ld	a5,0(s4)
    80003d5e:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003d62:	000a3783          	ld	a5,0(s4)
    80003d66:	0127b823          	sd	s2,16(a5)
  return 0;
    80003d6a:	4501                	li	a0,0
    80003d6c:	a025                	j	80003d94 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003d6e:	6088                	ld	a0,0(s1)
    80003d70:	e501                	bnez	a0,80003d78 <pipealloc+0xaa>
    80003d72:	a039                	j	80003d80 <pipealloc+0xb2>
    80003d74:	6088                	ld	a0,0(s1)
    80003d76:	c51d                	beqz	a0,80003da4 <pipealloc+0xd6>
    fileclose(*f0);
    80003d78:	00000097          	auipc	ra,0x0
    80003d7c:	c2a080e7          	jalr	-982(ra) # 800039a2 <fileclose>
  if(*f1)
    80003d80:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003d84:	557d                	li	a0,-1
  if(*f1)
    80003d86:	c799                	beqz	a5,80003d94 <pipealloc+0xc6>
    fileclose(*f1);
    80003d88:	853e                	mv	a0,a5
    80003d8a:	00000097          	auipc	ra,0x0
    80003d8e:	c18080e7          	jalr	-1000(ra) # 800039a2 <fileclose>
  return -1;
    80003d92:	557d                	li	a0,-1
}
    80003d94:	70a2                	ld	ra,40(sp)
    80003d96:	7402                	ld	s0,32(sp)
    80003d98:	64e2                	ld	s1,24(sp)
    80003d9a:	6942                	ld	s2,16(sp)
    80003d9c:	69a2                	ld	s3,8(sp)
    80003d9e:	6a02                	ld	s4,0(sp)
    80003da0:	6145                	add	sp,sp,48
    80003da2:	8082                	ret
  return -1;
    80003da4:	557d                	li	a0,-1
    80003da6:	b7fd                	j	80003d94 <pipealloc+0xc6>

0000000080003da8 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003da8:	1101                	add	sp,sp,-32
    80003daa:	ec06                	sd	ra,24(sp)
    80003dac:	e822                	sd	s0,16(sp)
    80003dae:	e426                	sd	s1,8(sp)
    80003db0:	e04a                	sd	s2,0(sp)
    80003db2:	1000                	add	s0,sp,32
    80003db4:	84aa                	mv	s1,a0
    80003db6:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003db8:	00002097          	auipc	ra,0x2
    80003dbc:	316080e7          	jalr	790(ra) # 800060ce <acquire>
  if(writable){
    80003dc0:	02090d63          	beqz	s2,80003dfa <pipeclose+0x52>
    pi->writeopen = 0;
    80003dc4:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003dc8:	21848513          	add	a0,s1,536
    80003dcc:	ffffd097          	auipc	ra,0xffffd
    80003dd0:	7ee080e7          	jalr	2030(ra) # 800015ba <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003dd4:	2204b783          	ld	a5,544(s1)
    80003dd8:	eb95                	bnez	a5,80003e0c <pipeclose+0x64>
    release(&pi->lock);
    80003dda:	8526                	mv	a0,s1
    80003ddc:	00002097          	auipc	ra,0x2
    80003de0:	3a6080e7          	jalr	934(ra) # 80006182 <release>
    kfree((char*)pi);
    80003de4:	8526                	mv	a0,s1
    80003de6:	ffffc097          	auipc	ra,0xffffc
    80003dea:	236080e7          	jalr	566(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003dee:	60e2                	ld	ra,24(sp)
    80003df0:	6442                	ld	s0,16(sp)
    80003df2:	64a2                	ld	s1,8(sp)
    80003df4:	6902                	ld	s2,0(sp)
    80003df6:	6105                	add	sp,sp,32
    80003df8:	8082                	ret
    pi->readopen = 0;
    80003dfa:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003dfe:	21c48513          	add	a0,s1,540
    80003e02:	ffffd097          	auipc	ra,0xffffd
    80003e06:	7b8080e7          	jalr	1976(ra) # 800015ba <wakeup>
    80003e0a:	b7e9                	j	80003dd4 <pipeclose+0x2c>
    release(&pi->lock);
    80003e0c:	8526                	mv	a0,s1
    80003e0e:	00002097          	auipc	ra,0x2
    80003e12:	374080e7          	jalr	884(ra) # 80006182 <release>
}
    80003e16:	bfe1                	j	80003dee <pipeclose+0x46>

0000000080003e18 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003e18:	711d                	add	sp,sp,-96
    80003e1a:	ec86                	sd	ra,88(sp)
    80003e1c:	e8a2                	sd	s0,80(sp)
    80003e1e:	e4a6                	sd	s1,72(sp)
    80003e20:	e0ca                	sd	s2,64(sp)
    80003e22:	fc4e                	sd	s3,56(sp)
    80003e24:	f852                	sd	s4,48(sp)
    80003e26:	f456                	sd	s5,40(sp)
    80003e28:	f05a                	sd	s6,32(sp)
    80003e2a:	ec5e                	sd	s7,24(sp)
    80003e2c:	e862                	sd	s8,16(sp)
    80003e2e:	1080                	add	s0,sp,96
    80003e30:	84aa                	mv	s1,a0
    80003e32:	8aae                	mv	s5,a1
    80003e34:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003e36:	ffffd097          	auipc	ra,0xffffd
    80003e3a:	074080e7          	jalr	116(ra) # 80000eaa <myproc>
    80003e3e:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003e40:	8526                	mv	a0,s1
    80003e42:	00002097          	auipc	ra,0x2
    80003e46:	28c080e7          	jalr	652(ra) # 800060ce <acquire>
  while(i < n){
    80003e4a:	0b405663          	blez	s4,80003ef6 <pipewrite+0xde>
  int i = 0;
    80003e4e:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003e50:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003e52:	21848c13          	add	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003e56:	21c48b93          	add	s7,s1,540
    80003e5a:	a089                	j	80003e9c <pipewrite+0x84>
      release(&pi->lock);
    80003e5c:	8526                	mv	a0,s1
    80003e5e:	00002097          	auipc	ra,0x2
    80003e62:	324080e7          	jalr	804(ra) # 80006182 <release>
      return -1;
    80003e66:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003e68:	854a                	mv	a0,s2
    80003e6a:	60e6                	ld	ra,88(sp)
    80003e6c:	6446                	ld	s0,80(sp)
    80003e6e:	64a6                	ld	s1,72(sp)
    80003e70:	6906                	ld	s2,64(sp)
    80003e72:	79e2                	ld	s3,56(sp)
    80003e74:	7a42                	ld	s4,48(sp)
    80003e76:	7aa2                	ld	s5,40(sp)
    80003e78:	7b02                	ld	s6,32(sp)
    80003e7a:	6be2                	ld	s7,24(sp)
    80003e7c:	6c42                	ld	s8,16(sp)
    80003e7e:	6125                	add	sp,sp,96
    80003e80:	8082                	ret
      wakeup(&pi->nread);
    80003e82:	8562                	mv	a0,s8
    80003e84:	ffffd097          	auipc	ra,0xffffd
    80003e88:	736080e7          	jalr	1846(ra) # 800015ba <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003e8c:	85a6                	mv	a1,s1
    80003e8e:	855e                	mv	a0,s7
    80003e90:	ffffd097          	auipc	ra,0xffffd
    80003e94:	6c6080e7          	jalr	1734(ra) # 80001556 <sleep>
  while(i < n){
    80003e98:	07495063          	bge	s2,s4,80003ef8 <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80003e9c:	2204a783          	lw	a5,544(s1)
    80003ea0:	dfd5                	beqz	a5,80003e5c <pipewrite+0x44>
    80003ea2:	854e                	mv	a0,s3
    80003ea4:	ffffe097          	auipc	ra,0xffffe
    80003ea8:	95a080e7          	jalr	-1702(ra) # 800017fe <killed>
    80003eac:	f945                	bnez	a0,80003e5c <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003eae:	2184a783          	lw	a5,536(s1)
    80003eb2:	21c4a703          	lw	a4,540(s1)
    80003eb6:	2007879b          	addw	a5,a5,512
    80003eba:	fcf704e3          	beq	a4,a5,80003e82 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003ebe:	4685                	li	a3,1
    80003ec0:	01590633          	add	a2,s2,s5
    80003ec4:	faf40593          	add	a1,s0,-81
    80003ec8:	0509b503          	ld	a0,80(s3)
    80003ecc:	ffffd097          	auipc	ra,0xffffd
    80003ed0:	d2a080e7          	jalr	-726(ra) # 80000bf6 <copyin>
    80003ed4:	03650263          	beq	a0,s6,80003ef8 <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003ed8:	21c4a783          	lw	a5,540(s1)
    80003edc:	0017871b          	addw	a4,a5,1
    80003ee0:	20e4ae23          	sw	a4,540(s1)
    80003ee4:	1ff7f793          	and	a5,a5,511
    80003ee8:	97a6                	add	a5,a5,s1
    80003eea:	faf44703          	lbu	a4,-81(s0)
    80003eee:	00e78c23          	sb	a4,24(a5)
      i++;
    80003ef2:	2905                	addw	s2,s2,1
    80003ef4:	b755                	j	80003e98 <pipewrite+0x80>
  int i = 0;
    80003ef6:	4901                	li	s2,0
  wakeup(&pi->nread);
    80003ef8:	21848513          	add	a0,s1,536
    80003efc:	ffffd097          	auipc	ra,0xffffd
    80003f00:	6be080e7          	jalr	1726(ra) # 800015ba <wakeup>
  release(&pi->lock);
    80003f04:	8526                	mv	a0,s1
    80003f06:	00002097          	auipc	ra,0x2
    80003f0a:	27c080e7          	jalr	636(ra) # 80006182 <release>
  return i;
    80003f0e:	bfa9                	j	80003e68 <pipewrite+0x50>

0000000080003f10 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003f10:	715d                	add	sp,sp,-80
    80003f12:	e486                	sd	ra,72(sp)
    80003f14:	e0a2                	sd	s0,64(sp)
    80003f16:	fc26                	sd	s1,56(sp)
    80003f18:	f84a                	sd	s2,48(sp)
    80003f1a:	f44e                	sd	s3,40(sp)
    80003f1c:	f052                	sd	s4,32(sp)
    80003f1e:	ec56                	sd	s5,24(sp)
    80003f20:	e85a                	sd	s6,16(sp)
    80003f22:	0880                	add	s0,sp,80
    80003f24:	84aa                	mv	s1,a0
    80003f26:	892e                	mv	s2,a1
    80003f28:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003f2a:	ffffd097          	auipc	ra,0xffffd
    80003f2e:	f80080e7          	jalr	-128(ra) # 80000eaa <myproc>
    80003f32:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003f34:	8526                	mv	a0,s1
    80003f36:	00002097          	auipc	ra,0x2
    80003f3a:	198080e7          	jalr	408(ra) # 800060ce <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f3e:	2184a703          	lw	a4,536(s1)
    80003f42:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003f46:	21848993          	add	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f4a:	02f71763          	bne	a4,a5,80003f78 <piperead+0x68>
    80003f4e:	2244a783          	lw	a5,548(s1)
    80003f52:	c39d                	beqz	a5,80003f78 <piperead+0x68>
    if(killed(pr)){
    80003f54:	8552                	mv	a0,s4
    80003f56:	ffffe097          	auipc	ra,0xffffe
    80003f5a:	8a8080e7          	jalr	-1880(ra) # 800017fe <killed>
    80003f5e:	e949                	bnez	a0,80003ff0 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003f60:	85a6                	mv	a1,s1
    80003f62:	854e                	mv	a0,s3
    80003f64:	ffffd097          	auipc	ra,0xffffd
    80003f68:	5f2080e7          	jalr	1522(ra) # 80001556 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f6c:	2184a703          	lw	a4,536(s1)
    80003f70:	21c4a783          	lw	a5,540(s1)
    80003f74:	fcf70de3          	beq	a4,a5,80003f4e <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003f78:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003f7a:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003f7c:	05505463          	blez	s5,80003fc4 <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    80003f80:	2184a783          	lw	a5,536(s1)
    80003f84:	21c4a703          	lw	a4,540(s1)
    80003f88:	02f70e63          	beq	a4,a5,80003fc4 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003f8c:	0017871b          	addw	a4,a5,1
    80003f90:	20e4ac23          	sw	a4,536(s1)
    80003f94:	1ff7f793          	and	a5,a5,511
    80003f98:	97a6                	add	a5,a5,s1
    80003f9a:	0187c783          	lbu	a5,24(a5)
    80003f9e:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003fa2:	4685                	li	a3,1
    80003fa4:	fbf40613          	add	a2,s0,-65
    80003fa8:	85ca                	mv	a1,s2
    80003faa:	050a3503          	ld	a0,80(s4)
    80003fae:	ffffd097          	auipc	ra,0xffffd
    80003fb2:	b88080e7          	jalr	-1144(ra) # 80000b36 <copyout>
    80003fb6:	01650763          	beq	a0,s6,80003fc4 <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003fba:	2985                	addw	s3,s3,1
    80003fbc:	0905                	add	s2,s2,1
    80003fbe:	fd3a91e3          	bne	s5,s3,80003f80 <piperead+0x70>
    80003fc2:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003fc4:	21c48513          	add	a0,s1,540
    80003fc8:	ffffd097          	auipc	ra,0xffffd
    80003fcc:	5f2080e7          	jalr	1522(ra) # 800015ba <wakeup>
  release(&pi->lock);
    80003fd0:	8526                	mv	a0,s1
    80003fd2:	00002097          	auipc	ra,0x2
    80003fd6:	1b0080e7          	jalr	432(ra) # 80006182 <release>
  return i;
}
    80003fda:	854e                	mv	a0,s3
    80003fdc:	60a6                	ld	ra,72(sp)
    80003fde:	6406                	ld	s0,64(sp)
    80003fe0:	74e2                	ld	s1,56(sp)
    80003fe2:	7942                	ld	s2,48(sp)
    80003fe4:	79a2                	ld	s3,40(sp)
    80003fe6:	7a02                	ld	s4,32(sp)
    80003fe8:	6ae2                	ld	s5,24(sp)
    80003fea:	6b42                	ld	s6,16(sp)
    80003fec:	6161                	add	sp,sp,80
    80003fee:	8082                	ret
      release(&pi->lock);
    80003ff0:	8526                	mv	a0,s1
    80003ff2:	00002097          	auipc	ra,0x2
    80003ff6:	190080e7          	jalr	400(ra) # 80006182 <release>
      return -1;
    80003ffa:	59fd                	li	s3,-1
    80003ffc:	bff9                	j	80003fda <piperead+0xca>

0000000080003ffe <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80003ffe:	1141                	add	sp,sp,-16
    80004000:	e422                	sd	s0,8(sp)
    80004002:	0800                	add	s0,sp,16
    80004004:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004006:	8905                	and	a0,a0,1
    80004008:	050e                	sll	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    8000400a:	8b89                	and	a5,a5,2
    8000400c:	c399                	beqz	a5,80004012 <flags2perm+0x14>
      perm |= PTE_W;
    8000400e:	00456513          	or	a0,a0,4
    return perm;
}
    80004012:	6422                	ld	s0,8(sp)
    80004014:	0141                	add	sp,sp,16
    80004016:	8082                	ret

0000000080004018 <exec>:

int
exec(char *path, char **argv)
{
    80004018:	df010113          	add	sp,sp,-528
    8000401c:	20113423          	sd	ra,520(sp)
    80004020:	20813023          	sd	s0,512(sp)
    80004024:	ffa6                	sd	s1,504(sp)
    80004026:	fbca                	sd	s2,496(sp)
    80004028:	f7ce                	sd	s3,488(sp)
    8000402a:	f3d2                	sd	s4,480(sp)
    8000402c:	efd6                	sd	s5,472(sp)
    8000402e:	ebda                	sd	s6,464(sp)
    80004030:	e7de                	sd	s7,456(sp)
    80004032:	e3e2                	sd	s8,448(sp)
    80004034:	ff66                	sd	s9,440(sp)
    80004036:	fb6a                	sd	s10,432(sp)
    80004038:	f76e                	sd	s11,424(sp)
    8000403a:	0c00                	add	s0,sp,528
    8000403c:	892a                	mv	s2,a0
    8000403e:	dea43c23          	sd	a0,-520(s0)
    80004042:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004046:	ffffd097          	auipc	ra,0xffffd
    8000404a:	e64080e7          	jalr	-412(ra) # 80000eaa <myproc>
    8000404e:	84aa                	mv	s1,a0

  begin_op();
    80004050:	fffff097          	auipc	ra,0xfffff
    80004054:	48e080e7          	jalr	1166(ra) # 800034de <begin_op>

  if((ip = namei(path)) == 0){
    80004058:	854a                	mv	a0,s2
    8000405a:	fffff097          	auipc	ra,0xfffff
    8000405e:	284080e7          	jalr	644(ra) # 800032de <namei>
    80004062:	c92d                	beqz	a0,800040d4 <exec+0xbc>
    80004064:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004066:	fffff097          	auipc	ra,0xfffff
    8000406a:	ad2080e7          	jalr	-1326(ra) # 80002b38 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000406e:	04000713          	li	a4,64
    80004072:	4681                	li	a3,0
    80004074:	e5040613          	add	a2,s0,-432
    80004078:	4581                	li	a1,0
    8000407a:	8552                	mv	a0,s4
    8000407c:	fffff097          	auipc	ra,0xfffff
    80004080:	d70080e7          	jalr	-656(ra) # 80002dec <readi>
    80004084:	04000793          	li	a5,64
    80004088:	00f51a63          	bne	a0,a5,8000409c <exec+0x84>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    8000408c:	e5042703          	lw	a4,-432(s0)
    80004090:	464c47b7          	lui	a5,0x464c4
    80004094:	57f78793          	add	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004098:	04f70463          	beq	a4,a5,800040e0 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000409c:	8552                	mv	a0,s4
    8000409e:	fffff097          	auipc	ra,0xfffff
    800040a2:	cfc080e7          	jalr	-772(ra) # 80002d9a <iunlockput>
    end_op();
    800040a6:	fffff097          	auipc	ra,0xfffff
    800040aa:	4b2080e7          	jalr	1202(ra) # 80003558 <end_op>
  }
  return -1;
    800040ae:	557d                	li	a0,-1
}
    800040b0:	20813083          	ld	ra,520(sp)
    800040b4:	20013403          	ld	s0,512(sp)
    800040b8:	74fe                	ld	s1,504(sp)
    800040ba:	795e                	ld	s2,496(sp)
    800040bc:	79be                	ld	s3,488(sp)
    800040be:	7a1e                	ld	s4,480(sp)
    800040c0:	6afe                	ld	s5,472(sp)
    800040c2:	6b5e                	ld	s6,464(sp)
    800040c4:	6bbe                	ld	s7,456(sp)
    800040c6:	6c1e                	ld	s8,448(sp)
    800040c8:	7cfa                	ld	s9,440(sp)
    800040ca:	7d5a                	ld	s10,432(sp)
    800040cc:	7dba                	ld	s11,424(sp)
    800040ce:	21010113          	add	sp,sp,528
    800040d2:	8082                	ret
    end_op();
    800040d4:	fffff097          	auipc	ra,0xfffff
    800040d8:	484080e7          	jalr	1156(ra) # 80003558 <end_op>
    return -1;
    800040dc:	557d                	li	a0,-1
    800040de:	bfc9                	j	800040b0 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    800040e0:	8526                	mv	a0,s1
    800040e2:	ffffd097          	auipc	ra,0xffffd
    800040e6:	e90080e7          	jalr	-368(ra) # 80000f72 <proc_pagetable>
    800040ea:	8b2a                	mv	s6,a0
    800040ec:	d945                	beqz	a0,8000409c <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800040ee:	e7042d03          	lw	s10,-400(s0)
    800040f2:	e8845783          	lhu	a5,-376(s0)
    800040f6:	10078463          	beqz	a5,800041fe <exec+0x1e6>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800040fa:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800040fc:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    800040fe:	6c85                	lui	s9,0x1
    80004100:	fffc8793          	add	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004104:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004108:	6a85                	lui	s5,0x1
    8000410a:	a0b5                	j	80004176 <exec+0x15e>
      panic("loadseg: address should exist");
    8000410c:	00004517          	auipc	a0,0x4
    80004110:	58450513          	add	a0,a0,1412 # 80008690 <syscalls+0x280>
    80004114:	00002097          	auipc	ra,0x2
    80004118:	a82080e7          	jalr	-1406(ra) # 80005b96 <panic>
    if(sz - i < PGSIZE)
    8000411c:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000411e:	8726                	mv	a4,s1
    80004120:	012c06bb          	addw	a3,s8,s2
    80004124:	4581                	li	a1,0
    80004126:	8552                	mv	a0,s4
    80004128:	fffff097          	auipc	ra,0xfffff
    8000412c:	cc4080e7          	jalr	-828(ra) # 80002dec <readi>
    80004130:	2501                	sext.w	a0,a0
    80004132:	24a49863          	bne	s1,a0,80004382 <exec+0x36a>
  for(i = 0; i < sz; i += PGSIZE){
    80004136:	012a893b          	addw	s2,s5,s2
    8000413a:	03397563          	bgeu	s2,s3,80004164 <exec+0x14c>
    pa = walkaddr(pagetable, va + i);
    8000413e:	02091593          	sll	a1,s2,0x20
    80004142:	9181                	srl	a1,a1,0x20
    80004144:	95de                	add	a1,a1,s7
    80004146:	855a                	mv	a0,s6
    80004148:	ffffc097          	auipc	ra,0xffffc
    8000414c:	3ba080e7          	jalr	954(ra) # 80000502 <walkaddr>
    80004150:	862a                	mv	a2,a0
    if(pa == 0)
    80004152:	dd4d                	beqz	a0,8000410c <exec+0xf4>
    if(sz - i < PGSIZE)
    80004154:	412984bb          	subw	s1,s3,s2
    80004158:	0004879b          	sext.w	a5,s1
    8000415c:	fcfcf0e3          	bgeu	s9,a5,8000411c <exec+0x104>
    80004160:	84d6                	mv	s1,s5
    80004162:	bf6d                	j	8000411c <exec+0x104>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004164:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004168:	2d85                	addw	s11,s11,1
    8000416a:	038d0d1b          	addw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    8000416e:	e8845783          	lhu	a5,-376(s0)
    80004172:	08fdd763          	bge	s11,a5,80004200 <exec+0x1e8>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004176:	2d01                	sext.w	s10,s10
    80004178:	03800713          	li	a4,56
    8000417c:	86ea                	mv	a3,s10
    8000417e:	e1840613          	add	a2,s0,-488
    80004182:	4581                	li	a1,0
    80004184:	8552                	mv	a0,s4
    80004186:	fffff097          	auipc	ra,0xfffff
    8000418a:	c66080e7          	jalr	-922(ra) # 80002dec <readi>
    8000418e:	03800793          	li	a5,56
    80004192:	1ef51663          	bne	a0,a5,8000437e <exec+0x366>
    if(ph.type != ELF_PROG_LOAD)
    80004196:	e1842783          	lw	a5,-488(s0)
    8000419a:	4705                	li	a4,1
    8000419c:	fce796e3          	bne	a5,a4,80004168 <exec+0x150>
    if(ph.memsz < ph.filesz)
    800041a0:	e4043483          	ld	s1,-448(s0)
    800041a4:	e3843783          	ld	a5,-456(s0)
    800041a8:	1ef4e863          	bltu	s1,a5,80004398 <exec+0x380>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800041ac:	e2843783          	ld	a5,-472(s0)
    800041b0:	94be                	add	s1,s1,a5
    800041b2:	1ef4e663          	bltu	s1,a5,8000439e <exec+0x386>
    if(ph.vaddr % PGSIZE != 0)
    800041b6:	df043703          	ld	a4,-528(s0)
    800041ba:	8ff9                	and	a5,a5,a4
    800041bc:	1e079463          	bnez	a5,800043a4 <exec+0x38c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800041c0:	e1c42503          	lw	a0,-484(s0)
    800041c4:	00000097          	auipc	ra,0x0
    800041c8:	e3a080e7          	jalr	-454(ra) # 80003ffe <flags2perm>
    800041cc:	86aa                	mv	a3,a0
    800041ce:	8626                	mv	a2,s1
    800041d0:	85ca                	mv	a1,s2
    800041d2:	855a                	mv	a0,s6
    800041d4:	ffffc097          	auipc	ra,0xffffc
    800041d8:	706080e7          	jalr	1798(ra) # 800008da <uvmalloc>
    800041dc:	e0a43423          	sd	a0,-504(s0)
    800041e0:	1c050563          	beqz	a0,800043aa <exec+0x392>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800041e4:	e2843b83          	ld	s7,-472(s0)
    800041e8:	e2042c03          	lw	s8,-480(s0)
    800041ec:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800041f0:	00098463          	beqz	s3,800041f8 <exec+0x1e0>
    800041f4:	4901                	li	s2,0
    800041f6:	b7a1                	j	8000413e <exec+0x126>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800041f8:	e0843903          	ld	s2,-504(s0)
    800041fc:	b7b5                	j	80004168 <exec+0x150>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800041fe:	4901                	li	s2,0
  iunlockput(ip);
    80004200:	8552                	mv	a0,s4
    80004202:	fffff097          	auipc	ra,0xfffff
    80004206:	b98080e7          	jalr	-1128(ra) # 80002d9a <iunlockput>
  end_op();
    8000420a:	fffff097          	auipc	ra,0xfffff
    8000420e:	34e080e7          	jalr	846(ra) # 80003558 <end_op>
  p = myproc();
    80004212:	ffffd097          	auipc	ra,0xffffd
    80004216:	c98080e7          	jalr	-872(ra) # 80000eaa <myproc>
    8000421a:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    8000421c:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80004220:	6985                	lui	s3,0x1
    80004222:	19fd                	add	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004224:	99ca                	add	s3,s3,s2
    80004226:	77fd                	lui	a5,0xfffff
    80004228:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    8000422c:	4691                	li	a3,4
    8000422e:	6609                	lui	a2,0x2
    80004230:	964e                	add	a2,a2,s3
    80004232:	85ce                	mv	a1,s3
    80004234:	855a                	mv	a0,s6
    80004236:	ffffc097          	auipc	ra,0xffffc
    8000423a:	6a4080e7          	jalr	1700(ra) # 800008da <uvmalloc>
    8000423e:	892a                	mv	s2,a0
    80004240:	e0a43423          	sd	a0,-504(s0)
    80004244:	e509                	bnez	a0,8000424e <exec+0x236>
  if(pagetable)
    80004246:	e1343423          	sd	s3,-504(s0)
    8000424a:	4a01                	li	s4,0
    8000424c:	aa1d                	j	80004382 <exec+0x36a>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000424e:	75f9                	lui	a1,0xffffe
    80004250:	95aa                	add	a1,a1,a0
    80004252:	855a                	mv	a0,s6
    80004254:	ffffd097          	auipc	ra,0xffffd
    80004258:	8b0080e7          	jalr	-1872(ra) # 80000b04 <uvmclear>
  stackbase = sp - PGSIZE;
    8000425c:	7bfd                	lui	s7,0xfffff
    8000425e:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80004260:	e0043783          	ld	a5,-512(s0)
    80004264:	6388                	ld	a0,0(a5)
    80004266:	c52d                	beqz	a0,800042d0 <exec+0x2b8>
    80004268:	e9040993          	add	s3,s0,-368
    8000426c:	f9040c13          	add	s8,s0,-112
    80004270:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004272:	ffffc097          	auipc	ra,0xffffc
    80004276:	082080e7          	jalr	130(ra) # 800002f4 <strlen>
    8000427a:	0015079b          	addw	a5,a0,1
    8000427e:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004282:	ff07f913          	and	s2,a5,-16
    if(sp < stackbase)
    80004286:	13796563          	bltu	s2,s7,800043b0 <exec+0x398>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000428a:	e0043d03          	ld	s10,-512(s0)
    8000428e:	000d3a03          	ld	s4,0(s10)
    80004292:	8552                	mv	a0,s4
    80004294:	ffffc097          	auipc	ra,0xffffc
    80004298:	060080e7          	jalr	96(ra) # 800002f4 <strlen>
    8000429c:	0015069b          	addw	a3,a0,1
    800042a0:	8652                	mv	a2,s4
    800042a2:	85ca                	mv	a1,s2
    800042a4:	855a                	mv	a0,s6
    800042a6:	ffffd097          	auipc	ra,0xffffd
    800042aa:	890080e7          	jalr	-1904(ra) # 80000b36 <copyout>
    800042ae:	10054363          	bltz	a0,800043b4 <exec+0x39c>
    ustack[argc] = sp;
    800042b2:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800042b6:	0485                	add	s1,s1,1
    800042b8:	008d0793          	add	a5,s10,8
    800042bc:	e0f43023          	sd	a5,-512(s0)
    800042c0:	008d3503          	ld	a0,8(s10)
    800042c4:	c909                	beqz	a0,800042d6 <exec+0x2be>
    if(argc >= MAXARG)
    800042c6:	09a1                	add	s3,s3,8
    800042c8:	fb8995e3          	bne	s3,s8,80004272 <exec+0x25a>
  ip = 0;
    800042cc:	4a01                	li	s4,0
    800042ce:	a855                	j	80004382 <exec+0x36a>
  sp = sz;
    800042d0:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    800042d4:	4481                	li	s1,0
  ustack[argc] = 0;
    800042d6:	00349793          	sll	a5,s1,0x3
    800042da:	f9078793          	add	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdd220>
    800042de:	97a2                	add	a5,a5,s0
    800042e0:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800042e4:	00148693          	add	a3,s1,1
    800042e8:	068e                	sll	a3,a3,0x3
    800042ea:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800042ee:	ff097913          	and	s2,s2,-16
  sz = sz1;
    800042f2:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    800042f6:	f57968e3          	bltu	s2,s7,80004246 <exec+0x22e>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800042fa:	e9040613          	add	a2,s0,-368
    800042fe:	85ca                	mv	a1,s2
    80004300:	855a                	mv	a0,s6
    80004302:	ffffd097          	auipc	ra,0xffffd
    80004306:	834080e7          	jalr	-1996(ra) # 80000b36 <copyout>
    8000430a:	0a054763          	bltz	a0,800043b8 <exec+0x3a0>
  p->trapframe->a1 = sp;
    8000430e:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004312:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004316:	df843783          	ld	a5,-520(s0)
    8000431a:	0007c703          	lbu	a4,0(a5)
    8000431e:	cf11                	beqz	a4,8000433a <exec+0x322>
    80004320:	0785                	add	a5,a5,1
    if(*s == '/')
    80004322:	02f00693          	li	a3,47
    80004326:	a039                	j	80004334 <exec+0x31c>
      last = s+1;
    80004328:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    8000432c:	0785                	add	a5,a5,1
    8000432e:	fff7c703          	lbu	a4,-1(a5)
    80004332:	c701                	beqz	a4,8000433a <exec+0x322>
    if(*s == '/')
    80004334:	fed71ce3          	bne	a4,a3,8000432c <exec+0x314>
    80004338:	bfc5                	j	80004328 <exec+0x310>
  safestrcpy(p->name, last, sizeof(p->name));
    8000433a:	4641                	li	a2,16
    8000433c:	df843583          	ld	a1,-520(s0)
    80004340:	158a8513          	add	a0,s5,344
    80004344:	ffffc097          	auipc	ra,0xffffc
    80004348:	f7e080e7          	jalr	-130(ra) # 800002c2 <safestrcpy>
  oldpagetable = p->pagetable;
    8000434c:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004350:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80004354:	e0843783          	ld	a5,-504(s0)
    80004358:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000435c:	058ab783          	ld	a5,88(s5)
    80004360:	e6843703          	ld	a4,-408(s0)
    80004364:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004366:	058ab783          	ld	a5,88(s5)
    8000436a:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000436e:	85e6                	mv	a1,s9
    80004370:	ffffd097          	auipc	ra,0xffffd
    80004374:	c9e080e7          	jalr	-866(ra) # 8000100e <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004378:	0004851b          	sext.w	a0,s1
    8000437c:	bb15                	j	800040b0 <exec+0x98>
    8000437e:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004382:	e0843583          	ld	a1,-504(s0)
    80004386:	855a                	mv	a0,s6
    80004388:	ffffd097          	auipc	ra,0xffffd
    8000438c:	c86080e7          	jalr	-890(ra) # 8000100e <proc_freepagetable>
  return -1;
    80004390:	557d                	li	a0,-1
  if(ip){
    80004392:	d00a0fe3          	beqz	s4,800040b0 <exec+0x98>
    80004396:	b319                	j	8000409c <exec+0x84>
    80004398:	e1243423          	sd	s2,-504(s0)
    8000439c:	b7dd                	j	80004382 <exec+0x36a>
    8000439e:	e1243423          	sd	s2,-504(s0)
    800043a2:	b7c5                	j	80004382 <exec+0x36a>
    800043a4:	e1243423          	sd	s2,-504(s0)
    800043a8:	bfe9                	j	80004382 <exec+0x36a>
    800043aa:	e1243423          	sd	s2,-504(s0)
    800043ae:	bfd1                	j	80004382 <exec+0x36a>
  ip = 0;
    800043b0:	4a01                	li	s4,0
    800043b2:	bfc1                	j	80004382 <exec+0x36a>
    800043b4:	4a01                	li	s4,0
  if(pagetable)
    800043b6:	b7f1                	j	80004382 <exec+0x36a>
  sz = sz1;
    800043b8:	e0843983          	ld	s3,-504(s0)
    800043bc:	b569                	j	80004246 <exec+0x22e>

00000000800043be <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800043be:	7179                	add	sp,sp,-48
    800043c0:	f406                	sd	ra,40(sp)
    800043c2:	f022                	sd	s0,32(sp)
    800043c4:	ec26                	sd	s1,24(sp)
    800043c6:	e84a                	sd	s2,16(sp)
    800043c8:	1800                	add	s0,sp,48
    800043ca:	892e                	mv	s2,a1
    800043cc:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800043ce:	fdc40593          	add	a1,s0,-36
    800043d2:	ffffe097          	auipc	ra,0xffffe
    800043d6:	bf6080e7          	jalr	-1034(ra) # 80001fc8 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800043da:	fdc42703          	lw	a4,-36(s0)
    800043de:	47bd                	li	a5,15
    800043e0:	02e7eb63          	bltu	a5,a4,80004416 <argfd+0x58>
    800043e4:	ffffd097          	auipc	ra,0xffffd
    800043e8:	ac6080e7          	jalr	-1338(ra) # 80000eaa <myproc>
    800043ec:	fdc42703          	lw	a4,-36(s0)
    800043f0:	01a70793          	add	a5,a4,26
    800043f4:	078e                	sll	a5,a5,0x3
    800043f6:	953e                	add	a0,a0,a5
    800043f8:	611c                	ld	a5,0(a0)
    800043fa:	c385                	beqz	a5,8000441a <argfd+0x5c>
    return -1;
  if(pfd)
    800043fc:	00090463          	beqz	s2,80004404 <argfd+0x46>
    *pfd = fd;
    80004400:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004404:	4501                	li	a0,0
  if(pf)
    80004406:	c091                	beqz	s1,8000440a <argfd+0x4c>
    *pf = f;
    80004408:	e09c                	sd	a5,0(s1)
}
    8000440a:	70a2                	ld	ra,40(sp)
    8000440c:	7402                	ld	s0,32(sp)
    8000440e:	64e2                	ld	s1,24(sp)
    80004410:	6942                	ld	s2,16(sp)
    80004412:	6145                	add	sp,sp,48
    80004414:	8082                	ret
    return -1;
    80004416:	557d                	li	a0,-1
    80004418:	bfcd                	j	8000440a <argfd+0x4c>
    8000441a:	557d                	li	a0,-1
    8000441c:	b7fd                	j	8000440a <argfd+0x4c>

000000008000441e <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000441e:	1101                	add	sp,sp,-32
    80004420:	ec06                	sd	ra,24(sp)
    80004422:	e822                	sd	s0,16(sp)
    80004424:	e426                	sd	s1,8(sp)
    80004426:	1000                	add	s0,sp,32
    80004428:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000442a:	ffffd097          	auipc	ra,0xffffd
    8000442e:	a80080e7          	jalr	-1408(ra) # 80000eaa <myproc>
    80004432:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004434:	0d050793          	add	a5,a0,208
    80004438:	4501                	li	a0,0
    8000443a:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000443c:	6398                	ld	a4,0(a5)
    8000443e:	cb19                	beqz	a4,80004454 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004440:	2505                	addw	a0,a0,1
    80004442:	07a1                	add	a5,a5,8
    80004444:	fed51ce3          	bne	a0,a3,8000443c <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004448:	557d                	li	a0,-1
}
    8000444a:	60e2                	ld	ra,24(sp)
    8000444c:	6442                	ld	s0,16(sp)
    8000444e:	64a2                	ld	s1,8(sp)
    80004450:	6105                	add	sp,sp,32
    80004452:	8082                	ret
      p->ofile[fd] = f;
    80004454:	01a50793          	add	a5,a0,26
    80004458:	078e                	sll	a5,a5,0x3
    8000445a:	963e                	add	a2,a2,a5
    8000445c:	e204                	sd	s1,0(a2)
      return fd;
    8000445e:	b7f5                	j	8000444a <fdalloc+0x2c>

0000000080004460 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004460:	715d                	add	sp,sp,-80
    80004462:	e486                	sd	ra,72(sp)
    80004464:	e0a2                	sd	s0,64(sp)
    80004466:	fc26                	sd	s1,56(sp)
    80004468:	f84a                	sd	s2,48(sp)
    8000446a:	f44e                	sd	s3,40(sp)
    8000446c:	f052                	sd	s4,32(sp)
    8000446e:	ec56                	sd	s5,24(sp)
    80004470:	e85a                	sd	s6,16(sp)
    80004472:	0880                	add	s0,sp,80
    80004474:	8b2e                	mv	s6,a1
    80004476:	89b2                	mv	s3,a2
    80004478:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000447a:	fb040593          	add	a1,s0,-80
    8000447e:	fffff097          	auipc	ra,0xfffff
    80004482:	e7e080e7          	jalr	-386(ra) # 800032fc <nameiparent>
    80004486:	84aa                	mv	s1,a0
    80004488:	14050b63          	beqz	a0,800045de <create+0x17e>
    return 0;

  ilock(dp);
    8000448c:	ffffe097          	auipc	ra,0xffffe
    80004490:	6ac080e7          	jalr	1708(ra) # 80002b38 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004494:	4601                	li	a2,0
    80004496:	fb040593          	add	a1,s0,-80
    8000449a:	8526                	mv	a0,s1
    8000449c:	fffff097          	auipc	ra,0xfffff
    800044a0:	b80080e7          	jalr	-1152(ra) # 8000301c <dirlookup>
    800044a4:	8aaa                	mv	s5,a0
    800044a6:	c921                	beqz	a0,800044f6 <create+0x96>
    iunlockput(dp);
    800044a8:	8526                	mv	a0,s1
    800044aa:	fffff097          	auipc	ra,0xfffff
    800044ae:	8f0080e7          	jalr	-1808(ra) # 80002d9a <iunlockput>
    ilock(ip);
    800044b2:	8556                	mv	a0,s5
    800044b4:	ffffe097          	auipc	ra,0xffffe
    800044b8:	684080e7          	jalr	1668(ra) # 80002b38 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800044bc:	4789                	li	a5,2
    800044be:	02fb1563          	bne	s6,a5,800044e8 <create+0x88>
    800044c2:	044ad783          	lhu	a5,68(s5)
    800044c6:	37f9                	addw	a5,a5,-2
    800044c8:	17c2                	sll	a5,a5,0x30
    800044ca:	93c1                	srl	a5,a5,0x30
    800044cc:	4705                	li	a4,1
    800044ce:	00f76d63          	bltu	a4,a5,800044e8 <create+0x88>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800044d2:	8556                	mv	a0,s5
    800044d4:	60a6                	ld	ra,72(sp)
    800044d6:	6406                	ld	s0,64(sp)
    800044d8:	74e2                	ld	s1,56(sp)
    800044da:	7942                	ld	s2,48(sp)
    800044dc:	79a2                	ld	s3,40(sp)
    800044de:	7a02                	ld	s4,32(sp)
    800044e0:	6ae2                	ld	s5,24(sp)
    800044e2:	6b42                	ld	s6,16(sp)
    800044e4:	6161                	add	sp,sp,80
    800044e6:	8082                	ret
    iunlockput(ip);
    800044e8:	8556                	mv	a0,s5
    800044ea:	fffff097          	auipc	ra,0xfffff
    800044ee:	8b0080e7          	jalr	-1872(ra) # 80002d9a <iunlockput>
    return 0;
    800044f2:	4a81                	li	s5,0
    800044f4:	bff9                	j	800044d2 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0){
    800044f6:	85da                	mv	a1,s6
    800044f8:	4088                	lw	a0,0(s1)
    800044fa:	ffffe097          	auipc	ra,0xffffe
    800044fe:	4a6080e7          	jalr	1190(ra) # 800029a0 <ialloc>
    80004502:	8a2a                	mv	s4,a0
    80004504:	c529                	beqz	a0,8000454e <create+0xee>
  ilock(ip);
    80004506:	ffffe097          	auipc	ra,0xffffe
    8000450a:	632080e7          	jalr	1586(ra) # 80002b38 <ilock>
  ip->major = major;
    8000450e:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004512:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004516:	4905                	li	s2,1
    80004518:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    8000451c:	8552                	mv	a0,s4
    8000451e:	ffffe097          	auipc	ra,0xffffe
    80004522:	54e080e7          	jalr	1358(ra) # 80002a6c <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004526:	032b0b63          	beq	s6,s2,8000455c <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    8000452a:	004a2603          	lw	a2,4(s4)
    8000452e:	fb040593          	add	a1,s0,-80
    80004532:	8526                	mv	a0,s1
    80004534:	fffff097          	auipc	ra,0xfffff
    80004538:	cf8080e7          	jalr	-776(ra) # 8000322c <dirlink>
    8000453c:	06054f63          	bltz	a0,800045ba <create+0x15a>
  iunlockput(dp);
    80004540:	8526                	mv	a0,s1
    80004542:	fffff097          	auipc	ra,0xfffff
    80004546:	858080e7          	jalr	-1960(ra) # 80002d9a <iunlockput>
  return ip;
    8000454a:	8ad2                	mv	s5,s4
    8000454c:	b759                	j	800044d2 <create+0x72>
    iunlockput(dp);
    8000454e:	8526                	mv	a0,s1
    80004550:	fffff097          	auipc	ra,0xfffff
    80004554:	84a080e7          	jalr	-1974(ra) # 80002d9a <iunlockput>
    return 0;
    80004558:	8ad2                	mv	s5,s4
    8000455a:	bfa5                	j	800044d2 <create+0x72>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000455c:	004a2603          	lw	a2,4(s4)
    80004560:	00004597          	auipc	a1,0x4
    80004564:	15058593          	add	a1,a1,336 # 800086b0 <syscalls+0x2a0>
    80004568:	8552                	mv	a0,s4
    8000456a:	fffff097          	auipc	ra,0xfffff
    8000456e:	cc2080e7          	jalr	-830(ra) # 8000322c <dirlink>
    80004572:	04054463          	bltz	a0,800045ba <create+0x15a>
    80004576:	40d0                	lw	a2,4(s1)
    80004578:	00004597          	auipc	a1,0x4
    8000457c:	14058593          	add	a1,a1,320 # 800086b8 <syscalls+0x2a8>
    80004580:	8552                	mv	a0,s4
    80004582:	fffff097          	auipc	ra,0xfffff
    80004586:	caa080e7          	jalr	-854(ra) # 8000322c <dirlink>
    8000458a:	02054863          	bltz	a0,800045ba <create+0x15a>
  if(dirlink(dp, name, ip->inum) < 0)
    8000458e:	004a2603          	lw	a2,4(s4)
    80004592:	fb040593          	add	a1,s0,-80
    80004596:	8526                	mv	a0,s1
    80004598:	fffff097          	auipc	ra,0xfffff
    8000459c:	c94080e7          	jalr	-876(ra) # 8000322c <dirlink>
    800045a0:	00054d63          	bltz	a0,800045ba <create+0x15a>
    dp->nlink++;  // for ".."
    800045a4:	04a4d783          	lhu	a5,74(s1)
    800045a8:	2785                	addw	a5,a5,1
    800045aa:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800045ae:	8526                	mv	a0,s1
    800045b0:	ffffe097          	auipc	ra,0xffffe
    800045b4:	4bc080e7          	jalr	1212(ra) # 80002a6c <iupdate>
    800045b8:	b761                	j	80004540 <create+0xe0>
  ip->nlink = 0;
    800045ba:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    800045be:	8552                	mv	a0,s4
    800045c0:	ffffe097          	auipc	ra,0xffffe
    800045c4:	4ac080e7          	jalr	1196(ra) # 80002a6c <iupdate>
  iunlockput(ip);
    800045c8:	8552                	mv	a0,s4
    800045ca:	ffffe097          	auipc	ra,0xffffe
    800045ce:	7d0080e7          	jalr	2000(ra) # 80002d9a <iunlockput>
  iunlockput(dp);
    800045d2:	8526                	mv	a0,s1
    800045d4:	ffffe097          	auipc	ra,0xffffe
    800045d8:	7c6080e7          	jalr	1990(ra) # 80002d9a <iunlockput>
  return 0;
    800045dc:	bddd                	j	800044d2 <create+0x72>
    return 0;
    800045de:	8aaa                	mv	s5,a0
    800045e0:	bdcd                	j	800044d2 <create+0x72>

00000000800045e2 <sys_dup>:
{
    800045e2:	7179                	add	sp,sp,-48
    800045e4:	f406                	sd	ra,40(sp)
    800045e6:	f022                	sd	s0,32(sp)
    800045e8:	ec26                	sd	s1,24(sp)
    800045ea:	e84a                	sd	s2,16(sp)
    800045ec:	1800                	add	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800045ee:	fd840613          	add	a2,s0,-40
    800045f2:	4581                	li	a1,0
    800045f4:	4501                	li	a0,0
    800045f6:	00000097          	auipc	ra,0x0
    800045fa:	dc8080e7          	jalr	-568(ra) # 800043be <argfd>
    return -1;
    800045fe:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004600:	02054363          	bltz	a0,80004626 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    80004604:	fd843903          	ld	s2,-40(s0)
    80004608:	854a                	mv	a0,s2
    8000460a:	00000097          	auipc	ra,0x0
    8000460e:	e14080e7          	jalr	-492(ra) # 8000441e <fdalloc>
    80004612:	84aa                	mv	s1,a0
    return -1;
    80004614:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004616:	00054863          	bltz	a0,80004626 <sys_dup+0x44>
  filedup(f);
    8000461a:	854a                	mv	a0,s2
    8000461c:	fffff097          	auipc	ra,0xfffff
    80004620:	334080e7          	jalr	820(ra) # 80003950 <filedup>
  return fd;
    80004624:	87a6                	mv	a5,s1
}
    80004626:	853e                	mv	a0,a5
    80004628:	70a2                	ld	ra,40(sp)
    8000462a:	7402                	ld	s0,32(sp)
    8000462c:	64e2                	ld	s1,24(sp)
    8000462e:	6942                	ld	s2,16(sp)
    80004630:	6145                	add	sp,sp,48
    80004632:	8082                	ret

0000000080004634 <sys_read>:
{
    80004634:	7179                	add	sp,sp,-48
    80004636:	f406                	sd	ra,40(sp)
    80004638:	f022                	sd	s0,32(sp)
    8000463a:	1800                	add	s0,sp,48
  argaddr(1, &p);
    8000463c:	fd840593          	add	a1,s0,-40
    80004640:	4505                	li	a0,1
    80004642:	ffffe097          	auipc	ra,0xffffe
    80004646:	9a6080e7          	jalr	-1626(ra) # 80001fe8 <argaddr>
  argint(2, &n);
    8000464a:	fe440593          	add	a1,s0,-28
    8000464e:	4509                	li	a0,2
    80004650:	ffffe097          	auipc	ra,0xffffe
    80004654:	978080e7          	jalr	-1672(ra) # 80001fc8 <argint>
  if(argfd(0, 0, &f) < 0)
    80004658:	fe840613          	add	a2,s0,-24
    8000465c:	4581                	li	a1,0
    8000465e:	4501                	li	a0,0
    80004660:	00000097          	auipc	ra,0x0
    80004664:	d5e080e7          	jalr	-674(ra) # 800043be <argfd>
    80004668:	87aa                	mv	a5,a0
    return -1;
    8000466a:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000466c:	0007cc63          	bltz	a5,80004684 <sys_read+0x50>
  return fileread(f, p, n);
    80004670:	fe442603          	lw	a2,-28(s0)
    80004674:	fd843583          	ld	a1,-40(s0)
    80004678:	fe843503          	ld	a0,-24(s0)
    8000467c:	fffff097          	auipc	ra,0xfffff
    80004680:	460080e7          	jalr	1120(ra) # 80003adc <fileread>
}
    80004684:	70a2                	ld	ra,40(sp)
    80004686:	7402                	ld	s0,32(sp)
    80004688:	6145                	add	sp,sp,48
    8000468a:	8082                	ret

000000008000468c <sys_write>:
{
    8000468c:	7179                	add	sp,sp,-48
    8000468e:	f406                	sd	ra,40(sp)
    80004690:	f022                	sd	s0,32(sp)
    80004692:	1800                	add	s0,sp,48
  argaddr(1, &p);
    80004694:	fd840593          	add	a1,s0,-40
    80004698:	4505                	li	a0,1
    8000469a:	ffffe097          	auipc	ra,0xffffe
    8000469e:	94e080e7          	jalr	-1714(ra) # 80001fe8 <argaddr>
  argint(2, &n);
    800046a2:	fe440593          	add	a1,s0,-28
    800046a6:	4509                	li	a0,2
    800046a8:	ffffe097          	auipc	ra,0xffffe
    800046ac:	920080e7          	jalr	-1760(ra) # 80001fc8 <argint>
  if(argfd(0, 0, &f) < 0)
    800046b0:	fe840613          	add	a2,s0,-24
    800046b4:	4581                	li	a1,0
    800046b6:	4501                	li	a0,0
    800046b8:	00000097          	auipc	ra,0x0
    800046bc:	d06080e7          	jalr	-762(ra) # 800043be <argfd>
    800046c0:	87aa                	mv	a5,a0
    return -1;
    800046c2:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800046c4:	0007cc63          	bltz	a5,800046dc <sys_write+0x50>
  return filewrite(f, p, n);
    800046c8:	fe442603          	lw	a2,-28(s0)
    800046cc:	fd843583          	ld	a1,-40(s0)
    800046d0:	fe843503          	ld	a0,-24(s0)
    800046d4:	fffff097          	auipc	ra,0xfffff
    800046d8:	4ca080e7          	jalr	1226(ra) # 80003b9e <filewrite>
}
    800046dc:	70a2                	ld	ra,40(sp)
    800046de:	7402                	ld	s0,32(sp)
    800046e0:	6145                	add	sp,sp,48
    800046e2:	8082                	ret

00000000800046e4 <sys_close>:
{
    800046e4:	1101                	add	sp,sp,-32
    800046e6:	ec06                	sd	ra,24(sp)
    800046e8:	e822                	sd	s0,16(sp)
    800046ea:	1000                	add	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800046ec:	fe040613          	add	a2,s0,-32
    800046f0:	fec40593          	add	a1,s0,-20
    800046f4:	4501                	li	a0,0
    800046f6:	00000097          	auipc	ra,0x0
    800046fa:	cc8080e7          	jalr	-824(ra) # 800043be <argfd>
    return -1;
    800046fe:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004700:	02054463          	bltz	a0,80004728 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004704:	ffffc097          	auipc	ra,0xffffc
    80004708:	7a6080e7          	jalr	1958(ra) # 80000eaa <myproc>
    8000470c:	fec42783          	lw	a5,-20(s0)
    80004710:	07e9                	add	a5,a5,26
    80004712:	078e                	sll	a5,a5,0x3
    80004714:	953e                	add	a0,a0,a5
    80004716:	00053023          	sd	zero,0(a0)
  fileclose(f);
    8000471a:	fe043503          	ld	a0,-32(s0)
    8000471e:	fffff097          	auipc	ra,0xfffff
    80004722:	284080e7          	jalr	644(ra) # 800039a2 <fileclose>
  return 0;
    80004726:	4781                	li	a5,0
}
    80004728:	853e                	mv	a0,a5
    8000472a:	60e2                	ld	ra,24(sp)
    8000472c:	6442                	ld	s0,16(sp)
    8000472e:	6105                	add	sp,sp,32
    80004730:	8082                	ret

0000000080004732 <sys_fstat>:
{
    80004732:	1101                	add	sp,sp,-32
    80004734:	ec06                	sd	ra,24(sp)
    80004736:	e822                	sd	s0,16(sp)
    80004738:	1000                	add	s0,sp,32
  argaddr(1, &st);
    8000473a:	fe040593          	add	a1,s0,-32
    8000473e:	4505                	li	a0,1
    80004740:	ffffe097          	auipc	ra,0xffffe
    80004744:	8a8080e7          	jalr	-1880(ra) # 80001fe8 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004748:	fe840613          	add	a2,s0,-24
    8000474c:	4581                	li	a1,0
    8000474e:	4501                	li	a0,0
    80004750:	00000097          	auipc	ra,0x0
    80004754:	c6e080e7          	jalr	-914(ra) # 800043be <argfd>
    80004758:	87aa                	mv	a5,a0
    return -1;
    8000475a:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000475c:	0007ca63          	bltz	a5,80004770 <sys_fstat+0x3e>
  return filestat(f, st);
    80004760:	fe043583          	ld	a1,-32(s0)
    80004764:	fe843503          	ld	a0,-24(s0)
    80004768:	fffff097          	auipc	ra,0xfffff
    8000476c:	302080e7          	jalr	770(ra) # 80003a6a <filestat>
}
    80004770:	60e2                	ld	ra,24(sp)
    80004772:	6442                	ld	s0,16(sp)
    80004774:	6105                	add	sp,sp,32
    80004776:	8082                	ret

0000000080004778 <sys_link>:
{
    80004778:	7169                	add	sp,sp,-304
    8000477a:	f606                	sd	ra,296(sp)
    8000477c:	f222                	sd	s0,288(sp)
    8000477e:	ee26                	sd	s1,280(sp)
    80004780:	ea4a                	sd	s2,272(sp)
    80004782:	1a00                	add	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004784:	08000613          	li	a2,128
    80004788:	ed040593          	add	a1,s0,-304
    8000478c:	4501                	li	a0,0
    8000478e:	ffffe097          	auipc	ra,0xffffe
    80004792:	87a080e7          	jalr	-1926(ra) # 80002008 <argstr>
    return -1;
    80004796:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004798:	10054e63          	bltz	a0,800048b4 <sys_link+0x13c>
    8000479c:	08000613          	li	a2,128
    800047a0:	f5040593          	add	a1,s0,-176
    800047a4:	4505                	li	a0,1
    800047a6:	ffffe097          	auipc	ra,0xffffe
    800047aa:	862080e7          	jalr	-1950(ra) # 80002008 <argstr>
    return -1;
    800047ae:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800047b0:	10054263          	bltz	a0,800048b4 <sys_link+0x13c>
  begin_op();
    800047b4:	fffff097          	auipc	ra,0xfffff
    800047b8:	d2a080e7          	jalr	-726(ra) # 800034de <begin_op>
  if((ip = namei(old)) == 0){
    800047bc:	ed040513          	add	a0,s0,-304
    800047c0:	fffff097          	auipc	ra,0xfffff
    800047c4:	b1e080e7          	jalr	-1250(ra) # 800032de <namei>
    800047c8:	84aa                	mv	s1,a0
    800047ca:	c551                	beqz	a0,80004856 <sys_link+0xde>
  ilock(ip);
    800047cc:	ffffe097          	auipc	ra,0xffffe
    800047d0:	36c080e7          	jalr	876(ra) # 80002b38 <ilock>
  if(ip->type == T_DIR){
    800047d4:	04449703          	lh	a4,68(s1)
    800047d8:	4785                	li	a5,1
    800047da:	08f70463          	beq	a4,a5,80004862 <sys_link+0xea>
  ip->nlink++;
    800047de:	04a4d783          	lhu	a5,74(s1)
    800047e2:	2785                	addw	a5,a5,1
    800047e4:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800047e8:	8526                	mv	a0,s1
    800047ea:	ffffe097          	auipc	ra,0xffffe
    800047ee:	282080e7          	jalr	642(ra) # 80002a6c <iupdate>
  iunlock(ip);
    800047f2:	8526                	mv	a0,s1
    800047f4:	ffffe097          	auipc	ra,0xffffe
    800047f8:	406080e7          	jalr	1030(ra) # 80002bfa <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800047fc:	fd040593          	add	a1,s0,-48
    80004800:	f5040513          	add	a0,s0,-176
    80004804:	fffff097          	auipc	ra,0xfffff
    80004808:	af8080e7          	jalr	-1288(ra) # 800032fc <nameiparent>
    8000480c:	892a                	mv	s2,a0
    8000480e:	c935                	beqz	a0,80004882 <sys_link+0x10a>
  ilock(dp);
    80004810:	ffffe097          	auipc	ra,0xffffe
    80004814:	328080e7          	jalr	808(ra) # 80002b38 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004818:	00092703          	lw	a4,0(s2)
    8000481c:	409c                	lw	a5,0(s1)
    8000481e:	04f71d63          	bne	a4,a5,80004878 <sys_link+0x100>
    80004822:	40d0                	lw	a2,4(s1)
    80004824:	fd040593          	add	a1,s0,-48
    80004828:	854a                	mv	a0,s2
    8000482a:	fffff097          	auipc	ra,0xfffff
    8000482e:	a02080e7          	jalr	-1534(ra) # 8000322c <dirlink>
    80004832:	04054363          	bltz	a0,80004878 <sys_link+0x100>
  iunlockput(dp);
    80004836:	854a                	mv	a0,s2
    80004838:	ffffe097          	auipc	ra,0xffffe
    8000483c:	562080e7          	jalr	1378(ra) # 80002d9a <iunlockput>
  iput(ip);
    80004840:	8526                	mv	a0,s1
    80004842:	ffffe097          	auipc	ra,0xffffe
    80004846:	4b0080e7          	jalr	1200(ra) # 80002cf2 <iput>
  end_op();
    8000484a:	fffff097          	auipc	ra,0xfffff
    8000484e:	d0e080e7          	jalr	-754(ra) # 80003558 <end_op>
  return 0;
    80004852:	4781                	li	a5,0
    80004854:	a085                	j	800048b4 <sys_link+0x13c>
    end_op();
    80004856:	fffff097          	auipc	ra,0xfffff
    8000485a:	d02080e7          	jalr	-766(ra) # 80003558 <end_op>
    return -1;
    8000485e:	57fd                	li	a5,-1
    80004860:	a891                	j	800048b4 <sys_link+0x13c>
    iunlockput(ip);
    80004862:	8526                	mv	a0,s1
    80004864:	ffffe097          	auipc	ra,0xffffe
    80004868:	536080e7          	jalr	1334(ra) # 80002d9a <iunlockput>
    end_op();
    8000486c:	fffff097          	auipc	ra,0xfffff
    80004870:	cec080e7          	jalr	-788(ra) # 80003558 <end_op>
    return -1;
    80004874:	57fd                	li	a5,-1
    80004876:	a83d                	j	800048b4 <sys_link+0x13c>
    iunlockput(dp);
    80004878:	854a                	mv	a0,s2
    8000487a:	ffffe097          	auipc	ra,0xffffe
    8000487e:	520080e7          	jalr	1312(ra) # 80002d9a <iunlockput>
  ilock(ip);
    80004882:	8526                	mv	a0,s1
    80004884:	ffffe097          	auipc	ra,0xffffe
    80004888:	2b4080e7          	jalr	692(ra) # 80002b38 <ilock>
  ip->nlink--;
    8000488c:	04a4d783          	lhu	a5,74(s1)
    80004890:	37fd                	addw	a5,a5,-1
    80004892:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004896:	8526                	mv	a0,s1
    80004898:	ffffe097          	auipc	ra,0xffffe
    8000489c:	1d4080e7          	jalr	468(ra) # 80002a6c <iupdate>
  iunlockput(ip);
    800048a0:	8526                	mv	a0,s1
    800048a2:	ffffe097          	auipc	ra,0xffffe
    800048a6:	4f8080e7          	jalr	1272(ra) # 80002d9a <iunlockput>
  end_op();
    800048aa:	fffff097          	auipc	ra,0xfffff
    800048ae:	cae080e7          	jalr	-850(ra) # 80003558 <end_op>
  return -1;
    800048b2:	57fd                	li	a5,-1
}
    800048b4:	853e                	mv	a0,a5
    800048b6:	70b2                	ld	ra,296(sp)
    800048b8:	7412                	ld	s0,288(sp)
    800048ba:	64f2                	ld	s1,280(sp)
    800048bc:	6952                	ld	s2,272(sp)
    800048be:	6155                	add	sp,sp,304
    800048c0:	8082                	ret

00000000800048c2 <sys_unlink>:
{
    800048c2:	7151                	add	sp,sp,-240
    800048c4:	f586                	sd	ra,232(sp)
    800048c6:	f1a2                	sd	s0,224(sp)
    800048c8:	eda6                	sd	s1,216(sp)
    800048ca:	e9ca                	sd	s2,208(sp)
    800048cc:	e5ce                	sd	s3,200(sp)
    800048ce:	1980                	add	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800048d0:	08000613          	li	a2,128
    800048d4:	f3040593          	add	a1,s0,-208
    800048d8:	4501                	li	a0,0
    800048da:	ffffd097          	auipc	ra,0xffffd
    800048de:	72e080e7          	jalr	1838(ra) # 80002008 <argstr>
    800048e2:	18054163          	bltz	a0,80004a64 <sys_unlink+0x1a2>
  begin_op();
    800048e6:	fffff097          	auipc	ra,0xfffff
    800048ea:	bf8080e7          	jalr	-1032(ra) # 800034de <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800048ee:	fb040593          	add	a1,s0,-80
    800048f2:	f3040513          	add	a0,s0,-208
    800048f6:	fffff097          	auipc	ra,0xfffff
    800048fa:	a06080e7          	jalr	-1530(ra) # 800032fc <nameiparent>
    800048fe:	84aa                	mv	s1,a0
    80004900:	c979                	beqz	a0,800049d6 <sys_unlink+0x114>
  ilock(dp);
    80004902:	ffffe097          	auipc	ra,0xffffe
    80004906:	236080e7          	jalr	566(ra) # 80002b38 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    8000490a:	00004597          	auipc	a1,0x4
    8000490e:	da658593          	add	a1,a1,-602 # 800086b0 <syscalls+0x2a0>
    80004912:	fb040513          	add	a0,s0,-80
    80004916:	ffffe097          	auipc	ra,0xffffe
    8000491a:	6ec080e7          	jalr	1772(ra) # 80003002 <namecmp>
    8000491e:	14050a63          	beqz	a0,80004a72 <sys_unlink+0x1b0>
    80004922:	00004597          	auipc	a1,0x4
    80004926:	d9658593          	add	a1,a1,-618 # 800086b8 <syscalls+0x2a8>
    8000492a:	fb040513          	add	a0,s0,-80
    8000492e:	ffffe097          	auipc	ra,0xffffe
    80004932:	6d4080e7          	jalr	1748(ra) # 80003002 <namecmp>
    80004936:	12050e63          	beqz	a0,80004a72 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    8000493a:	f2c40613          	add	a2,s0,-212
    8000493e:	fb040593          	add	a1,s0,-80
    80004942:	8526                	mv	a0,s1
    80004944:	ffffe097          	auipc	ra,0xffffe
    80004948:	6d8080e7          	jalr	1752(ra) # 8000301c <dirlookup>
    8000494c:	892a                	mv	s2,a0
    8000494e:	12050263          	beqz	a0,80004a72 <sys_unlink+0x1b0>
  ilock(ip);
    80004952:	ffffe097          	auipc	ra,0xffffe
    80004956:	1e6080e7          	jalr	486(ra) # 80002b38 <ilock>
  if(ip->nlink < 1)
    8000495a:	04a91783          	lh	a5,74(s2)
    8000495e:	08f05263          	blez	a5,800049e2 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004962:	04491703          	lh	a4,68(s2)
    80004966:	4785                	li	a5,1
    80004968:	08f70563          	beq	a4,a5,800049f2 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    8000496c:	4641                	li	a2,16
    8000496e:	4581                	li	a1,0
    80004970:	fc040513          	add	a0,s0,-64
    80004974:	ffffc097          	auipc	ra,0xffffc
    80004978:	806080e7          	jalr	-2042(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000497c:	4741                	li	a4,16
    8000497e:	f2c42683          	lw	a3,-212(s0)
    80004982:	fc040613          	add	a2,s0,-64
    80004986:	4581                	li	a1,0
    80004988:	8526                	mv	a0,s1
    8000498a:	ffffe097          	auipc	ra,0xffffe
    8000498e:	55a080e7          	jalr	1370(ra) # 80002ee4 <writei>
    80004992:	47c1                	li	a5,16
    80004994:	0af51563          	bne	a0,a5,80004a3e <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004998:	04491703          	lh	a4,68(s2)
    8000499c:	4785                	li	a5,1
    8000499e:	0af70863          	beq	a4,a5,80004a4e <sys_unlink+0x18c>
  iunlockput(dp);
    800049a2:	8526                	mv	a0,s1
    800049a4:	ffffe097          	auipc	ra,0xffffe
    800049a8:	3f6080e7          	jalr	1014(ra) # 80002d9a <iunlockput>
  ip->nlink--;
    800049ac:	04a95783          	lhu	a5,74(s2)
    800049b0:	37fd                	addw	a5,a5,-1
    800049b2:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800049b6:	854a                	mv	a0,s2
    800049b8:	ffffe097          	auipc	ra,0xffffe
    800049bc:	0b4080e7          	jalr	180(ra) # 80002a6c <iupdate>
  iunlockput(ip);
    800049c0:	854a                	mv	a0,s2
    800049c2:	ffffe097          	auipc	ra,0xffffe
    800049c6:	3d8080e7          	jalr	984(ra) # 80002d9a <iunlockput>
  end_op();
    800049ca:	fffff097          	auipc	ra,0xfffff
    800049ce:	b8e080e7          	jalr	-1138(ra) # 80003558 <end_op>
  return 0;
    800049d2:	4501                	li	a0,0
    800049d4:	a84d                	j	80004a86 <sys_unlink+0x1c4>
    end_op();
    800049d6:	fffff097          	auipc	ra,0xfffff
    800049da:	b82080e7          	jalr	-1150(ra) # 80003558 <end_op>
    return -1;
    800049de:	557d                	li	a0,-1
    800049e0:	a05d                	j	80004a86 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    800049e2:	00004517          	auipc	a0,0x4
    800049e6:	cde50513          	add	a0,a0,-802 # 800086c0 <syscalls+0x2b0>
    800049ea:	00001097          	auipc	ra,0x1
    800049ee:	1ac080e7          	jalr	428(ra) # 80005b96 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800049f2:	04c92703          	lw	a4,76(s2)
    800049f6:	02000793          	li	a5,32
    800049fa:	f6e7f9e3          	bgeu	a5,a4,8000496c <sys_unlink+0xaa>
    800049fe:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a02:	4741                	li	a4,16
    80004a04:	86ce                	mv	a3,s3
    80004a06:	f1840613          	add	a2,s0,-232
    80004a0a:	4581                	li	a1,0
    80004a0c:	854a                	mv	a0,s2
    80004a0e:	ffffe097          	auipc	ra,0xffffe
    80004a12:	3de080e7          	jalr	990(ra) # 80002dec <readi>
    80004a16:	47c1                	li	a5,16
    80004a18:	00f51b63          	bne	a0,a5,80004a2e <sys_unlink+0x16c>
    if(de.inum != 0)
    80004a1c:	f1845783          	lhu	a5,-232(s0)
    80004a20:	e7a1                	bnez	a5,80004a68 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a22:	29c1                	addw	s3,s3,16
    80004a24:	04c92783          	lw	a5,76(s2)
    80004a28:	fcf9ede3          	bltu	s3,a5,80004a02 <sys_unlink+0x140>
    80004a2c:	b781                	j	8000496c <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004a2e:	00004517          	auipc	a0,0x4
    80004a32:	caa50513          	add	a0,a0,-854 # 800086d8 <syscalls+0x2c8>
    80004a36:	00001097          	auipc	ra,0x1
    80004a3a:	160080e7          	jalr	352(ra) # 80005b96 <panic>
    panic("unlink: writei");
    80004a3e:	00004517          	auipc	a0,0x4
    80004a42:	cb250513          	add	a0,a0,-846 # 800086f0 <syscalls+0x2e0>
    80004a46:	00001097          	auipc	ra,0x1
    80004a4a:	150080e7          	jalr	336(ra) # 80005b96 <panic>
    dp->nlink--;
    80004a4e:	04a4d783          	lhu	a5,74(s1)
    80004a52:	37fd                	addw	a5,a5,-1
    80004a54:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004a58:	8526                	mv	a0,s1
    80004a5a:	ffffe097          	auipc	ra,0xffffe
    80004a5e:	012080e7          	jalr	18(ra) # 80002a6c <iupdate>
    80004a62:	b781                	j	800049a2 <sys_unlink+0xe0>
    return -1;
    80004a64:	557d                	li	a0,-1
    80004a66:	a005                	j	80004a86 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004a68:	854a                	mv	a0,s2
    80004a6a:	ffffe097          	auipc	ra,0xffffe
    80004a6e:	330080e7          	jalr	816(ra) # 80002d9a <iunlockput>
  iunlockput(dp);
    80004a72:	8526                	mv	a0,s1
    80004a74:	ffffe097          	auipc	ra,0xffffe
    80004a78:	326080e7          	jalr	806(ra) # 80002d9a <iunlockput>
  end_op();
    80004a7c:	fffff097          	auipc	ra,0xfffff
    80004a80:	adc080e7          	jalr	-1316(ra) # 80003558 <end_op>
  return -1;
    80004a84:	557d                	li	a0,-1
}
    80004a86:	70ae                	ld	ra,232(sp)
    80004a88:	740e                	ld	s0,224(sp)
    80004a8a:	64ee                	ld	s1,216(sp)
    80004a8c:	694e                	ld	s2,208(sp)
    80004a8e:	69ae                	ld	s3,200(sp)
    80004a90:	616d                	add	sp,sp,240
    80004a92:	8082                	ret

0000000080004a94 <sys_open>:

uint64
sys_open(void)
{
    80004a94:	7131                	add	sp,sp,-192
    80004a96:	fd06                	sd	ra,184(sp)
    80004a98:	f922                	sd	s0,176(sp)
    80004a9a:	f526                	sd	s1,168(sp)
    80004a9c:	f14a                	sd	s2,160(sp)
    80004a9e:	ed4e                	sd	s3,152(sp)
    80004aa0:	0180                	add	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004aa2:	f4c40593          	add	a1,s0,-180
    80004aa6:	4505                	li	a0,1
    80004aa8:	ffffd097          	auipc	ra,0xffffd
    80004aac:	520080e7          	jalr	1312(ra) # 80001fc8 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004ab0:	08000613          	li	a2,128
    80004ab4:	f5040593          	add	a1,s0,-176
    80004ab8:	4501                	li	a0,0
    80004aba:	ffffd097          	auipc	ra,0xffffd
    80004abe:	54e080e7          	jalr	1358(ra) # 80002008 <argstr>
    80004ac2:	87aa                	mv	a5,a0
    return -1;
    80004ac4:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004ac6:	0a07c863          	bltz	a5,80004b76 <sys_open+0xe2>

  begin_op();
    80004aca:	fffff097          	auipc	ra,0xfffff
    80004ace:	a14080e7          	jalr	-1516(ra) # 800034de <begin_op>

  if(omode & O_CREATE){
    80004ad2:	f4c42783          	lw	a5,-180(s0)
    80004ad6:	2007f793          	and	a5,a5,512
    80004ada:	cbdd                	beqz	a5,80004b90 <sys_open+0xfc>
    ip = create(path, T_FILE, 0, 0);
    80004adc:	4681                	li	a3,0
    80004ade:	4601                	li	a2,0
    80004ae0:	4589                	li	a1,2
    80004ae2:	f5040513          	add	a0,s0,-176
    80004ae6:	00000097          	auipc	ra,0x0
    80004aea:	97a080e7          	jalr	-1670(ra) # 80004460 <create>
    80004aee:	84aa                	mv	s1,a0
    if(ip == 0){
    80004af0:	c951                	beqz	a0,80004b84 <sys_open+0xf0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004af2:	04449703          	lh	a4,68(s1)
    80004af6:	478d                	li	a5,3
    80004af8:	00f71763          	bne	a4,a5,80004b06 <sys_open+0x72>
    80004afc:	0464d703          	lhu	a4,70(s1)
    80004b00:	47a5                	li	a5,9
    80004b02:	0ce7ec63          	bltu	a5,a4,80004bda <sys_open+0x146>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004b06:	fffff097          	auipc	ra,0xfffff
    80004b0a:	de0080e7          	jalr	-544(ra) # 800038e6 <filealloc>
    80004b0e:	892a                	mv	s2,a0
    80004b10:	c56d                	beqz	a0,80004bfa <sys_open+0x166>
    80004b12:	00000097          	auipc	ra,0x0
    80004b16:	90c080e7          	jalr	-1780(ra) # 8000441e <fdalloc>
    80004b1a:	89aa                	mv	s3,a0
    80004b1c:	0c054a63          	bltz	a0,80004bf0 <sys_open+0x15c>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004b20:	04449703          	lh	a4,68(s1)
    80004b24:	478d                	li	a5,3
    80004b26:	0ef70563          	beq	a4,a5,80004c10 <sys_open+0x17c>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004b2a:	4789                	li	a5,2
    80004b2c:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004b30:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004b34:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004b38:	f4c42783          	lw	a5,-180(s0)
    80004b3c:	0017c713          	xor	a4,a5,1
    80004b40:	8b05                	and	a4,a4,1
    80004b42:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004b46:	0037f713          	and	a4,a5,3
    80004b4a:	00e03733          	snez	a4,a4
    80004b4e:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004b52:	4007f793          	and	a5,a5,1024
    80004b56:	c791                	beqz	a5,80004b62 <sys_open+0xce>
    80004b58:	04449703          	lh	a4,68(s1)
    80004b5c:	4789                	li	a5,2
    80004b5e:	0cf70063          	beq	a4,a5,80004c1e <sys_open+0x18a>
    itrunc(ip);
  }

  iunlock(ip);
    80004b62:	8526                	mv	a0,s1
    80004b64:	ffffe097          	auipc	ra,0xffffe
    80004b68:	096080e7          	jalr	150(ra) # 80002bfa <iunlock>
  end_op();
    80004b6c:	fffff097          	auipc	ra,0xfffff
    80004b70:	9ec080e7          	jalr	-1556(ra) # 80003558 <end_op>

  return fd;
    80004b74:	854e                	mv	a0,s3
}
    80004b76:	70ea                	ld	ra,184(sp)
    80004b78:	744a                	ld	s0,176(sp)
    80004b7a:	74aa                	ld	s1,168(sp)
    80004b7c:	790a                	ld	s2,160(sp)
    80004b7e:	69ea                	ld	s3,152(sp)
    80004b80:	6129                	add	sp,sp,192
    80004b82:	8082                	ret
      end_op();
    80004b84:	fffff097          	auipc	ra,0xfffff
    80004b88:	9d4080e7          	jalr	-1580(ra) # 80003558 <end_op>
      return -1;
    80004b8c:	557d                	li	a0,-1
    80004b8e:	b7e5                	j	80004b76 <sys_open+0xe2>
    if((ip = namei(path)) == 0){
    80004b90:	f5040513          	add	a0,s0,-176
    80004b94:	ffffe097          	auipc	ra,0xffffe
    80004b98:	74a080e7          	jalr	1866(ra) # 800032de <namei>
    80004b9c:	84aa                	mv	s1,a0
    80004b9e:	c905                	beqz	a0,80004bce <sys_open+0x13a>
    ilock(ip);
    80004ba0:	ffffe097          	auipc	ra,0xffffe
    80004ba4:	f98080e7          	jalr	-104(ra) # 80002b38 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004ba8:	04449703          	lh	a4,68(s1)
    80004bac:	4785                	li	a5,1
    80004bae:	f4f712e3          	bne	a4,a5,80004af2 <sys_open+0x5e>
    80004bb2:	f4c42783          	lw	a5,-180(s0)
    80004bb6:	dba1                	beqz	a5,80004b06 <sys_open+0x72>
      iunlockput(ip);
    80004bb8:	8526                	mv	a0,s1
    80004bba:	ffffe097          	auipc	ra,0xffffe
    80004bbe:	1e0080e7          	jalr	480(ra) # 80002d9a <iunlockput>
      end_op();
    80004bc2:	fffff097          	auipc	ra,0xfffff
    80004bc6:	996080e7          	jalr	-1642(ra) # 80003558 <end_op>
      return -1;
    80004bca:	557d                	li	a0,-1
    80004bcc:	b76d                	j	80004b76 <sys_open+0xe2>
      end_op();
    80004bce:	fffff097          	auipc	ra,0xfffff
    80004bd2:	98a080e7          	jalr	-1654(ra) # 80003558 <end_op>
      return -1;
    80004bd6:	557d                	li	a0,-1
    80004bd8:	bf79                	j	80004b76 <sys_open+0xe2>
    iunlockput(ip);
    80004bda:	8526                	mv	a0,s1
    80004bdc:	ffffe097          	auipc	ra,0xffffe
    80004be0:	1be080e7          	jalr	446(ra) # 80002d9a <iunlockput>
    end_op();
    80004be4:	fffff097          	auipc	ra,0xfffff
    80004be8:	974080e7          	jalr	-1676(ra) # 80003558 <end_op>
    return -1;
    80004bec:	557d                	li	a0,-1
    80004bee:	b761                	j	80004b76 <sys_open+0xe2>
      fileclose(f);
    80004bf0:	854a                	mv	a0,s2
    80004bf2:	fffff097          	auipc	ra,0xfffff
    80004bf6:	db0080e7          	jalr	-592(ra) # 800039a2 <fileclose>
    iunlockput(ip);
    80004bfa:	8526                	mv	a0,s1
    80004bfc:	ffffe097          	auipc	ra,0xffffe
    80004c00:	19e080e7          	jalr	414(ra) # 80002d9a <iunlockput>
    end_op();
    80004c04:	fffff097          	auipc	ra,0xfffff
    80004c08:	954080e7          	jalr	-1708(ra) # 80003558 <end_op>
    return -1;
    80004c0c:	557d                	li	a0,-1
    80004c0e:	b7a5                	j	80004b76 <sys_open+0xe2>
    f->type = FD_DEVICE;
    80004c10:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004c14:	04649783          	lh	a5,70(s1)
    80004c18:	02f91223          	sh	a5,36(s2)
    80004c1c:	bf21                	j	80004b34 <sys_open+0xa0>
    itrunc(ip);
    80004c1e:	8526                	mv	a0,s1
    80004c20:	ffffe097          	auipc	ra,0xffffe
    80004c24:	026080e7          	jalr	38(ra) # 80002c46 <itrunc>
    80004c28:	bf2d                	j	80004b62 <sys_open+0xce>

0000000080004c2a <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004c2a:	7175                	add	sp,sp,-144
    80004c2c:	e506                	sd	ra,136(sp)
    80004c2e:	e122                	sd	s0,128(sp)
    80004c30:	0900                	add	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004c32:	fffff097          	auipc	ra,0xfffff
    80004c36:	8ac080e7          	jalr	-1876(ra) # 800034de <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004c3a:	08000613          	li	a2,128
    80004c3e:	f7040593          	add	a1,s0,-144
    80004c42:	4501                	li	a0,0
    80004c44:	ffffd097          	auipc	ra,0xffffd
    80004c48:	3c4080e7          	jalr	964(ra) # 80002008 <argstr>
    80004c4c:	02054963          	bltz	a0,80004c7e <sys_mkdir+0x54>
    80004c50:	4681                	li	a3,0
    80004c52:	4601                	li	a2,0
    80004c54:	4585                	li	a1,1
    80004c56:	f7040513          	add	a0,s0,-144
    80004c5a:	00000097          	auipc	ra,0x0
    80004c5e:	806080e7          	jalr	-2042(ra) # 80004460 <create>
    80004c62:	cd11                	beqz	a0,80004c7e <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004c64:	ffffe097          	auipc	ra,0xffffe
    80004c68:	136080e7          	jalr	310(ra) # 80002d9a <iunlockput>
  end_op();
    80004c6c:	fffff097          	auipc	ra,0xfffff
    80004c70:	8ec080e7          	jalr	-1812(ra) # 80003558 <end_op>
  return 0;
    80004c74:	4501                	li	a0,0
}
    80004c76:	60aa                	ld	ra,136(sp)
    80004c78:	640a                	ld	s0,128(sp)
    80004c7a:	6149                	add	sp,sp,144
    80004c7c:	8082                	ret
    end_op();
    80004c7e:	fffff097          	auipc	ra,0xfffff
    80004c82:	8da080e7          	jalr	-1830(ra) # 80003558 <end_op>
    return -1;
    80004c86:	557d                	li	a0,-1
    80004c88:	b7fd                	j	80004c76 <sys_mkdir+0x4c>

0000000080004c8a <sys_mknod>:

uint64
sys_mknod(void)
{
    80004c8a:	7135                	add	sp,sp,-160
    80004c8c:	ed06                	sd	ra,152(sp)
    80004c8e:	e922                	sd	s0,144(sp)
    80004c90:	1100                	add	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004c92:	fffff097          	auipc	ra,0xfffff
    80004c96:	84c080e7          	jalr	-1972(ra) # 800034de <begin_op>
  argint(1, &major);
    80004c9a:	f6c40593          	add	a1,s0,-148
    80004c9e:	4505                	li	a0,1
    80004ca0:	ffffd097          	auipc	ra,0xffffd
    80004ca4:	328080e7          	jalr	808(ra) # 80001fc8 <argint>
  argint(2, &minor);
    80004ca8:	f6840593          	add	a1,s0,-152
    80004cac:	4509                	li	a0,2
    80004cae:	ffffd097          	auipc	ra,0xffffd
    80004cb2:	31a080e7          	jalr	794(ra) # 80001fc8 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004cb6:	08000613          	li	a2,128
    80004cba:	f7040593          	add	a1,s0,-144
    80004cbe:	4501                	li	a0,0
    80004cc0:	ffffd097          	auipc	ra,0xffffd
    80004cc4:	348080e7          	jalr	840(ra) # 80002008 <argstr>
    80004cc8:	02054b63          	bltz	a0,80004cfe <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004ccc:	f6841683          	lh	a3,-152(s0)
    80004cd0:	f6c41603          	lh	a2,-148(s0)
    80004cd4:	458d                	li	a1,3
    80004cd6:	f7040513          	add	a0,s0,-144
    80004cda:	fffff097          	auipc	ra,0xfffff
    80004cde:	786080e7          	jalr	1926(ra) # 80004460 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004ce2:	cd11                	beqz	a0,80004cfe <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004ce4:	ffffe097          	auipc	ra,0xffffe
    80004ce8:	0b6080e7          	jalr	182(ra) # 80002d9a <iunlockput>
  end_op();
    80004cec:	fffff097          	auipc	ra,0xfffff
    80004cf0:	86c080e7          	jalr	-1940(ra) # 80003558 <end_op>
  return 0;
    80004cf4:	4501                	li	a0,0
}
    80004cf6:	60ea                	ld	ra,152(sp)
    80004cf8:	644a                	ld	s0,144(sp)
    80004cfa:	610d                	add	sp,sp,160
    80004cfc:	8082                	ret
    end_op();
    80004cfe:	fffff097          	auipc	ra,0xfffff
    80004d02:	85a080e7          	jalr	-1958(ra) # 80003558 <end_op>
    return -1;
    80004d06:	557d                	li	a0,-1
    80004d08:	b7fd                	j	80004cf6 <sys_mknod+0x6c>

0000000080004d0a <sys_chdir>:

uint64
sys_chdir(void)
{
    80004d0a:	7135                	add	sp,sp,-160
    80004d0c:	ed06                	sd	ra,152(sp)
    80004d0e:	e922                	sd	s0,144(sp)
    80004d10:	e526                	sd	s1,136(sp)
    80004d12:	e14a                	sd	s2,128(sp)
    80004d14:	1100                	add	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004d16:	ffffc097          	auipc	ra,0xffffc
    80004d1a:	194080e7          	jalr	404(ra) # 80000eaa <myproc>
    80004d1e:	892a                	mv	s2,a0
  
  begin_op();
    80004d20:	ffffe097          	auipc	ra,0xffffe
    80004d24:	7be080e7          	jalr	1982(ra) # 800034de <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004d28:	08000613          	li	a2,128
    80004d2c:	f6040593          	add	a1,s0,-160
    80004d30:	4501                	li	a0,0
    80004d32:	ffffd097          	auipc	ra,0xffffd
    80004d36:	2d6080e7          	jalr	726(ra) # 80002008 <argstr>
    80004d3a:	04054b63          	bltz	a0,80004d90 <sys_chdir+0x86>
    80004d3e:	f6040513          	add	a0,s0,-160
    80004d42:	ffffe097          	auipc	ra,0xffffe
    80004d46:	59c080e7          	jalr	1436(ra) # 800032de <namei>
    80004d4a:	84aa                	mv	s1,a0
    80004d4c:	c131                	beqz	a0,80004d90 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004d4e:	ffffe097          	auipc	ra,0xffffe
    80004d52:	dea080e7          	jalr	-534(ra) # 80002b38 <ilock>
  if(ip->type != T_DIR){
    80004d56:	04449703          	lh	a4,68(s1)
    80004d5a:	4785                	li	a5,1
    80004d5c:	04f71063          	bne	a4,a5,80004d9c <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004d60:	8526                	mv	a0,s1
    80004d62:	ffffe097          	auipc	ra,0xffffe
    80004d66:	e98080e7          	jalr	-360(ra) # 80002bfa <iunlock>
  iput(p->cwd);
    80004d6a:	15093503          	ld	a0,336(s2)
    80004d6e:	ffffe097          	auipc	ra,0xffffe
    80004d72:	f84080e7          	jalr	-124(ra) # 80002cf2 <iput>
  end_op();
    80004d76:	ffffe097          	auipc	ra,0xffffe
    80004d7a:	7e2080e7          	jalr	2018(ra) # 80003558 <end_op>
  p->cwd = ip;
    80004d7e:	14993823          	sd	s1,336(s2)
  return 0;
    80004d82:	4501                	li	a0,0
}
    80004d84:	60ea                	ld	ra,152(sp)
    80004d86:	644a                	ld	s0,144(sp)
    80004d88:	64aa                	ld	s1,136(sp)
    80004d8a:	690a                	ld	s2,128(sp)
    80004d8c:	610d                	add	sp,sp,160
    80004d8e:	8082                	ret
    end_op();
    80004d90:	ffffe097          	auipc	ra,0xffffe
    80004d94:	7c8080e7          	jalr	1992(ra) # 80003558 <end_op>
    return -1;
    80004d98:	557d                	li	a0,-1
    80004d9a:	b7ed                	j	80004d84 <sys_chdir+0x7a>
    iunlockput(ip);
    80004d9c:	8526                	mv	a0,s1
    80004d9e:	ffffe097          	auipc	ra,0xffffe
    80004da2:	ffc080e7          	jalr	-4(ra) # 80002d9a <iunlockput>
    end_op();
    80004da6:	ffffe097          	auipc	ra,0xffffe
    80004daa:	7b2080e7          	jalr	1970(ra) # 80003558 <end_op>
    return -1;
    80004dae:	557d                	li	a0,-1
    80004db0:	bfd1                	j	80004d84 <sys_chdir+0x7a>

0000000080004db2 <sys_exec>:

uint64
sys_exec(void)
{
    80004db2:	7121                	add	sp,sp,-448
    80004db4:	ff06                	sd	ra,440(sp)
    80004db6:	fb22                	sd	s0,432(sp)
    80004db8:	f726                	sd	s1,424(sp)
    80004dba:	f34a                	sd	s2,416(sp)
    80004dbc:	ef4e                	sd	s3,408(sp)
    80004dbe:	eb52                	sd	s4,400(sp)
    80004dc0:	0380                	add	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004dc2:	e4840593          	add	a1,s0,-440
    80004dc6:	4505                	li	a0,1
    80004dc8:	ffffd097          	auipc	ra,0xffffd
    80004dcc:	220080e7          	jalr	544(ra) # 80001fe8 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004dd0:	08000613          	li	a2,128
    80004dd4:	f5040593          	add	a1,s0,-176
    80004dd8:	4501                	li	a0,0
    80004dda:	ffffd097          	auipc	ra,0xffffd
    80004dde:	22e080e7          	jalr	558(ra) # 80002008 <argstr>
    80004de2:	87aa                	mv	a5,a0
    return -1;
    80004de4:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004de6:	0c07c263          	bltz	a5,80004eaa <sys_exec+0xf8>
  }
  memset(argv, 0, sizeof(argv));
    80004dea:	10000613          	li	a2,256
    80004dee:	4581                	li	a1,0
    80004df0:	e5040513          	add	a0,s0,-432
    80004df4:	ffffb097          	auipc	ra,0xffffb
    80004df8:	386080e7          	jalr	902(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004dfc:	e5040493          	add	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80004e00:	89a6                	mv	s3,s1
    80004e02:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004e04:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004e08:	00391513          	sll	a0,s2,0x3
    80004e0c:	e4040593          	add	a1,s0,-448
    80004e10:	e4843783          	ld	a5,-440(s0)
    80004e14:	953e                	add	a0,a0,a5
    80004e16:	ffffd097          	auipc	ra,0xffffd
    80004e1a:	114080e7          	jalr	276(ra) # 80001f2a <fetchaddr>
    80004e1e:	02054a63          	bltz	a0,80004e52 <sys_exec+0xa0>
      goto bad;
    }
    if(uarg == 0){
    80004e22:	e4043783          	ld	a5,-448(s0)
    80004e26:	c3b9                	beqz	a5,80004e6c <sys_exec+0xba>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004e28:	ffffb097          	auipc	ra,0xffffb
    80004e2c:	2f2080e7          	jalr	754(ra) # 8000011a <kalloc>
    80004e30:	85aa                	mv	a1,a0
    80004e32:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004e36:	cd11                	beqz	a0,80004e52 <sys_exec+0xa0>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004e38:	6605                	lui	a2,0x1
    80004e3a:	e4043503          	ld	a0,-448(s0)
    80004e3e:	ffffd097          	auipc	ra,0xffffd
    80004e42:	13e080e7          	jalr	318(ra) # 80001f7c <fetchstr>
    80004e46:	00054663          	bltz	a0,80004e52 <sys_exec+0xa0>
    if(i >= NELEM(argv)){
    80004e4a:	0905                	add	s2,s2,1
    80004e4c:	09a1                	add	s3,s3,8
    80004e4e:	fb491de3          	bne	s2,s4,80004e08 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e52:	f5040913          	add	s2,s0,-176
    80004e56:	6088                	ld	a0,0(s1)
    80004e58:	c921                	beqz	a0,80004ea8 <sys_exec+0xf6>
    kfree(argv[i]);
    80004e5a:	ffffb097          	auipc	ra,0xffffb
    80004e5e:	1c2080e7          	jalr	450(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e62:	04a1                	add	s1,s1,8
    80004e64:	ff2499e3          	bne	s1,s2,80004e56 <sys_exec+0xa4>
  return -1;
    80004e68:	557d                	li	a0,-1
    80004e6a:	a081                	j	80004eaa <sys_exec+0xf8>
      argv[i] = 0;
    80004e6c:	0009079b          	sext.w	a5,s2
    80004e70:	078e                	sll	a5,a5,0x3
    80004e72:	fd078793          	add	a5,a5,-48
    80004e76:	97a2                	add	a5,a5,s0
    80004e78:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80004e7c:	e5040593          	add	a1,s0,-432
    80004e80:	f5040513          	add	a0,s0,-176
    80004e84:	fffff097          	auipc	ra,0xfffff
    80004e88:	194080e7          	jalr	404(ra) # 80004018 <exec>
    80004e8c:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e8e:	f5040993          	add	s3,s0,-176
    80004e92:	6088                	ld	a0,0(s1)
    80004e94:	c901                	beqz	a0,80004ea4 <sys_exec+0xf2>
    kfree(argv[i]);
    80004e96:	ffffb097          	auipc	ra,0xffffb
    80004e9a:	186080e7          	jalr	390(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e9e:	04a1                	add	s1,s1,8
    80004ea0:	ff3499e3          	bne	s1,s3,80004e92 <sys_exec+0xe0>
  return ret;
    80004ea4:	854a                	mv	a0,s2
    80004ea6:	a011                	j	80004eaa <sys_exec+0xf8>
  return -1;
    80004ea8:	557d                	li	a0,-1
}
    80004eaa:	70fa                	ld	ra,440(sp)
    80004eac:	745a                	ld	s0,432(sp)
    80004eae:	74ba                	ld	s1,424(sp)
    80004eb0:	791a                	ld	s2,416(sp)
    80004eb2:	69fa                	ld	s3,408(sp)
    80004eb4:	6a5a                	ld	s4,400(sp)
    80004eb6:	6139                	add	sp,sp,448
    80004eb8:	8082                	ret

0000000080004eba <sys_pipe>:

uint64
sys_pipe(void)
{
    80004eba:	7139                	add	sp,sp,-64
    80004ebc:	fc06                	sd	ra,56(sp)
    80004ebe:	f822                	sd	s0,48(sp)
    80004ec0:	f426                	sd	s1,40(sp)
    80004ec2:	0080                	add	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004ec4:	ffffc097          	auipc	ra,0xffffc
    80004ec8:	fe6080e7          	jalr	-26(ra) # 80000eaa <myproc>
    80004ecc:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80004ece:	fd840593          	add	a1,s0,-40
    80004ed2:	4501                	li	a0,0
    80004ed4:	ffffd097          	auipc	ra,0xffffd
    80004ed8:	114080e7          	jalr	276(ra) # 80001fe8 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004edc:	fc840593          	add	a1,s0,-56
    80004ee0:	fd040513          	add	a0,s0,-48
    80004ee4:	fffff097          	auipc	ra,0xfffff
    80004ee8:	dea080e7          	jalr	-534(ra) # 80003cce <pipealloc>
    return -1;
    80004eec:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004eee:	0c054463          	bltz	a0,80004fb6 <sys_pipe+0xfc>
  fd0 = -1;
    80004ef2:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004ef6:	fd043503          	ld	a0,-48(s0)
    80004efa:	fffff097          	auipc	ra,0xfffff
    80004efe:	524080e7          	jalr	1316(ra) # 8000441e <fdalloc>
    80004f02:	fca42223          	sw	a0,-60(s0)
    80004f06:	08054b63          	bltz	a0,80004f9c <sys_pipe+0xe2>
    80004f0a:	fc843503          	ld	a0,-56(s0)
    80004f0e:	fffff097          	auipc	ra,0xfffff
    80004f12:	510080e7          	jalr	1296(ra) # 8000441e <fdalloc>
    80004f16:	fca42023          	sw	a0,-64(s0)
    80004f1a:	06054863          	bltz	a0,80004f8a <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004f1e:	4691                	li	a3,4
    80004f20:	fc440613          	add	a2,s0,-60
    80004f24:	fd843583          	ld	a1,-40(s0)
    80004f28:	68a8                	ld	a0,80(s1)
    80004f2a:	ffffc097          	auipc	ra,0xffffc
    80004f2e:	c0c080e7          	jalr	-1012(ra) # 80000b36 <copyout>
    80004f32:	02054063          	bltz	a0,80004f52 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004f36:	4691                	li	a3,4
    80004f38:	fc040613          	add	a2,s0,-64
    80004f3c:	fd843583          	ld	a1,-40(s0)
    80004f40:	0591                	add	a1,a1,4
    80004f42:	68a8                	ld	a0,80(s1)
    80004f44:	ffffc097          	auipc	ra,0xffffc
    80004f48:	bf2080e7          	jalr	-1038(ra) # 80000b36 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004f4c:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004f4e:	06055463          	bgez	a0,80004fb6 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80004f52:	fc442783          	lw	a5,-60(s0)
    80004f56:	07e9                	add	a5,a5,26
    80004f58:	078e                	sll	a5,a5,0x3
    80004f5a:	97a6                	add	a5,a5,s1
    80004f5c:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004f60:	fc042783          	lw	a5,-64(s0)
    80004f64:	07e9                	add	a5,a5,26
    80004f66:	078e                	sll	a5,a5,0x3
    80004f68:	94be                	add	s1,s1,a5
    80004f6a:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80004f6e:	fd043503          	ld	a0,-48(s0)
    80004f72:	fffff097          	auipc	ra,0xfffff
    80004f76:	a30080e7          	jalr	-1488(ra) # 800039a2 <fileclose>
    fileclose(wf);
    80004f7a:	fc843503          	ld	a0,-56(s0)
    80004f7e:	fffff097          	auipc	ra,0xfffff
    80004f82:	a24080e7          	jalr	-1500(ra) # 800039a2 <fileclose>
    return -1;
    80004f86:	57fd                	li	a5,-1
    80004f88:	a03d                	j	80004fb6 <sys_pipe+0xfc>
    if(fd0 >= 0)
    80004f8a:	fc442783          	lw	a5,-60(s0)
    80004f8e:	0007c763          	bltz	a5,80004f9c <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80004f92:	07e9                	add	a5,a5,26
    80004f94:	078e                	sll	a5,a5,0x3
    80004f96:	97a6                	add	a5,a5,s1
    80004f98:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80004f9c:	fd043503          	ld	a0,-48(s0)
    80004fa0:	fffff097          	auipc	ra,0xfffff
    80004fa4:	a02080e7          	jalr	-1534(ra) # 800039a2 <fileclose>
    fileclose(wf);
    80004fa8:	fc843503          	ld	a0,-56(s0)
    80004fac:	fffff097          	auipc	ra,0xfffff
    80004fb0:	9f6080e7          	jalr	-1546(ra) # 800039a2 <fileclose>
    return -1;
    80004fb4:	57fd                	li	a5,-1
}
    80004fb6:	853e                	mv	a0,a5
    80004fb8:	70e2                	ld	ra,56(sp)
    80004fba:	7442                	ld	s0,48(sp)
    80004fbc:	74a2                	ld	s1,40(sp)
    80004fbe:	6121                	add	sp,sp,64
    80004fc0:	8082                	ret
	...

0000000080004fd0 <kernelvec>:
    80004fd0:	7111                	add	sp,sp,-256
    80004fd2:	e006                	sd	ra,0(sp)
    80004fd4:	e40a                	sd	sp,8(sp)
    80004fd6:	e80e                	sd	gp,16(sp)
    80004fd8:	ec12                	sd	tp,24(sp)
    80004fda:	f016                	sd	t0,32(sp)
    80004fdc:	f41a                	sd	t1,40(sp)
    80004fde:	f81e                	sd	t2,48(sp)
    80004fe0:	fc22                	sd	s0,56(sp)
    80004fe2:	e0a6                	sd	s1,64(sp)
    80004fe4:	e4aa                	sd	a0,72(sp)
    80004fe6:	e8ae                	sd	a1,80(sp)
    80004fe8:	ecb2                	sd	a2,88(sp)
    80004fea:	f0b6                	sd	a3,96(sp)
    80004fec:	f4ba                	sd	a4,104(sp)
    80004fee:	f8be                	sd	a5,112(sp)
    80004ff0:	fcc2                	sd	a6,120(sp)
    80004ff2:	e146                	sd	a7,128(sp)
    80004ff4:	e54a                	sd	s2,136(sp)
    80004ff6:	e94e                	sd	s3,144(sp)
    80004ff8:	ed52                	sd	s4,152(sp)
    80004ffa:	f156                	sd	s5,160(sp)
    80004ffc:	f55a                	sd	s6,168(sp)
    80004ffe:	f95e                	sd	s7,176(sp)
    80005000:	fd62                	sd	s8,184(sp)
    80005002:	e1e6                	sd	s9,192(sp)
    80005004:	e5ea                	sd	s10,200(sp)
    80005006:	e9ee                	sd	s11,208(sp)
    80005008:	edf2                	sd	t3,216(sp)
    8000500a:	f1f6                	sd	t4,224(sp)
    8000500c:	f5fa                	sd	t5,232(sp)
    8000500e:	f9fe                	sd	t6,240(sp)
    80005010:	de7fc0ef          	jal	80001df6 <kerneltrap>
    80005014:	6082                	ld	ra,0(sp)
    80005016:	6122                	ld	sp,8(sp)
    80005018:	61c2                	ld	gp,16(sp)
    8000501a:	7282                	ld	t0,32(sp)
    8000501c:	7322                	ld	t1,40(sp)
    8000501e:	73c2                	ld	t2,48(sp)
    80005020:	7462                	ld	s0,56(sp)
    80005022:	6486                	ld	s1,64(sp)
    80005024:	6526                	ld	a0,72(sp)
    80005026:	65c6                	ld	a1,80(sp)
    80005028:	6666                	ld	a2,88(sp)
    8000502a:	7686                	ld	a3,96(sp)
    8000502c:	7726                	ld	a4,104(sp)
    8000502e:	77c6                	ld	a5,112(sp)
    80005030:	7866                	ld	a6,120(sp)
    80005032:	688a                	ld	a7,128(sp)
    80005034:	692a                	ld	s2,136(sp)
    80005036:	69ca                	ld	s3,144(sp)
    80005038:	6a6a                	ld	s4,152(sp)
    8000503a:	7a8a                	ld	s5,160(sp)
    8000503c:	7b2a                	ld	s6,168(sp)
    8000503e:	7bca                	ld	s7,176(sp)
    80005040:	7c6a                	ld	s8,184(sp)
    80005042:	6c8e                	ld	s9,192(sp)
    80005044:	6d2e                	ld	s10,200(sp)
    80005046:	6dce                	ld	s11,208(sp)
    80005048:	6e6e                	ld	t3,216(sp)
    8000504a:	7e8e                	ld	t4,224(sp)
    8000504c:	7f2e                	ld	t5,232(sp)
    8000504e:	7fce                	ld	t6,240(sp)
    80005050:	6111                	add	sp,sp,256
    80005052:	10200073          	sret
    80005056:	00000013          	nop
    8000505a:	00000013          	nop
    8000505e:	0001                	nop

0000000080005060 <timervec>:
    80005060:	34051573          	csrrw	a0,mscratch,a0
    80005064:	e10c                	sd	a1,0(a0)
    80005066:	e510                	sd	a2,8(a0)
    80005068:	e914                	sd	a3,16(a0)
    8000506a:	6d0c                	ld	a1,24(a0)
    8000506c:	7110                	ld	a2,32(a0)
    8000506e:	6194                	ld	a3,0(a1)
    80005070:	96b2                	add	a3,a3,a2
    80005072:	e194                	sd	a3,0(a1)
    80005074:	4589                	li	a1,2
    80005076:	14459073          	csrw	sip,a1
    8000507a:	6914                	ld	a3,16(a0)
    8000507c:	6510                	ld	a2,8(a0)
    8000507e:	610c                	ld	a1,0(a0)
    80005080:	34051573          	csrrw	a0,mscratch,a0
    80005084:	30200073          	mret
	...

000000008000508a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000508a:	1141                	add	sp,sp,-16
    8000508c:	e422                	sd	s0,8(sp)
    8000508e:	0800                	add	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005090:	0c0007b7          	lui	a5,0xc000
    80005094:	4705                	li	a4,1
    80005096:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005098:	c3d8                	sw	a4,4(a5)
}
    8000509a:	6422                	ld	s0,8(sp)
    8000509c:	0141                	add	sp,sp,16
    8000509e:	8082                	ret

00000000800050a0 <plicinithart>:

void
plicinithart(void)
{
    800050a0:	1141                	add	sp,sp,-16
    800050a2:	e406                	sd	ra,8(sp)
    800050a4:	e022                	sd	s0,0(sp)
    800050a6:	0800                	add	s0,sp,16
  int hart = cpuid();
    800050a8:	ffffc097          	auipc	ra,0xffffc
    800050ac:	dd6080e7          	jalr	-554(ra) # 80000e7e <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800050b0:	0085171b          	sllw	a4,a0,0x8
    800050b4:	0c0027b7          	lui	a5,0xc002
    800050b8:	97ba                	add	a5,a5,a4
    800050ba:	40200713          	li	a4,1026
    800050be:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800050c2:	00d5151b          	sllw	a0,a0,0xd
    800050c6:	0c2017b7          	lui	a5,0xc201
    800050ca:	97aa                	add	a5,a5,a0
    800050cc:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800050d0:	60a2                	ld	ra,8(sp)
    800050d2:	6402                	ld	s0,0(sp)
    800050d4:	0141                	add	sp,sp,16
    800050d6:	8082                	ret

00000000800050d8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800050d8:	1141                	add	sp,sp,-16
    800050da:	e406                	sd	ra,8(sp)
    800050dc:	e022                	sd	s0,0(sp)
    800050de:	0800                	add	s0,sp,16
  int hart = cpuid();
    800050e0:	ffffc097          	auipc	ra,0xffffc
    800050e4:	d9e080e7          	jalr	-610(ra) # 80000e7e <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800050e8:	00d5151b          	sllw	a0,a0,0xd
    800050ec:	0c2017b7          	lui	a5,0xc201
    800050f0:	97aa                	add	a5,a5,a0
  return irq;
}
    800050f2:	43c8                	lw	a0,4(a5)
    800050f4:	60a2                	ld	ra,8(sp)
    800050f6:	6402                	ld	s0,0(sp)
    800050f8:	0141                	add	sp,sp,16
    800050fa:	8082                	ret

00000000800050fc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800050fc:	1101                	add	sp,sp,-32
    800050fe:	ec06                	sd	ra,24(sp)
    80005100:	e822                	sd	s0,16(sp)
    80005102:	e426                	sd	s1,8(sp)
    80005104:	1000                	add	s0,sp,32
    80005106:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005108:	ffffc097          	auipc	ra,0xffffc
    8000510c:	d76080e7          	jalr	-650(ra) # 80000e7e <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005110:	00d5151b          	sllw	a0,a0,0xd
    80005114:	0c2017b7          	lui	a5,0xc201
    80005118:	97aa                	add	a5,a5,a0
    8000511a:	c3c4                	sw	s1,4(a5)
}
    8000511c:	60e2                	ld	ra,24(sp)
    8000511e:	6442                	ld	s0,16(sp)
    80005120:	64a2                	ld	s1,8(sp)
    80005122:	6105                	add	sp,sp,32
    80005124:	8082                	ret

0000000080005126 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005126:	1141                	add	sp,sp,-16
    80005128:	e406                	sd	ra,8(sp)
    8000512a:	e022                	sd	s0,0(sp)
    8000512c:	0800                	add	s0,sp,16
  if(i >= NUM)
    8000512e:	479d                	li	a5,7
    80005130:	04a7cc63          	blt	a5,a0,80005188 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005134:	00015797          	auipc	a5,0x15
    80005138:	8bc78793          	add	a5,a5,-1860 # 800199f0 <disk>
    8000513c:	97aa                	add	a5,a5,a0
    8000513e:	0187c783          	lbu	a5,24(a5)
    80005142:	ebb9                	bnez	a5,80005198 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005144:	00451693          	sll	a3,a0,0x4
    80005148:	00015797          	auipc	a5,0x15
    8000514c:	8a878793          	add	a5,a5,-1880 # 800199f0 <disk>
    80005150:	6398                	ld	a4,0(a5)
    80005152:	9736                	add	a4,a4,a3
    80005154:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005158:	6398                	ld	a4,0(a5)
    8000515a:	9736                	add	a4,a4,a3
    8000515c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005160:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005164:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005168:	97aa                	add	a5,a5,a0
    8000516a:	4705                	li	a4,1
    8000516c:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005170:	00015517          	auipc	a0,0x15
    80005174:	89850513          	add	a0,a0,-1896 # 80019a08 <disk+0x18>
    80005178:	ffffc097          	auipc	ra,0xffffc
    8000517c:	442080e7          	jalr	1090(ra) # 800015ba <wakeup>
}
    80005180:	60a2                	ld	ra,8(sp)
    80005182:	6402                	ld	s0,0(sp)
    80005184:	0141                	add	sp,sp,16
    80005186:	8082                	ret
    panic("free_desc 1");
    80005188:	00003517          	auipc	a0,0x3
    8000518c:	57850513          	add	a0,a0,1400 # 80008700 <syscalls+0x2f0>
    80005190:	00001097          	auipc	ra,0x1
    80005194:	a06080e7          	jalr	-1530(ra) # 80005b96 <panic>
    panic("free_desc 2");
    80005198:	00003517          	auipc	a0,0x3
    8000519c:	57850513          	add	a0,a0,1400 # 80008710 <syscalls+0x300>
    800051a0:	00001097          	auipc	ra,0x1
    800051a4:	9f6080e7          	jalr	-1546(ra) # 80005b96 <panic>

00000000800051a8 <virtio_disk_init>:
{
    800051a8:	1101                	add	sp,sp,-32
    800051aa:	ec06                	sd	ra,24(sp)
    800051ac:	e822                	sd	s0,16(sp)
    800051ae:	e426                	sd	s1,8(sp)
    800051b0:	e04a                	sd	s2,0(sp)
    800051b2:	1000                	add	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800051b4:	00003597          	auipc	a1,0x3
    800051b8:	56c58593          	add	a1,a1,1388 # 80008720 <syscalls+0x310>
    800051bc:	00015517          	auipc	a0,0x15
    800051c0:	95c50513          	add	a0,a0,-1700 # 80019b18 <disk+0x128>
    800051c4:	00001097          	auipc	ra,0x1
    800051c8:	e7a080e7          	jalr	-390(ra) # 8000603e <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800051cc:	100017b7          	lui	a5,0x10001
    800051d0:	4398                	lw	a4,0(a5)
    800051d2:	2701                	sext.w	a4,a4
    800051d4:	747277b7          	lui	a5,0x74727
    800051d8:	97678793          	add	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800051dc:	14f71b63          	bne	a4,a5,80005332 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800051e0:	100017b7          	lui	a5,0x10001
    800051e4:	43dc                	lw	a5,4(a5)
    800051e6:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800051e8:	4709                	li	a4,2
    800051ea:	14e79463          	bne	a5,a4,80005332 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800051ee:	100017b7          	lui	a5,0x10001
    800051f2:	479c                	lw	a5,8(a5)
    800051f4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800051f6:	12e79e63          	bne	a5,a4,80005332 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800051fa:	100017b7          	lui	a5,0x10001
    800051fe:	47d8                	lw	a4,12(a5)
    80005200:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005202:	554d47b7          	lui	a5,0x554d4
    80005206:	55178793          	add	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000520a:	12f71463          	bne	a4,a5,80005332 <virtio_disk_init+0x18a>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000520e:	100017b7          	lui	a5,0x10001
    80005212:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005216:	4705                	li	a4,1
    80005218:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000521a:	470d                	li	a4,3
    8000521c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000521e:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005220:	c7ffe6b7          	lui	a3,0xc7ffe
    80005224:	75f68693          	add	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc9ef>
    80005228:	8f75                	and	a4,a4,a3
    8000522a:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000522c:	472d                	li	a4,11
    8000522e:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005230:	5bbc                	lw	a5,112(a5)
    80005232:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005236:	8ba1                	and	a5,a5,8
    80005238:	10078563          	beqz	a5,80005342 <virtio_disk_init+0x19a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000523c:	100017b7          	lui	a5,0x10001
    80005240:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005244:	43fc                	lw	a5,68(a5)
    80005246:	2781                	sext.w	a5,a5
    80005248:	10079563          	bnez	a5,80005352 <virtio_disk_init+0x1aa>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000524c:	100017b7          	lui	a5,0x10001
    80005250:	5bdc                	lw	a5,52(a5)
    80005252:	2781                	sext.w	a5,a5
  if(max == 0)
    80005254:	10078763          	beqz	a5,80005362 <virtio_disk_init+0x1ba>
  if(max < NUM)
    80005258:	471d                	li	a4,7
    8000525a:	10f77c63          	bgeu	a4,a5,80005372 <virtio_disk_init+0x1ca>
  disk.desc = kalloc();
    8000525e:	ffffb097          	auipc	ra,0xffffb
    80005262:	ebc080e7          	jalr	-324(ra) # 8000011a <kalloc>
    80005266:	00014497          	auipc	s1,0x14
    8000526a:	78a48493          	add	s1,s1,1930 # 800199f0 <disk>
    8000526e:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005270:	ffffb097          	auipc	ra,0xffffb
    80005274:	eaa080e7          	jalr	-342(ra) # 8000011a <kalloc>
    80005278:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000527a:	ffffb097          	auipc	ra,0xffffb
    8000527e:	ea0080e7          	jalr	-352(ra) # 8000011a <kalloc>
    80005282:	87aa                	mv	a5,a0
    80005284:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005286:	6088                	ld	a0,0(s1)
    80005288:	cd6d                	beqz	a0,80005382 <virtio_disk_init+0x1da>
    8000528a:	00014717          	auipc	a4,0x14
    8000528e:	76e73703          	ld	a4,1902(a4) # 800199f8 <disk+0x8>
    80005292:	cb65                	beqz	a4,80005382 <virtio_disk_init+0x1da>
    80005294:	c7fd                	beqz	a5,80005382 <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    80005296:	6605                	lui	a2,0x1
    80005298:	4581                	li	a1,0
    8000529a:	ffffb097          	auipc	ra,0xffffb
    8000529e:	ee0080e7          	jalr	-288(ra) # 8000017a <memset>
  memset(disk.avail, 0, PGSIZE);
    800052a2:	00014497          	auipc	s1,0x14
    800052a6:	74e48493          	add	s1,s1,1870 # 800199f0 <disk>
    800052aa:	6605                	lui	a2,0x1
    800052ac:	4581                	li	a1,0
    800052ae:	6488                	ld	a0,8(s1)
    800052b0:	ffffb097          	auipc	ra,0xffffb
    800052b4:	eca080e7          	jalr	-310(ra) # 8000017a <memset>
  memset(disk.used, 0, PGSIZE);
    800052b8:	6605                	lui	a2,0x1
    800052ba:	4581                	li	a1,0
    800052bc:	6888                	ld	a0,16(s1)
    800052be:	ffffb097          	auipc	ra,0xffffb
    800052c2:	ebc080e7          	jalr	-324(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800052c6:	100017b7          	lui	a5,0x10001
    800052ca:	4721                	li	a4,8
    800052cc:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800052ce:	4098                	lw	a4,0(s1)
    800052d0:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800052d4:	40d8                	lw	a4,4(s1)
    800052d6:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800052da:	6498                	ld	a4,8(s1)
    800052dc:	0007069b          	sext.w	a3,a4
    800052e0:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800052e4:	9701                	sra	a4,a4,0x20
    800052e6:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800052ea:	6898                	ld	a4,16(s1)
    800052ec:	0007069b          	sext.w	a3,a4
    800052f0:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800052f4:	9701                	sra	a4,a4,0x20
    800052f6:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800052fa:	4705                	li	a4,1
    800052fc:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    800052fe:	00e48c23          	sb	a4,24(s1)
    80005302:	00e48ca3          	sb	a4,25(s1)
    80005306:	00e48d23          	sb	a4,26(s1)
    8000530a:	00e48da3          	sb	a4,27(s1)
    8000530e:	00e48e23          	sb	a4,28(s1)
    80005312:	00e48ea3          	sb	a4,29(s1)
    80005316:	00e48f23          	sb	a4,30(s1)
    8000531a:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    8000531e:	00496913          	or	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005322:	0727a823          	sw	s2,112(a5)
}
    80005326:	60e2                	ld	ra,24(sp)
    80005328:	6442                	ld	s0,16(sp)
    8000532a:	64a2                	ld	s1,8(sp)
    8000532c:	6902                	ld	s2,0(sp)
    8000532e:	6105                	add	sp,sp,32
    80005330:	8082                	ret
    panic("could not find virtio disk");
    80005332:	00003517          	auipc	a0,0x3
    80005336:	3fe50513          	add	a0,a0,1022 # 80008730 <syscalls+0x320>
    8000533a:	00001097          	auipc	ra,0x1
    8000533e:	85c080e7          	jalr	-1956(ra) # 80005b96 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005342:	00003517          	auipc	a0,0x3
    80005346:	40e50513          	add	a0,a0,1038 # 80008750 <syscalls+0x340>
    8000534a:	00001097          	auipc	ra,0x1
    8000534e:	84c080e7          	jalr	-1972(ra) # 80005b96 <panic>
    panic("virtio disk should not be ready");
    80005352:	00003517          	auipc	a0,0x3
    80005356:	41e50513          	add	a0,a0,1054 # 80008770 <syscalls+0x360>
    8000535a:	00001097          	auipc	ra,0x1
    8000535e:	83c080e7          	jalr	-1988(ra) # 80005b96 <panic>
    panic("virtio disk has no queue 0");
    80005362:	00003517          	auipc	a0,0x3
    80005366:	42e50513          	add	a0,a0,1070 # 80008790 <syscalls+0x380>
    8000536a:	00001097          	auipc	ra,0x1
    8000536e:	82c080e7          	jalr	-2004(ra) # 80005b96 <panic>
    panic("virtio disk max queue too short");
    80005372:	00003517          	auipc	a0,0x3
    80005376:	43e50513          	add	a0,a0,1086 # 800087b0 <syscalls+0x3a0>
    8000537a:	00001097          	auipc	ra,0x1
    8000537e:	81c080e7          	jalr	-2020(ra) # 80005b96 <panic>
    panic("virtio disk kalloc");
    80005382:	00003517          	auipc	a0,0x3
    80005386:	44e50513          	add	a0,a0,1102 # 800087d0 <syscalls+0x3c0>
    8000538a:	00001097          	auipc	ra,0x1
    8000538e:	80c080e7          	jalr	-2036(ra) # 80005b96 <panic>

0000000080005392 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005392:	7159                	add	sp,sp,-112
    80005394:	f486                	sd	ra,104(sp)
    80005396:	f0a2                	sd	s0,96(sp)
    80005398:	eca6                	sd	s1,88(sp)
    8000539a:	e8ca                	sd	s2,80(sp)
    8000539c:	e4ce                	sd	s3,72(sp)
    8000539e:	e0d2                	sd	s4,64(sp)
    800053a0:	fc56                	sd	s5,56(sp)
    800053a2:	f85a                	sd	s6,48(sp)
    800053a4:	f45e                	sd	s7,40(sp)
    800053a6:	f062                	sd	s8,32(sp)
    800053a8:	ec66                	sd	s9,24(sp)
    800053aa:	e86a                	sd	s10,16(sp)
    800053ac:	1880                	add	s0,sp,112
    800053ae:	8a2a                	mv	s4,a0
    800053b0:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800053b2:	00c52c83          	lw	s9,12(a0)
    800053b6:	001c9c9b          	sllw	s9,s9,0x1
    800053ba:	1c82                	sll	s9,s9,0x20
    800053bc:	020cdc93          	srl	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800053c0:	00014517          	auipc	a0,0x14
    800053c4:	75850513          	add	a0,a0,1880 # 80019b18 <disk+0x128>
    800053c8:	00001097          	auipc	ra,0x1
    800053cc:	d06080e7          	jalr	-762(ra) # 800060ce <acquire>
  for(int i = 0; i < 3; i++){
    800053d0:	4901                	li	s2,0
  for(int i = 0; i < NUM; i++){
    800053d2:	44a1                	li	s1,8
      disk.free[i] = 0;
    800053d4:	00014b17          	auipc	s6,0x14
    800053d8:	61cb0b13          	add	s6,s6,1564 # 800199f0 <disk>
  for(int i = 0; i < 3; i++){
    800053dc:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800053de:	00014c17          	auipc	s8,0x14
    800053e2:	73ac0c13          	add	s8,s8,1850 # 80019b18 <disk+0x128>
    800053e6:	a095                	j	8000544a <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    800053e8:	00fb0733          	add	a4,s6,a5
    800053ec:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800053f0:	c11c                	sw	a5,0(a0)
    if(idx[i] < 0){
    800053f2:	0207c563          	bltz	a5,8000541c <virtio_disk_rw+0x8a>
  for(int i = 0; i < 3; i++){
    800053f6:	2605                	addw	a2,a2,1 # 1001 <_entry-0x7fffefff>
    800053f8:	0591                	add	a1,a1,4
    800053fa:	05560d63          	beq	a2,s5,80005454 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    800053fe:	852e                	mv	a0,a1
  for(int i = 0; i < NUM; i++){
    80005400:	00014717          	auipc	a4,0x14
    80005404:	5f070713          	add	a4,a4,1520 # 800199f0 <disk>
    80005408:	87ca                	mv	a5,s2
    if(disk.free[i]){
    8000540a:	01874683          	lbu	a3,24(a4)
    8000540e:	fee9                	bnez	a3,800053e8 <virtio_disk_rw+0x56>
  for(int i = 0; i < NUM; i++){
    80005410:	2785                	addw	a5,a5,1
    80005412:	0705                	add	a4,a4,1
    80005414:	fe979be3          	bne	a5,s1,8000540a <virtio_disk_rw+0x78>
    idx[i] = alloc_desc();
    80005418:	57fd                	li	a5,-1
    8000541a:	c11c                	sw	a5,0(a0)
      for(int j = 0; j < i; j++)
    8000541c:	00c05e63          	blez	a2,80005438 <virtio_disk_rw+0xa6>
    80005420:	060a                	sll	a2,a2,0x2
    80005422:	01360d33          	add	s10,a2,s3
        free_desc(idx[j]);
    80005426:	0009a503          	lw	a0,0(s3)
    8000542a:	00000097          	auipc	ra,0x0
    8000542e:	cfc080e7          	jalr	-772(ra) # 80005126 <free_desc>
      for(int j = 0; j < i; j++)
    80005432:	0991                	add	s3,s3,4
    80005434:	ffa999e3          	bne	s3,s10,80005426 <virtio_disk_rw+0x94>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005438:	85e2                	mv	a1,s8
    8000543a:	00014517          	auipc	a0,0x14
    8000543e:	5ce50513          	add	a0,a0,1486 # 80019a08 <disk+0x18>
    80005442:	ffffc097          	auipc	ra,0xffffc
    80005446:	114080e7          	jalr	276(ra) # 80001556 <sleep>
  for(int i = 0; i < 3; i++){
    8000544a:	f9040993          	add	s3,s0,-112
{
    8000544e:	85ce                	mv	a1,s3
  for(int i = 0; i < 3; i++){
    80005450:	864a                	mv	a2,s2
    80005452:	b775                	j	800053fe <virtio_disk_rw+0x6c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005454:	f9042503          	lw	a0,-112(s0)
    80005458:	00a50713          	add	a4,a0,10
    8000545c:	0712                	sll	a4,a4,0x4

  if(write)
    8000545e:	00014797          	auipc	a5,0x14
    80005462:	59278793          	add	a5,a5,1426 # 800199f0 <disk>
    80005466:	00e786b3          	add	a3,a5,a4
    8000546a:	01703633          	snez	a2,s7
    8000546e:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005470:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    80005474:	0196b823          	sd	s9,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005478:	f6070613          	add	a2,a4,-160
    8000547c:	6394                	ld	a3,0(a5)
    8000547e:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005480:	00870593          	add	a1,a4,8
    80005484:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005486:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005488:	0007b803          	ld	a6,0(a5)
    8000548c:	9642                	add	a2,a2,a6
    8000548e:	46c1                	li	a3,16
    80005490:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005492:	4585                	li	a1,1
    80005494:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    80005498:	f9442683          	lw	a3,-108(s0)
    8000549c:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    800054a0:	0692                	sll	a3,a3,0x4
    800054a2:	9836                	add	a6,a6,a3
    800054a4:	058a0613          	add	a2,s4,88
    800054a8:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    800054ac:	0007b803          	ld	a6,0(a5)
    800054b0:	96c2                	add	a3,a3,a6
    800054b2:	40000613          	li	a2,1024
    800054b6:	c690                	sw	a2,8(a3)
  if(write)
    800054b8:	001bb613          	seqz	a2,s7
    800054bc:	0016161b          	sllw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800054c0:	00166613          	or	a2,a2,1
    800054c4:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800054c8:	f9842603          	lw	a2,-104(s0)
    800054cc:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800054d0:	00250693          	add	a3,a0,2
    800054d4:	0692                	sll	a3,a3,0x4
    800054d6:	96be                	add	a3,a3,a5
    800054d8:	58fd                	li	a7,-1
    800054da:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800054de:	0612                	sll	a2,a2,0x4
    800054e0:	9832                	add	a6,a6,a2
    800054e2:	f9070713          	add	a4,a4,-112
    800054e6:	973e                	add	a4,a4,a5
    800054e8:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    800054ec:	6398                	ld	a4,0(a5)
    800054ee:	9732                	add	a4,a4,a2
    800054f0:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800054f2:	4609                	li	a2,2
    800054f4:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    800054f8:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800054fc:	00ba2223          	sw	a1,4(s4)
  disk.info[idx[0]].b = b;
    80005500:	0146b423          	sd	s4,8(a3)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005504:	6794                	ld	a3,8(a5)
    80005506:	0026d703          	lhu	a4,2(a3)
    8000550a:	8b1d                	and	a4,a4,7
    8000550c:	0706                	sll	a4,a4,0x1
    8000550e:	96ba                	add	a3,a3,a4
    80005510:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005514:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005518:	6798                	ld	a4,8(a5)
    8000551a:	00275783          	lhu	a5,2(a4)
    8000551e:	2785                	addw	a5,a5,1
    80005520:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005524:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005528:	100017b7          	lui	a5,0x10001
    8000552c:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005530:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80005534:	00014917          	auipc	s2,0x14
    80005538:	5e490913          	add	s2,s2,1508 # 80019b18 <disk+0x128>
  while(b->disk == 1) {
    8000553c:	4485                	li	s1,1
    8000553e:	00b79c63          	bne	a5,a1,80005556 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80005542:	85ca                	mv	a1,s2
    80005544:	8552                	mv	a0,s4
    80005546:	ffffc097          	auipc	ra,0xffffc
    8000554a:	010080e7          	jalr	16(ra) # 80001556 <sleep>
  while(b->disk == 1) {
    8000554e:	004a2783          	lw	a5,4(s4)
    80005552:	fe9788e3          	beq	a5,s1,80005542 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80005556:	f9042903          	lw	s2,-112(s0)
    8000555a:	00290713          	add	a4,s2,2
    8000555e:	0712                	sll	a4,a4,0x4
    80005560:	00014797          	auipc	a5,0x14
    80005564:	49078793          	add	a5,a5,1168 # 800199f0 <disk>
    80005568:	97ba                	add	a5,a5,a4
    8000556a:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000556e:	00014997          	auipc	s3,0x14
    80005572:	48298993          	add	s3,s3,1154 # 800199f0 <disk>
    80005576:	00491713          	sll	a4,s2,0x4
    8000557a:	0009b783          	ld	a5,0(s3)
    8000557e:	97ba                	add	a5,a5,a4
    80005580:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005584:	854a                	mv	a0,s2
    80005586:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000558a:	00000097          	auipc	ra,0x0
    8000558e:	b9c080e7          	jalr	-1124(ra) # 80005126 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005592:	8885                	and	s1,s1,1
    80005594:	f0ed                	bnez	s1,80005576 <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005596:	00014517          	auipc	a0,0x14
    8000559a:	58250513          	add	a0,a0,1410 # 80019b18 <disk+0x128>
    8000559e:	00001097          	auipc	ra,0x1
    800055a2:	be4080e7          	jalr	-1052(ra) # 80006182 <release>
}
    800055a6:	70a6                	ld	ra,104(sp)
    800055a8:	7406                	ld	s0,96(sp)
    800055aa:	64e6                	ld	s1,88(sp)
    800055ac:	6946                	ld	s2,80(sp)
    800055ae:	69a6                	ld	s3,72(sp)
    800055b0:	6a06                	ld	s4,64(sp)
    800055b2:	7ae2                	ld	s5,56(sp)
    800055b4:	7b42                	ld	s6,48(sp)
    800055b6:	7ba2                	ld	s7,40(sp)
    800055b8:	7c02                	ld	s8,32(sp)
    800055ba:	6ce2                	ld	s9,24(sp)
    800055bc:	6d42                	ld	s10,16(sp)
    800055be:	6165                	add	sp,sp,112
    800055c0:	8082                	ret

00000000800055c2 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800055c2:	1101                	add	sp,sp,-32
    800055c4:	ec06                	sd	ra,24(sp)
    800055c6:	e822                	sd	s0,16(sp)
    800055c8:	e426                	sd	s1,8(sp)
    800055ca:	1000                	add	s0,sp,32
  acquire(&disk.vdisk_lock);
    800055cc:	00014497          	auipc	s1,0x14
    800055d0:	42448493          	add	s1,s1,1060 # 800199f0 <disk>
    800055d4:	00014517          	auipc	a0,0x14
    800055d8:	54450513          	add	a0,a0,1348 # 80019b18 <disk+0x128>
    800055dc:	00001097          	auipc	ra,0x1
    800055e0:	af2080e7          	jalr	-1294(ra) # 800060ce <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800055e4:	10001737          	lui	a4,0x10001
    800055e8:	533c                	lw	a5,96(a4)
    800055ea:	8b8d                	and	a5,a5,3
    800055ec:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800055ee:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800055f2:	689c                	ld	a5,16(s1)
    800055f4:	0204d703          	lhu	a4,32(s1)
    800055f8:	0027d783          	lhu	a5,2(a5)
    800055fc:	04f70863          	beq	a4,a5,8000564c <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80005600:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005604:	6898                	ld	a4,16(s1)
    80005606:	0204d783          	lhu	a5,32(s1)
    8000560a:	8b9d                	and	a5,a5,7
    8000560c:	078e                	sll	a5,a5,0x3
    8000560e:	97ba                	add	a5,a5,a4
    80005610:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005612:	00278713          	add	a4,a5,2
    80005616:	0712                	sll	a4,a4,0x4
    80005618:	9726                	add	a4,a4,s1
    8000561a:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    8000561e:	e721                	bnez	a4,80005666 <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005620:	0789                	add	a5,a5,2
    80005622:	0792                	sll	a5,a5,0x4
    80005624:	97a6                	add	a5,a5,s1
    80005626:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005628:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000562c:	ffffc097          	auipc	ra,0xffffc
    80005630:	f8e080e7          	jalr	-114(ra) # 800015ba <wakeup>

    disk.used_idx += 1;
    80005634:	0204d783          	lhu	a5,32(s1)
    80005638:	2785                	addw	a5,a5,1
    8000563a:	17c2                	sll	a5,a5,0x30
    8000563c:	93c1                	srl	a5,a5,0x30
    8000563e:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005642:	6898                	ld	a4,16(s1)
    80005644:	00275703          	lhu	a4,2(a4)
    80005648:	faf71ce3          	bne	a4,a5,80005600 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    8000564c:	00014517          	auipc	a0,0x14
    80005650:	4cc50513          	add	a0,a0,1228 # 80019b18 <disk+0x128>
    80005654:	00001097          	auipc	ra,0x1
    80005658:	b2e080e7          	jalr	-1234(ra) # 80006182 <release>
}
    8000565c:	60e2                	ld	ra,24(sp)
    8000565e:	6442                	ld	s0,16(sp)
    80005660:	64a2                	ld	s1,8(sp)
    80005662:	6105                	add	sp,sp,32
    80005664:	8082                	ret
      panic("virtio_disk_intr status");
    80005666:	00003517          	auipc	a0,0x3
    8000566a:	18250513          	add	a0,a0,386 # 800087e8 <syscalls+0x3d8>
    8000566e:	00000097          	auipc	ra,0x0
    80005672:	528080e7          	jalr	1320(ra) # 80005b96 <panic>

0000000080005676 <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005676:	1141                	add	sp,sp,-16
    80005678:	e422                	sd	s0,8(sp)
    8000567a:	0800                	add	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000567c:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005680:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005684:	0037979b          	sllw	a5,a5,0x3
    80005688:	02004737          	lui	a4,0x2004
    8000568c:	97ba                	add	a5,a5,a4
    8000568e:	0200c737          	lui	a4,0x200c
    80005692:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005696:	000f4637          	lui	a2,0xf4
    8000569a:	24060613          	add	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    8000569e:	9732                	add	a4,a4,a2
    800056a0:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800056a2:	00259693          	sll	a3,a1,0x2
    800056a6:	96ae                	add	a3,a3,a1
    800056a8:	068e                	sll	a3,a3,0x3
    800056aa:	00014717          	auipc	a4,0x14
    800056ae:	48670713          	add	a4,a4,1158 # 80019b30 <timer_scratch>
    800056b2:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800056b4:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800056b6:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800056b8:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800056bc:	00000797          	auipc	a5,0x0
    800056c0:	9a478793          	add	a5,a5,-1628 # 80005060 <timervec>
    800056c4:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800056c8:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800056cc:	0087e793          	or	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800056d0:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    800056d4:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800056d8:	0807e793          	or	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800056dc:	30479073          	csrw	mie,a5
}
    800056e0:	6422                	ld	s0,8(sp)
    800056e2:	0141                	add	sp,sp,16
    800056e4:	8082                	ret

00000000800056e6 <start>:
{
    800056e6:	1141                	add	sp,sp,-16
    800056e8:	e406                	sd	ra,8(sp)
    800056ea:	e022                	sd	s0,0(sp)
    800056ec:	0800                	add	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800056ee:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800056f2:	7779                	lui	a4,0xffffe
    800056f4:	7ff70713          	add	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdca8f>
    800056f8:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800056fa:	6705                	lui	a4,0x1
    800056fc:	80070713          	add	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005700:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005702:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005706:	ffffb797          	auipc	a5,0xffffb
    8000570a:	c1878793          	add	a5,a5,-1000 # 8000031e <main>
    8000570e:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005712:	4781                	li	a5,0
    80005714:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005718:	67c1                	lui	a5,0x10
    8000571a:	17fd                	add	a5,a5,-1 # ffff <_entry-0x7fff0001>
    8000571c:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005720:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005724:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005728:	2227e793          	or	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    8000572c:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005730:	57fd                	li	a5,-1
    80005732:	83a9                	srl	a5,a5,0xa
    80005734:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005738:	47bd                	li	a5,15
    8000573a:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    8000573e:	00000097          	auipc	ra,0x0
    80005742:	f38080e7          	jalr	-200(ra) # 80005676 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005746:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000574a:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    8000574c:	823e                	mv	tp,a5
  asm volatile("mret");
    8000574e:	30200073          	mret
}
    80005752:	60a2                	ld	ra,8(sp)
    80005754:	6402                	ld	s0,0(sp)
    80005756:	0141                	add	sp,sp,16
    80005758:	8082                	ret

000000008000575a <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000575a:	715d                	add	sp,sp,-80
    8000575c:	e486                	sd	ra,72(sp)
    8000575e:	e0a2                	sd	s0,64(sp)
    80005760:	fc26                	sd	s1,56(sp)
    80005762:	f84a                	sd	s2,48(sp)
    80005764:	f44e                	sd	s3,40(sp)
    80005766:	f052                	sd	s4,32(sp)
    80005768:	ec56                	sd	s5,24(sp)
    8000576a:	0880                	add	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000576c:	04c05763          	blez	a2,800057ba <consolewrite+0x60>
    80005770:	8a2a                	mv	s4,a0
    80005772:	84ae                	mv	s1,a1
    80005774:	89b2                	mv	s3,a2
    80005776:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005778:	5afd                	li	s5,-1
    8000577a:	4685                	li	a3,1
    8000577c:	8626                	mv	a2,s1
    8000577e:	85d2                	mv	a1,s4
    80005780:	fbf40513          	add	a0,s0,-65
    80005784:	ffffc097          	auipc	ra,0xffffc
    80005788:	230080e7          	jalr	560(ra) # 800019b4 <either_copyin>
    8000578c:	01550d63          	beq	a0,s5,800057a6 <consolewrite+0x4c>
      break;
    uartputc(c);
    80005790:	fbf44503          	lbu	a0,-65(s0)
    80005794:	00000097          	auipc	ra,0x0
    80005798:	780080e7          	jalr	1920(ra) # 80005f14 <uartputc>
  for(i = 0; i < n; i++){
    8000579c:	2905                	addw	s2,s2,1
    8000579e:	0485                	add	s1,s1,1
    800057a0:	fd299de3          	bne	s3,s2,8000577a <consolewrite+0x20>
    800057a4:	894e                	mv	s2,s3
  }

  return i;
}
    800057a6:	854a                	mv	a0,s2
    800057a8:	60a6                	ld	ra,72(sp)
    800057aa:	6406                	ld	s0,64(sp)
    800057ac:	74e2                	ld	s1,56(sp)
    800057ae:	7942                	ld	s2,48(sp)
    800057b0:	79a2                	ld	s3,40(sp)
    800057b2:	7a02                	ld	s4,32(sp)
    800057b4:	6ae2                	ld	s5,24(sp)
    800057b6:	6161                	add	sp,sp,80
    800057b8:	8082                	ret
  for(i = 0; i < n; i++){
    800057ba:	4901                	li	s2,0
    800057bc:	b7ed                	j	800057a6 <consolewrite+0x4c>

00000000800057be <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800057be:	711d                	add	sp,sp,-96
    800057c0:	ec86                	sd	ra,88(sp)
    800057c2:	e8a2                	sd	s0,80(sp)
    800057c4:	e4a6                	sd	s1,72(sp)
    800057c6:	e0ca                	sd	s2,64(sp)
    800057c8:	fc4e                	sd	s3,56(sp)
    800057ca:	f852                	sd	s4,48(sp)
    800057cc:	f456                	sd	s5,40(sp)
    800057ce:	f05a                	sd	s6,32(sp)
    800057d0:	ec5e                	sd	s7,24(sp)
    800057d2:	1080                	add	s0,sp,96
    800057d4:	8aaa                	mv	s5,a0
    800057d6:	8a2e                	mv	s4,a1
    800057d8:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800057da:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    800057de:	0001c517          	auipc	a0,0x1c
    800057e2:	49250513          	add	a0,a0,1170 # 80021c70 <cons>
    800057e6:	00001097          	auipc	ra,0x1
    800057ea:	8e8080e7          	jalr	-1816(ra) # 800060ce <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800057ee:	0001c497          	auipc	s1,0x1c
    800057f2:	48248493          	add	s1,s1,1154 # 80021c70 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800057f6:	0001c917          	auipc	s2,0x1c
    800057fa:	51290913          	add	s2,s2,1298 # 80021d08 <cons+0x98>
  while(n > 0){
    800057fe:	09305263          	blez	s3,80005882 <consoleread+0xc4>
    while(cons.r == cons.w){
    80005802:	0984a783          	lw	a5,152(s1)
    80005806:	09c4a703          	lw	a4,156(s1)
    8000580a:	02f71763          	bne	a4,a5,80005838 <consoleread+0x7a>
      if(killed(myproc())){
    8000580e:	ffffb097          	auipc	ra,0xffffb
    80005812:	69c080e7          	jalr	1692(ra) # 80000eaa <myproc>
    80005816:	ffffc097          	auipc	ra,0xffffc
    8000581a:	fe8080e7          	jalr	-24(ra) # 800017fe <killed>
    8000581e:	ed2d                	bnez	a0,80005898 <consoleread+0xda>
      sleep(&cons.r, &cons.lock);
    80005820:	85a6                	mv	a1,s1
    80005822:	854a                	mv	a0,s2
    80005824:	ffffc097          	auipc	ra,0xffffc
    80005828:	d32080e7          	jalr	-718(ra) # 80001556 <sleep>
    while(cons.r == cons.w){
    8000582c:	0984a783          	lw	a5,152(s1)
    80005830:	09c4a703          	lw	a4,156(s1)
    80005834:	fcf70de3          	beq	a4,a5,8000580e <consoleread+0x50>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005838:	0001c717          	auipc	a4,0x1c
    8000583c:	43870713          	add	a4,a4,1080 # 80021c70 <cons>
    80005840:	0017869b          	addw	a3,a5,1
    80005844:	08d72c23          	sw	a3,152(a4)
    80005848:	07f7f693          	and	a3,a5,127
    8000584c:	9736                	add	a4,a4,a3
    8000584e:	01874703          	lbu	a4,24(a4)
    80005852:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005856:	4691                	li	a3,4
    80005858:	06db8463          	beq	s7,a3,800058c0 <consoleread+0x102>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    8000585c:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005860:	4685                	li	a3,1
    80005862:	faf40613          	add	a2,s0,-81
    80005866:	85d2                	mv	a1,s4
    80005868:	8556                	mv	a0,s5
    8000586a:	ffffc097          	auipc	ra,0xffffc
    8000586e:	0f4080e7          	jalr	244(ra) # 8000195e <either_copyout>
    80005872:	57fd                	li	a5,-1
    80005874:	00f50763          	beq	a0,a5,80005882 <consoleread+0xc4>
      break;

    dst++;
    80005878:	0a05                	add	s4,s4,1
    --n;
    8000587a:	39fd                	addw	s3,s3,-1

    if(c == '\n'){
    8000587c:	47a9                	li	a5,10
    8000587e:	f8fb90e3          	bne	s7,a5,800057fe <consoleread+0x40>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005882:	0001c517          	auipc	a0,0x1c
    80005886:	3ee50513          	add	a0,a0,1006 # 80021c70 <cons>
    8000588a:	00001097          	auipc	ra,0x1
    8000588e:	8f8080e7          	jalr	-1800(ra) # 80006182 <release>

  return target - n;
    80005892:	413b053b          	subw	a0,s6,s3
    80005896:	a811                	j	800058aa <consoleread+0xec>
        release(&cons.lock);
    80005898:	0001c517          	auipc	a0,0x1c
    8000589c:	3d850513          	add	a0,a0,984 # 80021c70 <cons>
    800058a0:	00001097          	auipc	ra,0x1
    800058a4:	8e2080e7          	jalr	-1822(ra) # 80006182 <release>
        return -1;
    800058a8:	557d                	li	a0,-1
}
    800058aa:	60e6                	ld	ra,88(sp)
    800058ac:	6446                	ld	s0,80(sp)
    800058ae:	64a6                	ld	s1,72(sp)
    800058b0:	6906                	ld	s2,64(sp)
    800058b2:	79e2                	ld	s3,56(sp)
    800058b4:	7a42                	ld	s4,48(sp)
    800058b6:	7aa2                	ld	s5,40(sp)
    800058b8:	7b02                	ld	s6,32(sp)
    800058ba:	6be2                	ld	s7,24(sp)
    800058bc:	6125                	add	sp,sp,96
    800058be:	8082                	ret
      if(n < target){
    800058c0:	0009871b          	sext.w	a4,s3
    800058c4:	fb677fe3          	bgeu	a4,s6,80005882 <consoleread+0xc4>
        cons.r--;
    800058c8:	0001c717          	auipc	a4,0x1c
    800058cc:	44f72023          	sw	a5,1088(a4) # 80021d08 <cons+0x98>
    800058d0:	bf4d                	j	80005882 <consoleread+0xc4>

00000000800058d2 <consputc>:
{
    800058d2:	1141                	add	sp,sp,-16
    800058d4:	e406                	sd	ra,8(sp)
    800058d6:	e022                	sd	s0,0(sp)
    800058d8:	0800                	add	s0,sp,16
  if(c == BACKSPACE){
    800058da:	10000793          	li	a5,256
    800058de:	00f50a63          	beq	a0,a5,800058f2 <consputc+0x20>
    uartputc_sync(c);
    800058e2:	00000097          	auipc	ra,0x0
    800058e6:	560080e7          	jalr	1376(ra) # 80005e42 <uartputc_sync>
}
    800058ea:	60a2                	ld	ra,8(sp)
    800058ec:	6402                	ld	s0,0(sp)
    800058ee:	0141                	add	sp,sp,16
    800058f0:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800058f2:	4521                	li	a0,8
    800058f4:	00000097          	auipc	ra,0x0
    800058f8:	54e080e7          	jalr	1358(ra) # 80005e42 <uartputc_sync>
    800058fc:	02000513          	li	a0,32
    80005900:	00000097          	auipc	ra,0x0
    80005904:	542080e7          	jalr	1346(ra) # 80005e42 <uartputc_sync>
    80005908:	4521                	li	a0,8
    8000590a:	00000097          	auipc	ra,0x0
    8000590e:	538080e7          	jalr	1336(ra) # 80005e42 <uartputc_sync>
    80005912:	bfe1                	j	800058ea <consputc+0x18>

0000000080005914 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005914:	1101                	add	sp,sp,-32
    80005916:	ec06                	sd	ra,24(sp)
    80005918:	e822                	sd	s0,16(sp)
    8000591a:	e426                	sd	s1,8(sp)
    8000591c:	e04a                	sd	s2,0(sp)
    8000591e:	1000                	add	s0,sp,32
    80005920:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005922:	0001c517          	auipc	a0,0x1c
    80005926:	34e50513          	add	a0,a0,846 # 80021c70 <cons>
    8000592a:	00000097          	auipc	ra,0x0
    8000592e:	7a4080e7          	jalr	1956(ra) # 800060ce <acquire>

  switch(c){
    80005932:	47d5                	li	a5,21
    80005934:	0af48663          	beq	s1,a5,800059e0 <consoleintr+0xcc>
    80005938:	0297ca63          	blt	a5,s1,8000596c <consoleintr+0x58>
    8000593c:	47a1                	li	a5,8
    8000593e:	0ef48763          	beq	s1,a5,80005a2c <consoleintr+0x118>
    80005942:	47c1                	li	a5,16
    80005944:	10f49a63          	bne	s1,a5,80005a58 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005948:	ffffc097          	auipc	ra,0xffffc
    8000594c:	0c2080e7          	jalr	194(ra) # 80001a0a <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005950:	0001c517          	auipc	a0,0x1c
    80005954:	32050513          	add	a0,a0,800 # 80021c70 <cons>
    80005958:	00001097          	auipc	ra,0x1
    8000595c:	82a080e7          	jalr	-2006(ra) # 80006182 <release>
}
    80005960:	60e2                	ld	ra,24(sp)
    80005962:	6442                	ld	s0,16(sp)
    80005964:	64a2                	ld	s1,8(sp)
    80005966:	6902                	ld	s2,0(sp)
    80005968:	6105                	add	sp,sp,32
    8000596a:	8082                	ret
  switch(c){
    8000596c:	07f00793          	li	a5,127
    80005970:	0af48e63          	beq	s1,a5,80005a2c <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005974:	0001c717          	auipc	a4,0x1c
    80005978:	2fc70713          	add	a4,a4,764 # 80021c70 <cons>
    8000597c:	0a072783          	lw	a5,160(a4)
    80005980:	09872703          	lw	a4,152(a4)
    80005984:	9f99                	subw	a5,a5,a4
    80005986:	07f00713          	li	a4,127
    8000598a:	fcf763e3          	bltu	a4,a5,80005950 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    8000598e:	47b5                	li	a5,13
    80005990:	0cf48763          	beq	s1,a5,80005a5e <consoleintr+0x14a>
      consputc(c);
    80005994:	8526                	mv	a0,s1
    80005996:	00000097          	auipc	ra,0x0
    8000599a:	f3c080e7          	jalr	-196(ra) # 800058d2 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    8000599e:	0001c797          	auipc	a5,0x1c
    800059a2:	2d278793          	add	a5,a5,722 # 80021c70 <cons>
    800059a6:	0a07a683          	lw	a3,160(a5)
    800059aa:	0016871b          	addw	a4,a3,1
    800059ae:	0007061b          	sext.w	a2,a4
    800059b2:	0ae7a023          	sw	a4,160(a5)
    800059b6:	07f6f693          	and	a3,a3,127
    800059ba:	97b6                	add	a5,a5,a3
    800059bc:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    800059c0:	47a9                	li	a5,10
    800059c2:	0cf48563          	beq	s1,a5,80005a8c <consoleintr+0x178>
    800059c6:	4791                	li	a5,4
    800059c8:	0cf48263          	beq	s1,a5,80005a8c <consoleintr+0x178>
    800059cc:	0001c797          	auipc	a5,0x1c
    800059d0:	33c7a783          	lw	a5,828(a5) # 80021d08 <cons+0x98>
    800059d4:	9f1d                	subw	a4,a4,a5
    800059d6:	08000793          	li	a5,128
    800059da:	f6f71be3          	bne	a4,a5,80005950 <consoleintr+0x3c>
    800059de:	a07d                	j	80005a8c <consoleintr+0x178>
    while(cons.e != cons.w &&
    800059e0:	0001c717          	auipc	a4,0x1c
    800059e4:	29070713          	add	a4,a4,656 # 80021c70 <cons>
    800059e8:	0a072783          	lw	a5,160(a4)
    800059ec:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800059f0:	0001c497          	auipc	s1,0x1c
    800059f4:	28048493          	add	s1,s1,640 # 80021c70 <cons>
    while(cons.e != cons.w &&
    800059f8:	4929                	li	s2,10
    800059fa:	f4f70be3          	beq	a4,a5,80005950 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800059fe:	37fd                	addw	a5,a5,-1
    80005a00:	07f7f713          	and	a4,a5,127
    80005a04:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005a06:	01874703          	lbu	a4,24(a4)
    80005a0a:	f52703e3          	beq	a4,s2,80005950 <consoleintr+0x3c>
      cons.e--;
    80005a0e:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005a12:	10000513          	li	a0,256
    80005a16:	00000097          	auipc	ra,0x0
    80005a1a:	ebc080e7          	jalr	-324(ra) # 800058d2 <consputc>
    while(cons.e != cons.w &&
    80005a1e:	0a04a783          	lw	a5,160(s1)
    80005a22:	09c4a703          	lw	a4,156(s1)
    80005a26:	fcf71ce3          	bne	a4,a5,800059fe <consoleintr+0xea>
    80005a2a:	b71d                	j	80005950 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005a2c:	0001c717          	auipc	a4,0x1c
    80005a30:	24470713          	add	a4,a4,580 # 80021c70 <cons>
    80005a34:	0a072783          	lw	a5,160(a4)
    80005a38:	09c72703          	lw	a4,156(a4)
    80005a3c:	f0f70ae3          	beq	a4,a5,80005950 <consoleintr+0x3c>
      cons.e--;
    80005a40:	37fd                	addw	a5,a5,-1
    80005a42:	0001c717          	auipc	a4,0x1c
    80005a46:	2cf72723          	sw	a5,718(a4) # 80021d10 <cons+0xa0>
      consputc(BACKSPACE);
    80005a4a:	10000513          	li	a0,256
    80005a4e:	00000097          	auipc	ra,0x0
    80005a52:	e84080e7          	jalr	-380(ra) # 800058d2 <consputc>
    80005a56:	bded                	j	80005950 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005a58:	ee048ce3          	beqz	s1,80005950 <consoleintr+0x3c>
    80005a5c:	bf21                	j	80005974 <consoleintr+0x60>
      consputc(c);
    80005a5e:	4529                	li	a0,10
    80005a60:	00000097          	auipc	ra,0x0
    80005a64:	e72080e7          	jalr	-398(ra) # 800058d2 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005a68:	0001c797          	auipc	a5,0x1c
    80005a6c:	20878793          	add	a5,a5,520 # 80021c70 <cons>
    80005a70:	0a07a703          	lw	a4,160(a5)
    80005a74:	0017069b          	addw	a3,a4,1
    80005a78:	0006861b          	sext.w	a2,a3
    80005a7c:	0ad7a023          	sw	a3,160(a5)
    80005a80:	07f77713          	and	a4,a4,127
    80005a84:	97ba                	add	a5,a5,a4
    80005a86:	4729                	li	a4,10
    80005a88:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005a8c:	0001c797          	auipc	a5,0x1c
    80005a90:	28c7a023          	sw	a2,640(a5) # 80021d0c <cons+0x9c>
        wakeup(&cons.r);
    80005a94:	0001c517          	auipc	a0,0x1c
    80005a98:	27450513          	add	a0,a0,628 # 80021d08 <cons+0x98>
    80005a9c:	ffffc097          	auipc	ra,0xffffc
    80005aa0:	b1e080e7          	jalr	-1250(ra) # 800015ba <wakeup>
    80005aa4:	b575                	j	80005950 <consoleintr+0x3c>

0000000080005aa6 <consoleinit>:

void
consoleinit(void)
{
    80005aa6:	1141                	add	sp,sp,-16
    80005aa8:	e406                	sd	ra,8(sp)
    80005aaa:	e022                	sd	s0,0(sp)
    80005aac:	0800                	add	s0,sp,16
  initlock(&cons.lock, "cons");
    80005aae:	00003597          	auipc	a1,0x3
    80005ab2:	d5258593          	add	a1,a1,-686 # 80008800 <syscalls+0x3f0>
    80005ab6:	0001c517          	auipc	a0,0x1c
    80005aba:	1ba50513          	add	a0,a0,442 # 80021c70 <cons>
    80005abe:	00000097          	auipc	ra,0x0
    80005ac2:	580080e7          	jalr	1408(ra) # 8000603e <initlock>

  uartinit();
    80005ac6:	00000097          	auipc	ra,0x0
    80005aca:	32c080e7          	jalr	812(ra) # 80005df2 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005ace:	00013797          	auipc	a5,0x13
    80005ad2:	eca78793          	add	a5,a5,-310 # 80018998 <devsw>
    80005ad6:	00000717          	auipc	a4,0x0
    80005ada:	ce870713          	add	a4,a4,-792 # 800057be <consoleread>
    80005ade:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005ae0:	00000717          	auipc	a4,0x0
    80005ae4:	c7a70713          	add	a4,a4,-902 # 8000575a <consolewrite>
    80005ae8:	ef98                	sd	a4,24(a5)
}
    80005aea:	60a2                	ld	ra,8(sp)
    80005aec:	6402                	ld	s0,0(sp)
    80005aee:	0141                	add	sp,sp,16
    80005af0:	8082                	ret

0000000080005af2 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005af2:	7179                	add	sp,sp,-48
    80005af4:	f406                	sd	ra,40(sp)
    80005af6:	f022                	sd	s0,32(sp)
    80005af8:	ec26                	sd	s1,24(sp)
    80005afa:	e84a                	sd	s2,16(sp)
    80005afc:	1800                	add	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005afe:	c219                	beqz	a2,80005b04 <printint+0x12>
    80005b00:	08054763          	bltz	a0,80005b8e <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005b04:	2501                	sext.w	a0,a0
    80005b06:	4881                	li	a7,0
    80005b08:	fd040693          	add	a3,s0,-48

  i = 0;
    80005b0c:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005b0e:	2581                	sext.w	a1,a1
    80005b10:	00003617          	auipc	a2,0x3
    80005b14:	d2060613          	add	a2,a2,-736 # 80008830 <digits>
    80005b18:	883a                	mv	a6,a4
    80005b1a:	2705                	addw	a4,a4,1
    80005b1c:	02b577bb          	remuw	a5,a0,a1
    80005b20:	1782                	sll	a5,a5,0x20
    80005b22:	9381                	srl	a5,a5,0x20
    80005b24:	97b2                	add	a5,a5,a2
    80005b26:	0007c783          	lbu	a5,0(a5)
    80005b2a:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005b2e:	0005079b          	sext.w	a5,a0
    80005b32:	02b5553b          	divuw	a0,a0,a1
    80005b36:	0685                	add	a3,a3,1
    80005b38:	feb7f0e3          	bgeu	a5,a1,80005b18 <printint+0x26>

  if(sign)
    80005b3c:	00088c63          	beqz	a7,80005b54 <printint+0x62>
    buf[i++] = '-';
    80005b40:	fe070793          	add	a5,a4,-32
    80005b44:	00878733          	add	a4,a5,s0
    80005b48:	02d00793          	li	a5,45
    80005b4c:	fef70823          	sb	a5,-16(a4)
    80005b50:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
    80005b54:	02e05763          	blez	a4,80005b82 <printint+0x90>
    80005b58:	fd040793          	add	a5,s0,-48
    80005b5c:	00e784b3          	add	s1,a5,a4
    80005b60:	fff78913          	add	s2,a5,-1
    80005b64:	993a                	add	s2,s2,a4
    80005b66:	377d                	addw	a4,a4,-1
    80005b68:	1702                	sll	a4,a4,0x20
    80005b6a:	9301                	srl	a4,a4,0x20
    80005b6c:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005b70:	fff4c503          	lbu	a0,-1(s1)
    80005b74:	00000097          	auipc	ra,0x0
    80005b78:	d5e080e7          	jalr	-674(ra) # 800058d2 <consputc>
  while(--i >= 0)
    80005b7c:	14fd                	add	s1,s1,-1
    80005b7e:	ff2499e3          	bne	s1,s2,80005b70 <printint+0x7e>
}
    80005b82:	70a2                	ld	ra,40(sp)
    80005b84:	7402                	ld	s0,32(sp)
    80005b86:	64e2                	ld	s1,24(sp)
    80005b88:	6942                	ld	s2,16(sp)
    80005b8a:	6145                	add	sp,sp,48
    80005b8c:	8082                	ret
    x = -xx;
    80005b8e:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005b92:	4885                	li	a7,1
    x = -xx;
    80005b94:	bf95                	j	80005b08 <printint+0x16>

0000000080005b96 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005b96:	1101                	add	sp,sp,-32
    80005b98:	ec06                	sd	ra,24(sp)
    80005b9a:	e822                	sd	s0,16(sp)
    80005b9c:	e426                	sd	s1,8(sp)
    80005b9e:	1000                	add	s0,sp,32
    80005ba0:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005ba2:	0001c797          	auipc	a5,0x1c
    80005ba6:	1807a723          	sw	zero,398(a5) # 80021d30 <pr+0x18>
  printf("panic: ");
    80005baa:	00003517          	auipc	a0,0x3
    80005bae:	c5e50513          	add	a0,a0,-930 # 80008808 <syscalls+0x3f8>
    80005bb2:	00000097          	auipc	ra,0x0
    80005bb6:	02e080e7          	jalr	46(ra) # 80005be0 <printf>
  printf(s);
    80005bba:	8526                	mv	a0,s1
    80005bbc:	00000097          	auipc	ra,0x0
    80005bc0:	024080e7          	jalr	36(ra) # 80005be0 <printf>
  printf("\n");
    80005bc4:	00002517          	auipc	a0,0x2
    80005bc8:	48450513          	add	a0,a0,1156 # 80008048 <etext+0x48>
    80005bcc:	00000097          	auipc	ra,0x0
    80005bd0:	014080e7          	jalr	20(ra) # 80005be0 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005bd4:	4785                	li	a5,1
    80005bd6:	00003717          	auipc	a4,0x3
    80005bda:	d0f72b23          	sw	a5,-746(a4) # 800088ec <panicked>
  for(;;)
    80005bde:	a001                	j	80005bde <panic+0x48>

0000000080005be0 <printf>:
{
    80005be0:	7131                	add	sp,sp,-192
    80005be2:	fc86                	sd	ra,120(sp)
    80005be4:	f8a2                	sd	s0,112(sp)
    80005be6:	f4a6                	sd	s1,104(sp)
    80005be8:	f0ca                	sd	s2,96(sp)
    80005bea:	ecce                	sd	s3,88(sp)
    80005bec:	e8d2                	sd	s4,80(sp)
    80005bee:	e4d6                	sd	s5,72(sp)
    80005bf0:	e0da                	sd	s6,64(sp)
    80005bf2:	fc5e                	sd	s7,56(sp)
    80005bf4:	f862                	sd	s8,48(sp)
    80005bf6:	f466                	sd	s9,40(sp)
    80005bf8:	f06a                	sd	s10,32(sp)
    80005bfa:	ec6e                	sd	s11,24(sp)
    80005bfc:	0100                	add	s0,sp,128
    80005bfe:	8a2a                	mv	s4,a0
    80005c00:	e40c                	sd	a1,8(s0)
    80005c02:	e810                	sd	a2,16(s0)
    80005c04:	ec14                	sd	a3,24(s0)
    80005c06:	f018                	sd	a4,32(s0)
    80005c08:	f41c                	sd	a5,40(s0)
    80005c0a:	03043823          	sd	a6,48(s0)
    80005c0e:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005c12:	0001cd97          	auipc	s11,0x1c
    80005c16:	11edad83          	lw	s11,286(s11) # 80021d30 <pr+0x18>
  if(locking)
    80005c1a:	020d9b63          	bnez	s11,80005c50 <printf+0x70>
  if (fmt == 0)
    80005c1e:	040a0263          	beqz	s4,80005c62 <printf+0x82>
  va_start(ap, fmt);
    80005c22:	00840793          	add	a5,s0,8
    80005c26:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005c2a:	000a4503          	lbu	a0,0(s4)
    80005c2e:	14050f63          	beqz	a0,80005d8c <printf+0x1ac>
    80005c32:	4981                	li	s3,0
    if(c != '%'){
    80005c34:	02500a93          	li	s5,37
    switch(c){
    80005c38:	07000b93          	li	s7,112
  consputc('x');
    80005c3c:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005c3e:	00003b17          	auipc	s6,0x3
    80005c42:	bf2b0b13          	add	s6,s6,-1038 # 80008830 <digits>
    switch(c){
    80005c46:	07300c93          	li	s9,115
    80005c4a:	06400c13          	li	s8,100
    80005c4e:	a82d                	j	80005c88 <printf+0xa8>
    acquire(&pr.lock);
    80005c50:	0001c517          	auipc	a0,0x1c
    80005c54:	0c850513          	add	a0,a0,200 # 80021d18 <pr>
    80005c58:	00000097          	auipc	ra,0x0
    80005c5c:	476080e7          	jalr	1142(ra) # 800060ce <acquire>
    80005c60:	bf7d                	j	80005c1e <printf+0x3e>
    panic("null fmt");
    80005c62:	00003517          	auipc	a0,0x3
    80005c66:	bb650513          	add	a0,a0,-1098 # 80008818 <syscalls+0x408>
    80005c6a:	00000097          	auipc	ra,0x0
    80005c6e:	f2c080e7          	jalr	-212(ra) # 80005b96 <panic>
      consputc(c);
    80005c72:	00000097          	auipc	ra,0x0
    80005c76:	c60080e7          	jalr	-928(ra) # 800058d2 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005c7a:	2985                	addw	s3,s3,1
    80005c7c:	013a07b3          	add	a5,s4,s3
    80005c80:	0007c503          	lbu	a0,0(a5)
    80005c84:	10050463          	beqz	a0,80005d8c <printf+0x1ac>
    if(c != '%'){
    80005c88:	ff5515e3          	bne	a0,s5,80005c72 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005c8c:	2985                	addw	s3,s3,1
    80005c8e:	013a07b3          	add	a5,s4,s3
    80005c92:	0007c783          	lbu	a5,0(a5)
    80005c96:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005c9a:	cbed                	beqz	a5,80005d8c <printf+0x1ac>
    switch(c){
    80005c9c:	05778a63          	beq	a5,s7,80005cf0 <printf+0x110>
    80005ca0:	02fbf663          	bgeu	s7,a5,80005ccc <printf+0xec>
    80005ca4:	09978863          	beq	a5,s9,80005d34 <printf+0x154>
    80005ca8:	07800713          	li	a4,120
    80005cac:	0ce79563          	bne	a5,a4,80005d76 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005cb0:	f8843783          	ld	a5,-120(s0)
    80005cb4:	00878713          	add	a4,a5,8
    80005cb8:	f8e43423          	sd	a4,-120(s0)
    80005cbc:	4605                	li	a2,1
    80005cbe:	85ea                	mv	a1,s10
    80005cc0:	4388                	lw	a0,0(a5)
    80005cc2:	00000097          	auipc	ra,0x0
    80005cc6:	e30080e7          	jalr	-464(ra) # 80005af2 <printint>
      break;
    80005cca:	bf45                	j	80005c7a <printf+0x9a>
    switch(c){
    80005ccc:	09578f63          	beq	a5,s5,80005d6a <printf+0x18a>
    80005cd0:	0b879363          	bne	a5,s8,80005d76 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005cd4:	f8843783          	ld	a5,-120(s0)
    80005cd8:	00878713          	add	a4,a5,8
    80005cdc:	f8e43423          	sd	a4,-120(s0)
    80005ce0:	4605                	li	a2,1
    80005ce2:	45a9                	li	a1,10
    80005ce4:	4388                	lw	a0,0(a5)
    80005ce6:	00000097          	auipc	ra,0x0
    80005cea:	e0c080e7          	jalr	-500(ra) # 80005af2 <printint>
      break;
    80005cee:	b771                	j	80005c7a <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005cf0:	f8843783          	ld	a5,-120(s0)
    80005cf4:	00878713          	add	a4,a5,8
    80005cf8:	f8e43423          	sd	a4,-120(s0)
    80005cfc:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005d00:	03000513          	li	a0,48
    80005d04:	00000097          	auipc	ra,0x0
    80005d08:	bce080e7          	jalr	-1074(ra) # 800058d2 <consputc>
  consputc('x');
    80005d0c:	07800513          	li	a0,120
    80005d10:	00000097          	auipc	ra,0x0
    80005d14:	bc2080e7          	jalr	-1086(ra) # 800058d2 <consputc>
    80005d18:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005d1a:	03c95793          	srl	a5,s2,0x3c
    80005d1e:	97da                	add	a5,a5,s6
    80005d20:	0007c503          	lbu	a0,0(a5)
    80005d24:	00000097          	auipc	ra,0x0
    80005d28:	bae080e7          	jalr	-1106(ra) # 800058d2 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005d2c:	0912                	sll	s2,s2,0x4
    80005d2e:	34fd                	addw	s1,s1,-1
    80005d30:	f4ed                	bnez	s1,80005d1a <printf+0x13a>
    80005d32:	b7a1                	j	80005c7a <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005d34:	f8843783          	ld	a5,-120(s0)
    80005d38:	00878713          	add	a4,a5,8
    80005d3c:	f8e43423          	sd	a4,-120(s0)
    80005d40:	6384                	ld	s1,0(a5)
    80005d42:	cc89                	beqz	s1,80005d5c <printf+0x17c>
      for(; *s; s++)
    80005d44:	0004c503          	lbu	a0,0(s1)
    80005d48:	d90d                	beqz	a0,80005c7a <printf+0x9a>
        consputc(*s);
    80005d4a:	00000097          	auipc	ra,0x0
    80005d4e:	b88080e7          	jalr	-1144(ra) # 800058d2 <consputc>
      for(; *s; s++)
    80005d52:	0485                	add	s1,s1,1
    80005d54:	0004c503          	lbu	a0,0(s1)
    80005d58:	f96d                	bnez	a0,80005d4a <printf+0x16a>
    80005d5a:	b705                	j	80005c7a <printf+0x9a>
        s = "(null)";
    80005d5c:	00003497          	auipc	s1,0x3
    80005d60:	ab448493          	add	s1,s1,-1356 # 80008810 <syscalls+0x400>
      for(; *s; s++)
    80005d64:	02800513          	li	a0,40
    80005d68:	b7cd                	j	80005d4a <printf+0x16a>
      consputc('%');
    80005d6a:	8556                	mv	a0,s5
    80005d6c:	00000097          	auipc	ra,0x0
    80005d70:	b66080e7          	jalr	-1178(ra) # 800058d2 <consputc>
      break;
    80005d74:	b719                	j	80005c7a <printf+0x9a>
      consputc('%');
    80005d76:	8556                	mv	a0,s5
    80005d78:	00000097          	auipc	ra,0x0
    80005d7c:	b5a080e7          	jalr	-1190(ra) # 800058d2 <consputc>
      consputc(c);
    80005d80:	8526                	mv	a0,s1
    80005d82:	00000097          	auipc	ra,0x0
    80005d86:	b50080e7          	jalr	-1200(ra) # 800058d2 <consputc>
      break;
    80005d8a:	bdc5                	j	80005c7a <printf+0x9a>
  if(locking)
    80005d8c:	020d9163          	bnez	s11,80005dae <printf+0x1ce>
}
    80005d90:	70e6                	ld	ra,120(sp)
    80005d92:	7446                	ld	s0,112(sp)
    80005d94:	74a6                	ld	s1,104(sp)
    80005d96:	7906                	ld	s2,96(sp)
    80005d98:	69e6                	ld	s3,88(sp)
    80005d9a:	6a46                	ld	s4,80(sp)
    80005d9c:	6aa6                	ld	s5,72(sp)
    80005d9e:	6b06                	ld	s6,64(sp)
    80005da0:	7be2                	ld	s7,56(sp)
    80005da2:	7c42                	ld	s8,48(sp)
    80005da4:	7ca2                	ld	s9,40(sp)
    80005da6:	7d02                	ld	s10,32(sp)
    80005da8:	6de2                	ld	s11,24(sp)
    80005daa:	6129                	add	sp,sp,192
    80005dac:	8082                	ret
    release(&pr.lock);
    80005dae:	0001c517          	auipc	a0,0x1c
    80005db2:	f6a50513          	add	a0,a0,-150 # 80021d18 <pr>
    80005db6:	00000097          	auipc	ra,0x0
    80005dba:	3cc080e7          	jalr	972(ra) # 80006182 <release>
}
    80005dbe:	bfc9                	j	80005d90 <printf+0x1b0>

0000000080005dc0 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005dc0:	1101                	add	sp,sp,-32
    80005dc2:	ec06                	sd	ra,24(sp)
    80005dc4:	e822                	sd	s0,16(sp)
    80005dc6:	e426                	sd	s1,8(sp)
    80005dc8:	1000                	add	s0,sp,32
  initlock(&pr.lock, "pr");
    80005dca:	0001c497          	auipc	s1,0x1c
    80005dce:	f4e48493          	add	s1,s1,-178 # 80021d18 <pr>
    80005dd2:	00003597          	auipc	a1,0x3
    80005dd6:	a5658593          	add	a1,a1,-1450 # 80008828 <syscalls+0x418>
    80005dda:	8526                	mv	a0,s1
    80005ddc:	00000097          	auipc	ra,0x0
    80005de0:	262080e7          	jalr	610(ra) # 8000603e <initlock>
  pr.locking = 1;
    80005de4:	4785                	li	a5,1
    80005de6:	cc9c                	sw	a5,24(s1)
}
    80005de8:	60e2                	ld	ra,24(sp)
    80005dea:	6442                	ld	s0,16(sp)
    80005dec:	64a2                	ld	s1,8(sp)
    80005dee:	6105                	add	sp,sp,32
    80005df0:	8082                	ret

0000000080005df2 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005df2:	1141                	add	sp,sp,-16
    80005df4:	e406                	sd	ra,8(sp)
    80005df6:	e022                	sd	s0,0(sp)
    80005df8:	0800                	add	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005dfa:	100007b7          	lui	a5,0x10000
    80005dfe:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005e02:	f8000713          	li	a4,-128
    80005e06:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005e0a:	470d                	li	a4,3
    80005e0c:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005e10:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005e14:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005e18:	469d                	li	a3,7
    80005e1a:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005e1e:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005e22:	00003597          	auipc	a1,0x3
    80005e26:	a2658593          	add	a1,a1,-1498 # 80008848 <digits+0x18>
    80005e2a:	0001c517          	auipc	a0,0x1c
    80005e2e:	f0e50513          	add	a0,a0,-242 # 80021d38 <uart_tx_lock>
    80005e32:	00000097          	auipc	ra,0x0
    80005e36:	20c080e7          	jalr	524(ra) # 8000603e <initlock>
}
    80005e3a:	60a2                	ld	ra,8(sp)
    80005e3c:	6402                	ld	s0,0(sp)
    80005e3e:	0141                	add	sp,sp,16
    80005e40:	8082                	ret

0000000080005e42 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005e42:	1101                	add	sp,sp,-32
    80005e44:	ec06                	sd	ra,24(sp)
    80005e46:	e822                	sd	s0,16(sp)
    80005e48:	e426                	sd	s1,8(sp)
    80005e4a:	1000                	add	s0,sp,32
    80005e4c:	84aa                	mv	s1,a0
  push_off();
    80005e4e:	00000097          	auipc	ra,0x0
    80005e52:	234080e7          	jalr	564(ra) # 80006082 <push_off>

  if(panicked){
    80005e56:	00003797          	auipc	a5,0x3
    80005e5a:	a967a783          	lw	a5,-1386(a5) # 800088ec <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005e5e:	10000737          	lui	a4,0x10000
  if(panicked){
    80005e62:	c391                	beqz	a5,80005e66 <uartputc_sync+0x24>
    for(;;)
    80005e64:	a001                	j	80005e64 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005e66:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005e6a:	0207f793          	and	a5,a5,32
    80005e6e:	dfe5                	beqz	a5,80005e66 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005e70:	0ff4f513          	zext.b	a0,s1
    80005e74:	100007b7          	lui	a5,0x10000
    80005e78:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005e7c:	00000097          	auipc	ra,0x0
    80005e80:	2a6080e7          	jalr	678(ra) # 80006122 <pop_off>
}
    80005e84:	60e2                	ld	ra,24(sp)
    80005e86:	6442                	ld	s0,16(sp)
    80005e88:	64a2                	ld	s1,8(sp)
    80005e8a:	6105                	add	sp,sp,32
    80005e8c:	8082                	ret

0000000080005e8e <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005e8e:	00003797          	auipc	a5,0x3
    80005e92:	a627b783          	ld	a5,-1438(a5) # 800088f0 <uart_tx_r>
    80005e96:	00003717          	auipc	a4,0x3
    80005e9a:	a6273703          	ld	a4,-1438(a4) # 800088f8 <uart_tx_w>
    80005e9e:	06f70a63          	beq	a4,a5,80005f12 <uartstart+0x84>
{
    80005ea2:	7139                	add	sp,sp,-64
    80005ea4:	fc06                	sd	ra,56(sp)
    80005ea6:	f822                	sd	s0,48(sp)
    80005ea8:	f426                	sd	s1,40(sp)
    80005eaa:	f04a                	sd	s2,32(sp)
    80005eac:	ec4e                	sd	s3,24(sp)
    80005eae:	e852                	sd	s4,16(sp)
    80005eb0:	e456                	sd	s5,8(sp)
    80005eb2:	0080                	add	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005eb4:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005eb8:	0001ca17          	auipc	s4,0x1c
    80005ebc:	e80a0a13          	add	s4,s4,-384 # 80021d38 <uart_tx_lock>
    uart_tx_r += 1;
    80005ec0:	00003497          	auipc	s1,0x3
    80005ec4:	a3048493          	add	s1,s1,-1488 # 800088f0 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80005ec8:	00003997          	auipc	s3,0x3
    80005ecc:	a3098993          	add	s3,s3,-1488 # 800088f8 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005ed0:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80005ed4:	02077713          	and	a4,a4,32
    80005ed8:	c705                	beqz	a4,80005f00 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005eda:	01f7f713          	and	a4,a5,31
    80005ede:	9752                	add	a4,a4,s4
    80005ee0:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80005ee4:	0785                	add	a5,a5,1
    80005ee6:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80005ee8:	8526                	mv	a0,s1
    80005eea:	ffffb097          	auipc	ra,0xffffb
    80005eee:	6d0080e7          	jalr	1744(ra) # 800015ba <wakeup>
    
    WriteReg(THR, c);
    80005ef2:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80005ef6:	609c                	ld	a5,0(s1)
    80005ef8:	0009b703          	ld	a4,0(s3)
    80005efc:	fcf71ae3          	bne	a4,a5,80005ed0 <uartstart+0x42>
  }
}
    80005f00:	70e2                	ld	ra,56(sp)
    80005f02:	7442                	ld	s0,48(sp)
    80005f04:	74a2                	ld	s1,40(sp)
    80005f06:	7902                	ld	s2,32(sp)
    80005f08:	69e2                	ld	s3,24(sp)
    80005f0a:	6a42                	ld	s4,16(sp)
    80005f0c:	6aa2                	ld	s5,8(sp)
    80005f0e:	6121                	add	sp,sp,64
    80005f10:	8082                	ret
    80005f12:	8082                	ret

0000000080005f14 <uartputc>:
{
    80005f14:	7179                	add	sp,sp,-48
    80005f16:	f406                	sd	ra,40(sp)
    80005f18:	f022                	sd	s0,32(sp)
    80005f1a:	ec26                	sd	s1,24(sp)
    80005f1c:	e84a                	sd	s2,16(sp)
    80005f1e:	e44e                	sd	s3,8(sp)
    80005f20:	e052                	sd	s4,0(sp)
    80005f22:	1800                	add	s0,sp,48
    80005f24:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80005f26:	0001c517          	auipc	a0,0x1c
    80005f2a:	e1250513          	add	a0,a0,-494 # 80021d38 <uart_tx_lock>
    80005f2e:	00000097          	auipc	ra,0x0
    80005f32:	1a0080e7          	jalr	416(ra) # 800060ce <acquire>
  if(panicked){
    80005f36:	00003797          	auipc	a5,0x3
    80005f3a:	9b67a783          	lw	a5,-1610(a5) # 800088ec <panicked>
    80005f3e:	e7c9                	bnez	a5,80005fc8 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005f40:	00003717          	auipc	a4,0x3
    80005f44:	9b873703          	ld	a4,-1608(a4) # 800088f8 <uart_tx_w>
    80005f48:	00003797          	auipc	a5,0x3
    80005f4c:	9a87b783          	ld	a5,-1624(a5) # 800088f0 <uart_tx_r>
    80005f50:	02078793          	add	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80005f54:	0001c997          	auipc	s3,0x1c
    80005f58:	de498993          	add	s3,s3,-540 # 80021d38 <uart_tx_lock>
    80005f5c:	00003497          	auipc	s1,0x3
    80005f60:	99448493          	add	s1,s1,-1644 # 800088f0 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005f64:	00003917          	auipc	s2,0x3
    80005f68:	99490913          	add	s2,s2,-1644 # 800088f8 <uart_tx_w>
    80005f6c:	00e79f63          	bne	a5,a4,80005f8a <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80005f70:	85ce                	mv	a1,s3
    80005f72:	8526                	mv	a0,s1
    80005f74:	ffffb097          	auipc	ra,0xffffb
    80005f78:	5e2080e7          	jalr	1506(ra) # 80001556 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005f7c:	00093703          	ld	a4,0(s2)
    80005f80:	609c                	ld	a5,0(s1)
    80005f82:	02078793          	add	a5,a5,32
    80005f86:	fee785e3          	beq	a5,a4,80005f70 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80005f8a:	0001c497          	auipc	s1,0x1c
    80005f8e:	dae48493          	add	s1,s1,-594 # 80021d38 <uart_tx_lock>
    80005f92:	01f77793          	and	a5,a4,31
    80005f96:	97a6                	add	a5,a5,s1
    80005f98:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80005f9c:	0705                	add	a4,a4,1
    80005f9e:	00003797          	auipc	a5,0x3
    80005fa2:	94e7bd23          	sd	a4,-1702(a5) # 800088f8 <uart_tx_w>
  uartstart();
    80005fa6:	00000097          	auipc	ra,0x0
    80005faa:	ee8080e7          	jalr	-280(ra) # 80005e8e <uartstart>
  release(&uart_tx_lock);
    80005fae:	8526                	mv	a0,s1
    80005fb0:	00000097          	auipc	ra,0x0
    80005fb4:	1d2080e7          	jalr	466(ra) # 80006182 <release>
}
    80005fb8:	70a2                	ld	ra,40(sp)
    80005fba:	7402                	ld	s0,32(sp)
    80005fbc:	64e2                	ld	s1,24(sp)
    80005fbe:	6942                	ld	s2,16(sp)
    80005fc0:	69a2                	ld	s3,8(sp)
    80005fc2:	6a02                	ld	s4,0(sp)
    80005fc4:	6145                	add	sp,sp,48
    80005fc6:	8082                	ret
    for(;;)
    80005fc8:	a001                	j	80005fc8 <uartputc+0xb4>

0000000080005fca <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80005fca:	1141                	add	sp,sp,-16
    80005fcc:	e422                	sd	s0,8(sp)
    80005fce:	0800                	add	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80005fd0:	100007b7          	lui	a5,0x10000
    80005fd4:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80005fd8:	8b85                	and	a5,a5,1
    80005fda:	cb81                	beqz	a5,80005fea <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    80005fdc:	100007b7          	lui	a5,0x10000
    80005fe0:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80005fe4:	6422                	ld	s0,8(sp)
    80005fe6:	0141                	add	sp,sp,16
    80005fe8:	8082                	ret
    return -1;
    80005fea:	557d                	li	a0,-1
    80005fec:	bfe5                	j	80005fe4 <uartgetc+0x1a>

0000000080005fee <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80005fee:	1101                	add	sp,sp,-32
    80005ff0:	ec06                	sd	ra,24(sp)
    80005ff2:	e822                	sd	s0,16(sp)
    80005ff4:	e426                	sd	s1,8(sp)
    80005ff6:	1000                	add	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80005ff8:	54fd                	li	s1,-1
    80005ffa:	a029                	j	80006004 <uartintr+0x16>
      break;
    consoleintr(c);
    80005ffc:	00000097          	auipc	ra,0x0
    80006000:	918080e7          	jalr	-1768(ra) # 80005914 <consoleintr>
    int c = uartgetc();
    80006004:	00000097          	auipc	ra,0x0
    80006008:	fc6080e7          	jalr	-58(ra) # 80005fca <uartgetc>
    if(c == -1)
    8000600c:	fe9518e3          	bne	a0,s1,80005ffc <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006010:	0001c497          	auipc	s1,0x1c
    80006014:	d2848493          	add	s1,s1,-728 # 80021d38 <uart_tx_lock>
    80006018:	8526                	mv	a0,s1
    8000601a:	00000097          	auipc	ra,0x0
    8000601e:	0b4080e7          	jalr	180(ra) # 800060ce <acquire>
  uartstart();
    80006022:	00000097          	auipc	ra,0x0
    80006026:	e6c080e7          	jalr	-404(ra) # 80005e8e <uartstart>
  release(&uart_tx_lock);
    8000602a:	8526                	mv	a0,s1
    8000602c:	00000097          	auipc	ra,0x0
    80006030:	156080e7          	jalr	342(ra) # 80006182 <release>
}
    80006034:	60e2                	ld	ra,24(sp)
    80006036:	6442                	ld	s0,16(sp)
    80006038:	64a2                	ld	s1,8(sp)
    8000603a:	6105                	add	sp,sp,32
    8000603c:	8082                	ret

000000008000603e <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000603e:	1141                	add	sp,sp,-16
    80006040:	e422                	sd	s0,8(sp)
    80006042:	0800                	add	s0,sp,16
  lk->name = name;
    80006044:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006046:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000604a:	00053823          	sd	zero,16(a0)
}
    8000604e:	6422                	ld	s0,8(sp)
    80006050:	0141                	add	sp,sp,16
    80006052:	8082                	ret

0000000080006054 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006054:	411c                	lw	a5,0(a0)
    80006056:	e399                	bnez	a5,8000605c <holding+0x8>
    80006058:	4501                	li	a0,0
  return r;
}
    8000605a:	8082                	ret
{
    8000605c:	1101                	add	sp,sp,-32
    8000605e:	ec06                	sd	ra,24(sp)
    80006060:	e822                	sd	s0,16(sp)
    80006062:	e426                	sd	s1,8(sp)
    80006064:	1000                	add	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006066:	6904                	ld	s1,16(a0)
    80006068:	ffffb097          	auipc	ra,0xffffb
    8000606c:	e26080e7          	jalr	-474(ra) # 80000e8e <mycpu>
    80006070:	40a48533          	sub	a0,s1,a0
    80006074:	00153513          	seqz	a0,a0
}
    80006078:	60e2                	ld	ra,24(sp)
    8000607a:	6442                	ld	s0,16(sp)
    8000607c:	64a2                	ld	s1,8(sp)
    8000607e:	6105                	add	sp,sp,32
    80006080:	8082                	ret

0000000080006082 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006082:	1101                	add	sp,sp,-32
    80006084:	ec06                	sd	ra,24(sp)
    80006086:	e822                	sd	s0,16(sp)
    80006088:	e426                	sd	s1,8(sp)
    8000608a:	1000                	add	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000608c:	100024f3          	csrr	s1,sstatus
    80006090:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006094:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006096:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000609a:	ffffb097          	auipc	ra,0xffffb
    8000609e:	df4080e7          	jalr	-524(ra) # 80000e8e <mycpu>
    800060a2:	5d3c                	lw	a5,120(a0)
    800060a4:	cf89                	beqz	a5,800060be <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800060a6:	ffffb097          	auipc	ra,0xffffb
    800060aa:	de8080e7          	jalr	-536(ra) # 80000e8e <mycpu>
    800060ae:	5d3c                	lw	a5,120(a0)
    800060b0:	2785                	addw	a5,a5,1
    800060b2:	dd3c                	sw	a5,120(a0)
}
    800060b4:	60e2                	ld	ra,24(sp)
    800060b6:	6442                	ld	s0,16(sp)
    800060b8:	64a2                	ld	s1,8(sp)
    800060ba:	6105                	add	sp,sp,32
    800060bc:	8082                	ret
    mycpu()->intena = old;
    800060be:	ffffb097          	auipc	ra,0xffffb
    800060c2:	dd0080e7          	jalr	-560(ra) # 80000e8e <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800060c6:	8085                	srl	s1,s1,0x1
    800060c8:	8885                	and	s1,s1,1
    800060ca:	dd64                	sw	s1,124(a0)
    800060cc:	bfe9                	j	800060a6 <push_off+0x24>

00000000800060ce <acquire>:
{
    800060ce:	1101                	add	sp,sp,-32
    800060d0:	ec06                	sd	ra,24(sp)
    800060d2:	e822                	sd	s0,16(sp)
    800060d4:	e426                	sd	s1,8(sp)
    800060d6:	1000                	add	s0,sp,32
    800060d8:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800060da:	00000097          	auipc	ra,0x0
    800060de:	fa8080e7          	jalr	-88(ra) # 80006082 <push_off>
  if(holding(lk))
    800060e2:	8526                	mv	a0,s1
    800060e4:	00000097          	auipc	ra,0x0
    800060e8:	f70080e7          	jalr	-144(ra) # 80006054 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800060ec:	4705                	li	a4,1
  if(holding(lk))
    800060ee:	e115                	bnez	a0,80006112 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800060f0:	87ba                	mv	a5,a4
    800060f2:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800060f6:	2781                	sext.w	a5,a5
    800060f8:	ffe5                	bnez	a5,800060f0 <acquire+0x22>
  __sync_synchronize();
    800060fa:	0ff0000f          	fence
  lk->cpu = mycpu();
    800060fe:	ffffb097          	auipc	ra,0xffffb
    80006102:	d90080e7          	jalr	-624(ra) # 80000e8e <mycpu>
    80006106:	e888                	sd	a0,16(s1)
}
    80006108:	60e2                	ld	ra,24(sp)
    8000610a:	6442                	ld	s0,16(sp)
    8000610c:	64a2                	ld	s1,8(sp)
    8000610e:	6105                	add	sp,sp,32
    80006110:	8082                	ret
    panic("acquire");
    80006112:	00002517          	auipc	a0,0x2
    80006116:	73e50513          	add	a0,a0,1854 # 80008850 <digits+0x20>
    8000611a:	00000097          	auipc	ra,0x0
    8000611e:	a7c080e7          	jalr	-1412(ra) # 80005b96 <panic>

0000000080006122 <pop_off>:

void
pop_off(void)
{
    80006122:	1141                	add	sp,sp,-16
    80006124:	e406                	sd	ra,8(sp)
    80006126:	e022                	sd	s0,0(sp)
    80006128:	0800                	add	s0,sp,16
  struct cpu *c = mycpu();
    8000612a:	ffffb097          	auipc	ra,0xffffb
    8000612e:	d64080e7          	jalr	-668(ra) # 80000e8e <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006132:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006136:	8b89                	and	a5,a5,2
  if(intr_get())
    80006138:	e78d                	bnez	a5,80006162 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000613a:	5d3c                	lw	a5,120(a0)
    8000613c:	02f05b63          	blez	a5,80006172 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006140:	37fd                	addw	a5,a5,-1
    80006142:	0007871b          	sext.w	a4,a5
    80006146:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006148:	eb09                	bnez	a4,8000615a <pop_off+0x38>
    8000614a:	5d7c                	lw	a5,124(a0)
    8000614c:	c799                	beqz	a5,8000615a <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000614e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006152:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006156:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000615a:	60a2                	ld	ra,8(sp)
    8000615c:	6402                	ld	s0,0(sp)
    8000615e:	0141                	add	sp,sp,16
    80006160:	8082                	ret
    panic("pop_off - interruptible");
    80006162:	00002517          	auipc	a0,0x2
    80006166:	6f650513          	add	a0,a0,1782 # 80008858 <digits+0x28>
    8000616a:	00000097          	auipc	ra,0x0
    8000616e:	a2c080e7          	jalr	-1492(ra) # 80005b96 <panic>
    panic("pop_off");
    80006172:	00002517          	auipc	a0,0x2
    80006176:	6fe50513          	add	a0,a0,1790 # 80008870 <digits+0x40>
    8000617a:	00000097          	auipc	ra,0x0
    8000617e:	a1c080e7          	jalr	-1508(ra) # 80005b96 <panic>

0000000080006182 <release>:
{
    80006182:	1101                	add	sp,sp,-32
    80006184:	ec06                	sd	ra,24(sp)
    80006186:	e822                	sd	s0,16(sp)
    80006188:	e426                	sd	s1,8(sp)
    8000618a:	1000                	add	s0,sp,32
    8000618c:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000618e:	00000097          	auipc	ra,0x0
    80006192:	ec6080e7          	jalr	-314(ra) # 80006054 <holding>
    80006196:	c115                	beqz	a0,800061ba <release+0x38>
  lk->cpu = 0;
    80006198:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000619c:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800061a0:	0f50000f          	fence	iorw,ow
    800061a4:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800061a8:	00000097          	auipc	ra,0x0
    800061ac:	f7a080e7          	jalr	-134(ra) # 80006122 <pop_off>
}
    800061b0:	60e2                	ld	ra,24(sp)
    800061b2:	6442                	ld	s0,16(sp)
    800061b4:	64a2                	ld	s1,8(sp)
    800061b6:	6105                	add	sp,sp,32
    800061b8:	8082                	ret
    panic("release");
    800061ba:	00002517          	auipc	a0,0x2
    800061be:	6be50513          	add	a0,a0,1726 # 80008878 <digits+0x48>
    800061c2:	00000097          	auipc	ra,0x0
    800061c6:	9d4080e7          	jalr	-1580(ra) # 80005b96 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	sll	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070ae:	0536                	sll	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0)
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
