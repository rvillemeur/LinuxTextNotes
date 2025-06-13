# Fichier d'Entrée-sortie-erreur

## Descripteur de fichier - file descriptor

File descriptors are a part of the POSIX API. Each Unix process (except perhaps 
daemons) should have three standard POSIX file descriptors, corresponding to the 
three standard streams:

|file descriptor value| name | unistd.h constant| stdio.h file stream|
|---------------------|------|------------------|--------------------|
| 0                   |input | STDIN_FILENO     | stdin              |
| 1                   |output| STDOUT_FILENO    | stdout             |
| 2                   |error | STDERR_FILENO    | stderr             |

In the traditional implementation of Unix, file descriptors index into a 
per-process file descriptor table maintained by the kernel, that in turn indexes 
into a system-wide table of files opened by all processes, called the file 
table. This table records the mode with which the file (or other resource) has 
been opened: for reading, writing, appending, and possibly other modes. It also 
indexes into a third table called the inode table that describes the actual 
underlying files.[3] To perform input or output, the process passes the file 
descriptor to the kernel through a system call, and the kernel will access the 
file on behalf of the process. The process does not have direct access to the 
file or inode tables.


For processes, every process has its own set of file descriptors that are unique 
to it, a small non-negative number (not file handles, which is a concept of C).

However, these file descriptors all point to entries in a shared pool (inside 
the kernel, for example). This allows all processes to have their own standard 
input, output and error (descriptors 0, 1 and 2) but with the possibility they 
may refer to the same "backing file".

```txt
Individual processes          Shared pool
          +------+            +------------------+
Process A | fd 1 | ----+----> | maps to /dev/tty |
          +------+     |      +------------------+
Process B | fd 1 | ----+
          +------+            +------------------+
Process C | fd 1 | ---------> | maps to new file |
          +------+            +------------------+
```

NOTE: Un stream est un buffer qu'on peut accéder en lecture, écriture, ou 
lecture/écriture.


**NOTE** By convention in UNIX and Linux, data streams and peripherals (device 
files) are treated as files, in a fashion analogous to ordinary files.

A file descriptor is simply a number that the operating system assigns to an 
open file to keep track of it. Consider it a simplified type of file pointer. It 
is analogous to a file handle in C.

## fichier en bash

Chaque processus bash, du fait de la norme, détient un accès vers chacun de ses 
fichiers:
- stdin  => par défaut le clavier
- stdout => par défaut, l'écran du terminal
- stderr => par défaut, l'écran du terminal

Il est possible de redéfinir les fichiers utiliser à l'aide des opérateur
- stdin => `<`
- stdout => `>` pour écraser le fichier, `>>` pour ajouter à la fin du fichier
- stderr => `2>`

On peut aussi rediriger un flux vers un autres. `2>&1` redirige le flux du 
descripteur de fichier 2 (stderr) vers le descripteur de fichier 1 (stdout)

File descriptors 0, 1 and 2 are for stdin, stdout and stderr respectively.

File descriptors 3, 4, .. 9 are for additional files. In order to use them, you 
need to open them first. For example:

```bash
exec 3<> /tmp/foo  #open fd 3.
echo "test" >&3
exec 3>&- #close fd 3.
```

## accéder à stdin en langage C

```c
#include <stdio.h>  /* accès à la fonction read */
#include <unistd.h> /* requis pour la constante STDIN_FILENO*/

/* pour lire 10 bytes */
char buffer[10];
read(STDIN_FILENO, buffer, 10);

/* pour lire 1 byte à la fois */
char ch;
while(read(STDIN_FILENO, &ch, 1) > 0)
{
 //do stuff
}

/* pour lire 128 byte ou char */
char buf[128];
read(STDIN_FILENO, buf, sizeof(buf));

/* pour écrire sur stdout */
const char *s = "Hello World!\n";
write(STDOUT_FILENO, s, strlen(s));
```

En pratique, pour lire du texte sur les interfaces standard d'entrée/sortie, il 
vaut mieux utiliser `scanf`, `fscanf` et `printf`.

```c
#include <stdio.h>
int main()
{
    int a;
    scanf("This is the value %d", &a);
    printf("Input value read : a = %d", a);
    return 0;
}

/* input "blablabla 25 */
#include <stdio.h>
int main()
{
    int a;
    scanf("%*s %d", &a);
    printf("Input value read : a=%d", a);
    return 0;
}

// C Program to demonstrate fscanf
#include <stdio.h>

// Driver Code
int main()
{
    FILE* ptr = fopen("abc.txt", "r");
    if (ptr == NULL) {
        printf("no such file.");
        return 0;
    }

    /* Assuming that abc.txt has content in below
       format
       NAME    AGE   CITY
       abc     12    hyderabad
       bef     25    delhi
       cce     65    bangalore */
    char buf[100];
    while (fscanf(ptr, "%*s %*s %s ", buf) == 1)
        printf("%s\n", buf);

    return 0;
}
```
Pour lire un fichier binaire:

```c

#include <stdio.h>
#include <stdlib.h>

struct threeNum{
    int n1, n2, n3;
};

int main(){
    int n;
    struct threeNum num;
    FILE *fptr;
    if ((fptr = fopen("program.bin","rb")) == NULL){
        printf("Error! opening file");
         // Program exits if the file pointer returns NULL.
         exit(1);
         }
     for(n = 1; n < 5; ++n){
         fread(&num, sizeof(struct threeNum), 1, fptr);
         printf("n1: %d\tn2: %d\tn3: %d", num.n1, num.n2, num.n3);
     }
     fclose(fptr);
     return 0;
}
```

## source

[wikipedia file descriptor](https://en.wikipedia.org/wiki/File_descriptor)
[posix process and file 
descriptor](https://stackoverflow.com/questions/17100425/posix-process-and-file-descriptors)
[read and write in C](https://stackoverflow.com/questions/14635827/use-read-to-take-user-input-instead-of-scanf)
[scanf et fscanf en C](https://www.geeksforgeeks.org/c/scanf-and-fscanf-in-c/)
[cheatsheet sécurité en C](https://www.codecademy.com/learn/secure-coding-practices-in-c/modules/secure-coding-practices-c/cheatsheet)
[bash redirection](https://www.gnu.org/software/bash/manual/html_node/Redirections.html)
[How file descriptor works](https://stackoverflow.com/questions/7082001/how-do-file-descriptors-work)
[I&O redirection](https://tldp.org/LDP/abs/html/io-redirection.html)
