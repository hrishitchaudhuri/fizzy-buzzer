# Reverse a linked list
When tf would I have ever do that? Nope, wrong answer. Weak no-hire. Besides, according to the internet (a trustable source), this came in handy during the Facebook outage of October 2021.  

Yes, this is trash code.  
Yes, this isn't even funny.  
Yes, this is a bucket of cringe.  
Why do this? WYNAUT?

## Usage
* Create the executable with `make` or `nasm`(elf64 format) and a linker.
* Execute it as `./z.out [number of elements in the list]`
* The program will prompt you to enter the values of nodes in the list

## Notes
* If you haven't started making paper planes out of offer letters yet, oh well, there's nothing left here. Why haven't you started building your own cryptocurrency already, huh?  
* This one is also an attempt at better code organization (better, not good) so `utils.asm` contains generic code that is used multiple times (for the most part) while `reverselinkedlist.asm` contains the "main" code. Have fun!  
### Space/Time complexity
Really? What are you running this on? A lunar rover? Anyways, here ya go:
* Time : O(ok) wrt the number of elements in the linked list.
* Space: O(yeah) above the space already occupied by the linked list.
