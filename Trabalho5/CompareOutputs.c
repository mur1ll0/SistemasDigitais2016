#include <stdio.h>
#include <stdlib.h>


int main()
{
    int outC, outV, contador;
    char xis;

    FILE *cOut = fopen("Out.txt", "r");
    FILE *vOut = fopen("VerilogOut.txt", "r");

    if (cOut == NULL || vOut == NULL){
        printf("Erro ao abrir arquivo.");
        return 0;
    }

    contador = 1;
    while ((fscanf(vOut, "%d\n", &outV) != EOF)&& (fscanf(cOut, "%d\n", &outC) != EOF)){
        if (outC != outV){
            printf("\nLinha %d\nSaidas diferentes\n%d %d\n", contador, outC, outV);
            return 0;
        }
        contador++;
    }
    printf("\nSaidas Iguais\n");

    fclose(vOut);
    fclose(cOut);
    
    getchar();

    return 0;
}
