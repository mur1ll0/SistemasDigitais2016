#include <stdio.h>
#include <stdlib.h>
#include <time.h>


int main()
{
    srand(time(NULL));

    int p1x, p1y, p2x, p2y, p3x, p3y, Px, Py, i;

    FILE *triangles = fopen("TrianglePoints.txt", "w");
    FILE *points = fopen("TestPoints.txt", "w");

    if (triangles == NULL || points == NULL)
        perror("Erro ao abrir arquivo Clientes.\n");
    else{
        for (i=0; i<40; i++){
            p1x = rand() % 640;
            p2x = rand() % 640;
            p3x = rand() % 640;

            p1y = rand() % 480;
            p2y = rand() % 480;
            p3y = rand() % 480;
            fprintf(triangles, "%d %d %d %d %d %d\n", p1x, p1y, p2x, p2y, p3x, p3y);
        }

        for (i=0; i<100; i++){
            Px = rand() % 640;
            Py = rand() % 480;
            fprintf(points, "%d %d\n", Px, Py);
        }
    }


    fclose(triangles);
    fclose(points);

    return 0;
}
