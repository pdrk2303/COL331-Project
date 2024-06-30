#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "fs.h"
#include "x86.h"
#include "proc.h"
#include "buf.h"

#define PGSIZE 4096
#define BSIZE 512

// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
  pde_t *pde;
  pte_t *pgtab;
  cprintf("Entered walkpagedir\n");
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P) {
    cprintf("Present\n");
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    cprintf("Not present\n");
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  cprintf("Returning from walkpagedir\n");
  return &pgtab[PTX(va)];
}

struct rmap{
  struct spinlock lock;
  pte_t* pl[NPROC];
  int free[NPROC];
  int ref;
};

struct rmap allmap[PHYSTOP/PGSIZE];


// Initialize rmap 
void init_rmap(void){
  uint sz= PHYSTOP/PGSIZE;
  for(uint i=0; i<sz; i++){
    initlock(&(allmap[i].lock), "rmap");
    (&allmap[i])->ref=0;
    for(uint j=0; j<NPROC; j++){
      (&allmap[i])->free[j]=1;
    }
  }
}


// Add pte_t* in rmap corresponding to physical page with address pa
void share_add(uint pa, pte_t* pte_child){
  // if(*pte_child & PTE_S) panic("page is in swap space");
  uint index= pa/PGSIZE;
  struct rmap* cur= &allmap[index];
  acquire(&(cur->lock));
  cur->ref++;
  uint i;
  for(i=0; i<NPROC; i++){
    if(cur->free[i]==1) break;
  }
  if(i==NPROC){
    panic("rmap filled");
  }
  cur->free[i]=0;
  cur->pl[i]= pte_child;
  release(&(cur->lock));
}


// Remove pte_t* in rmap corresponding to physical page with address pa
int share_remove(uint pa, pte_t* pte_proc) {
  // if(*pte_proc & PTE_S) panic("page is in swap blocks");
  uint index = pa/PGSIZE;
  struct rmap* cur = &allmap[index];
  acquire(&(cur->lock));
  uint i;
  for(i=0; i<NPROC; i++){
    if(cur->pl[i]==pte_proc && cur->free[i]==0) break;
  }
  if(i==NPROC) panic("Page table entry not found in rmap");
  cur->free[i]=1;
  cur->ref--;
  if(cur->ref==1){
    for(uint j=0; j<NPROC; j++){
      if(cur->free[j]==0){
        *(cur->pl[j]) |= PTE_W;
      }
    }
  }
  release(&(cur->lock));
  return cur->ref;
}


// Make separate page for pte_t* trying to write shared page
void share_split(uint pa, pte_t* pte_proc){
  uint flag= PTE_FLAGS(*pte_proc);
  flag |= PTE_W;
  share_remove(pa,pte_proc);
  char* mem= kalloc();
  memmove(mem,(char*)P2V(pa),PGSIZE);
  *pte_proc = PTE_ADDR(V2P(mem)) | flag;
  share_add(V2P(mem),pte_proc);
}


void handle_page_fault()
{
    uint va=rcr2();
    // va=PGROUNDDOWN(va);
    cprintf("Entered page fault\n");
    pte_t *pte= walkpgdir(myproc()->pgdir,(char*) va, 0); // to check
    cprintf("returned walkpagedir %d\n", *pte);
    cprintf("see,%d\n",(*pte&PTE_W));
    
    if(!(*pte & PTE_W))
    {
      cprintf("Write bit is unset\n");
        //   remove_from_rmap(myproc()->pid,PTE_ADDR(*pte));

        // char* new_page= kalloc();
        // if(new_page==0)
        //     panic("no space in memory");
        // memmove((void*)(new_page),(const void*)(P2V(PTE_ADDR(*pte))),4096);
        // *pte= V2P(new_page)| PTE_P | PTE_W | PTE_U;
        // // init_rmap(V2P(new_page)>>12);
        // update_rmap(myproc()->pid,V2P(new_page));
        // // *pte|=PTE_W;
        // lcr3(V2P(myproc()->pgdir));

      uint pa= PTE_ADDR(*pte);
      share_split(pa,pte);
      lcr3(V2P(myproc()->pgdir));

    }

    else {
      panic("write bit is set");
    }
    cprintf("Returningg page fault\n");
    
     cprintf("Returning\n");
}