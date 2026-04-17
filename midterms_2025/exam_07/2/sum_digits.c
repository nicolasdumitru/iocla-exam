void sum_digits(int *n) {
    int val = *n;
    if (val < 0) val = -val;
    int sum = 0;
    while (val > 0) {
        sum += val % 10;
        val /= 10;
    }
    *n = sum;
}
