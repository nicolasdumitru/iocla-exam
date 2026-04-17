#include <stdio.h>
#include <string.h>

struct info {
    int month, day;
    char *location;
} __attribute__((packed));

void broadcast(struct info *info) {
    printf("Location: %s\n", info->location);
    printf("Date: %d/%d\n", info->day, info->month);
    
    if (strcmp(info->location, "Ardhalis") == 0) {
        printf("Message type and location are correct! Don't forget to check if the month/day match the keyboard input.\n");
    } else {
        printf("Message location are incorrect!\n");
    }
}
