#include "types.h"
#include "riscv.h"
#include "param.h"
#include "defs.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
  int n;
  argint(0, &n);
  exit(n);
  return 0;  // not reached
}

uint64
sys_getpid(void)
{
  return myproc()->pid;
}

uint64
sys_fork(void)
{
  return fork();
}

uint64
sys_wait(void)
{
  uint64 p;
  argaddr(0, &p);
  return wait(p);
}

uint64
sys_sbrk(void)
{
  uint64 addr;
  int n;

  argint(0, &n);
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

uint64
sys_sleep(void)
{
  int n;
  uint ticks0;


  argint(0, &n);
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

//#ifdef LAB_PGTBL
int
sys_pgaccess(void)
{

  uint64 start_va;
  int len;
  uint64 uvm_result_buffer_va;

  argaddr(0, &start_va);
  argint(1, &len);
  argaddr(2, &uvm_result_buffer_va);
  pagetable_t pt = myproc()->pagetable;
  int result_buf = 0;

  pgaccess(pt, start_va, len, &result_buf);
  if (result_buf == -1) {
    return -1;
  }
  for (int i = 0; i < 32; i++) {
      if (result_buf & (1 << i)) {
          printf("%d on\n", i);
      }
  }
  copyout(pt, uvm_result_buffer_va, (char*)&result_buf, sizeof(int));
  return 0;
}
//#endif
// todo return the ifdef

uint64
sys_kill(void)
{
  int pid;

  argint(0, &pid);
  return kill(pid);
}

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}
