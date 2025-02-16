#include <stdio.h>
#include <stdint.h>

//Assumptions : Kernel or weights : 2x2 matrix
//Input or image matrix : 8x8
//

//flatten the kernel matrix into a row matrix ..2x2 to 1x4 matrix

int row_transpose(int8_t mat[2][2], int8_t result_mat[1][4]){
        int id_y = 0;
        for(int x = 0; x < 2; ++x){
                for(int x_1 = 0; x_1 < 2 ; ++x_1){
                        result_mat[1][id_y++] = mat[x][x_1];
                //      printf("Computed row transpose %d \n", result_mat[x][x_1); //uncomment to verify the functionality
                        }
        }
}


// Function to lower the tensor (flatten the matrix) --should be flattened column wise for matrix multiplication
//Step 1 -> Weight matrix is flattened
//Step 2-> Input matrix is flattened
//Step 3 -> Weight Matrix is computed for matrix multiplication
//Step 4 -> Add the values received through multipplication and add bias as preprocessing

//function to flatten the image matrix in column order for matrix multiplication
//8x8 t 1x64
int lowerTensor(int num_rows, int num_cols, int input[num_rows][num_cols], int flattened[num_rows*num_cols][1]) {
    int index = 0;
    for (int i = 0; i <= (num_rows-1); ++i) {
        for (int j = 0; j <= (num_cols-1); ++j) {
            flattened[index++][1] = input[i][j]; //storing the elements accessed in one column
        }
    }
}
