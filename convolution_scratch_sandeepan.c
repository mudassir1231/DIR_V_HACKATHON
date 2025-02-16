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


// computing matrix multiplication of 1x4 weight with 4x1 input matrix
int compute_matrix_multiplication( int8_t inp_mat[4][1], int8_t weight_matrix[1][4]){
     long int result_val = 0;
        for(int idx = 0; idx < 4; ++idx){
                result_val += weight_matrix[1][idx] * inp_mat[idx][1];
        //      printf("Input: %d \t Weight: %d \t Result of the computation is %ld \n ",inp_mat[1][idx], weight_matrix[1][idx], result_val);
    }
        return result_val;
}

//function to pass values sequentially . Assumes  a 2x2 kernel and a 8x8 matrix . After flattening, the image matrix becomes 64x1 and flattening across the rows, weight matrix becomes 1x4
 int pass_values(int8_t matrix[64][1], int init, int limit, int8_t out_mat[4][1]){
        for(size_t iter = init ; iter <= limit; ++iter){
                out_mat[iter][1] = matrix[iter][1];
        }

 }

//function to add the values obtained from the matrix multiplication as post-processing

int post_process(int8_t res[16], int bias){
        long int accumulate =0;
        for(size_t s_a = 0; s_a < 16; ++s_a){
                accumulate+= res[s_a];
        }
        return accumulate + bias;
}

int main() {

        return 0;
}
                          
