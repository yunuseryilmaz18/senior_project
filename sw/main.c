
#include "api.h"
#include "ascon.h"
#include "permutations.h"

int main ()
{
  int result;
  int alen = 0;
  int mlen = 0;
  int clen = 0;

  unsigned char a[] = "thisistheassociateddata.";
  unsigned char m[] = "thisisaplaintext";
  unsigned char c[16 + CRYPTO_ABYTES];
  unsigned char nsec[CRYPTO_NSECBYTES];
  unsigned char npub[CRYPTO_NPUBBYTES] = {"thisisthenonce."};
  unsigned char k[CRYPTO_KEYBYTES] = "thisisthekey.";   

  alen = 24;
  mlen = 16;
  clen = 0;

  result |= crypto_aead_encrypt(c, &clen, m, mlen, a, alen, nsec, npub, k);
  
  result |= crypto_aead_decrypt(m, &mlen, nsec, c, clen, a, alen, npub, k);
  
  return 0;
}