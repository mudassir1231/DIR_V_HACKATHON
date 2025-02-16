 /*int pass_values(int8_t matrix[64][1], int8_t weights[1][8], int8_t reslt[8]){
        // for(size_t s_1 = 0; s_1 < 4; ++s_1){
        //       for(size_t s_2 = 0; s_2 < 64; ++s_2){
        //               if(s_2 %  == ){
         reslt[0] = compute_matrix_multiplication(matrix[0..7][1], weights[1][8]);
         reslt[1] = compute_matrix_multiplication(matrix[8..15][1], weights[1][8]);
         reslt[2] = compute_matrix_multiplication(matrix[16..23][1], weights[1][8]);
         reslt[3] = compute_matrix_multiplication(matrix[24..31][1], weights[1][8]);
         reslt[0] = compute_matrix_multiplication(matrix[32..39][1], weights[1][8]);
         reslt[1] = compute_matrix_multiplication(matrix[40..47][1], weights[1][8]);
         reslt[2] = compute_matrix_multiplication(matrix[48..55][1], weights[1][8]);
         reslt[3] = compute_matrix_multiplication(matrix[56..63][1], weights[1][8]);

 }*/

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
    //printf("Content at tranposed matrix %d", trans_mat[1][1]);
    //  for(int k = 0; k < 8; ++k){
      //        printf("Contents of the input matrix %d \n", trans_mat[1][k]);
        // }
        //int8_t sample[1][8] = {{1,2,3,4,5,6,7,8}};
        //row_transpose(sample, sm);

        res = (long int)compute_matrix_multiplication(sm, sample);
        printf("Result %ld \t", res);
    return 0;
