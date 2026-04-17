# Function pointer casting
General syntax:
```C
(return_type (*)(parameter_types)) function pointer
```
Example:
```C
void b(void *f) {
    // TODO b: Cast f to a function that has its signature char *f(int a, int b).
    // Call f with random1 and random2 as parameters.
    // Print the result. 
    char *s = ((char *(*)(int, int))f)(random1, random2);
    printf("%s", s);
}
```