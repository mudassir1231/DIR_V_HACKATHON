#include <stdio.h>
#include <stdint.h>

//transpose from a column to row matrix

int row_transpose(int8_t mat[1][8], int8_t result_mat[8]){
        for(int x = 0; x < 8; ++x){
                result_mat[x] = mat[1][x];
        //      printf("Computed row transpose %d \n", result_mat[x]);
        }
}

//compute the transpose of  weight matrix
int transpose_matrix(int8_t matrix[8], int8_t transposed_matrix[1][8]){
    //int ind = 0;
    for(int s = 0; s < 8; ++s){
        transposed_matrix[1][s] = matrix[s];
       // printf("Transposed matrix %d \n", transposed_matrix[1][s]);
    }
}

// Function to lower the tensor (flatten the matrix) --should be flattened column wise for matrix multiplication
//Step 1 -> Weight matrix is flattened
//Step 2-> Input matrix is flattened
//Step 3 -> Weight Matrix is computed for matrix multiplication
//Step 4 -> Add the values received through multipplication and add bias as preprocessing

//to be parametrized for any computation. Currently hard-coded for initial implementation

int lowerTensor(int num_rows, int num_cols, int input[num_rows][num_cols], int flattened[num_rows*num_cols][1]) {
    int index = 0;
    for (int i = 0; i <= (num_rows-1); ++i) {
        for (int j = 0; j <= (num_cols-1); ++j) {
            flattened[index++][1] = input[i][j]; //storing the elements accessed row wise in one column
        }
    }
}      

//function to compute the flattening of weight matrix

int flatten_row(int weights[2][2], int flat_matrix[4]){

        int id = 0;
        for(int c = 0; c <2; ++c){
                for(int c_1 = 0; c_1 <2; ++c_1){
                       flat_matrix[id++] = weights[c][c_1];
                }
        }
}

// computing matrix multiplication of 1x8 weight with 8x1 input matrix
int compute_matrix_multiplication( int8_t inp_mat[8][1], int8_t weight_matrix[1][8]){
     long int result_val = 0;
        for(int idx = 0; idx < 8; ++idx){
                result_val += weight_matrix[1][idx] * inp_mat[idx][1];
                printf("Input: %d \t Weight: %d \t Result of the computation is %ld \n ",inp_mat[1][idx], weight_matrix[1][idx], result_val);
    }                                                                                                                                                   return result_val;                                                                                                                      }                                                                                                                                                                                                                                                                                               //function to pass values sequentially . Assumes  a 2x2 kernel and a 8x8 matrix . After flattening, the image matrix becomes 64x1 and flattening across the rows, weight matrix becomes 1x4
 int pass_values(int8_t matrix[64][1], int8_t weights[1][8], int init, int limit, int8_t out_mat[8][1]){
        for(size_t iter = init ; iter <= limit; ++iter){
                out_mat[iter][1] = matrix[iter][1];
        }

 }

int main() {
    // Write C code here

        int8_t mat[8] = {1,122,100,127,28,204,32,27};
        int8_t trans_mat[1][8];
        int8_t row_trans[8];
        int8_t row_trans_1[1][8];
        int8_t sm[8][1] = {{1},{2},{3},{4},{5},{6},{7},{8}};
        transpose_matrix(mat, trans_mat);
        int8_t sample[1][8] = {{1,2,3,4,5,6,7,8}};

        long int res;
        int8_t out_mat_1[8][1];

        long int reslt[8];
        int8_t hh[64][1];

        pass_values(hh, sample, 0, 15, out_mat_1);
        reslt[0] = compute_matrix_multiplication(out_mat_1, sample);
        pass_values(hh, sample, 16, 23, out_mat_1);
        reslt[1] = compute_matrix_multiplication(out_mat_1, sample);
        pass_values(hh, sample, 24, 31, out_mat_1);
        reslt[2] = compute_matrix_multiplication(out_mat_1, sample);
        pass_values(hh, sample, 32, 47, out_mat_1);
        reslt[3] = compute_matrix_multiplication(out_mat_1, sample);
        pass_values(hh, sample, 48, 55, out_mat_1);
        reslt[4] = compute_matrix_multiplication(out_mat_1, sample);
        pass_values(hh, sample, 56, 63, out_mat_1);
        reslt[5] = compute_matrix_multiplication(out_mat_1, sample);


        res = compute_matrix_multiplication(sm, sample);
        printf("Result %ld \t", res);
        return 0;
}
