#include <stdio.h>
#include <stdlib.h>


int main()
{
    int outC, outV;
    char xis;

    FILE *cOut = fopen("Out.txt", "r");
    FILE *vOut = fopen("VerilogOut.txt", "r");

    if (cOut == NULL || vOut == NULL){
        printf("Erro ao abrir arquivo.");
        return 0;
    }

    while ((fscanf(vOut, "%d\n", &outV) != EOF)&& (fscanf(cOut, "%d\n", &outC) != EOF)){
        if (outC != outV){
            printf("\nSaidas diferentes\n%d %d\n", outC, outV);
            return 0;
        }
    }
    printf("\nSaidas Iguais\n");

    fclose(vOut);
    fclose(cOut);

    return 0;
}
