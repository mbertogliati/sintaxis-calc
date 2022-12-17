CC = gcc
YACC = bison
LEX = flex
CFLAGS = -g -Wall
LINK_FLAGS = -lfl -lm
OBJECTS = main.o calc.o parser.o scanner.o
HEADERS = parser.h scanner.h calc.h
FLEX_BISON_SRC = parser.c scanner.c parser.h scanner.h
TARGET = calculadora.out

all: $(TARGET)

$(TARGET): $(OBJECTS)
	$(CC) -o $(TARGET) $(OBJECTS) $(LINK_FLAGS) 

main.o: main.c calc.c parser.c scanner.c
	$(CC) $(CFLAGS) -c main.c calc.c parser.c scanner.c

parser.c: parser.y
	bison $<

scanner.c : scanner.l
	flex $<


clean:
	rm -f $(TARGET) $(OBJECTS) $(FLEX_BISON_SRC)
