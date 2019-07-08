#include<stdio.h>
#include<sys/types.h>
#include<sys/stat.h>
#include<string.h>
#include<sys/socket.h>
#include<unistd.h>
#include<stdlib.h>
#include<pthread.h>
#include<arpa/inet.h>
#include<netinet/in.h>
#include<time.h>
#include<pthread.h>
#define PORT 8888
#define length 40
#define width 100
int map[length][width];
int seedx=0, seedy=0;
const int forwardx[4] = { 0,1,0,-1 };
const int forwardy[4] = { 1,0,-1,0 };
void init()
{
	memset(map, 0, sizeof(map));
	int i;
	for (i = 0; i < length; i++)
	{
		map[i][1] = 1;
		map[i][width-1] = 1;
	}
	for (i = 0; i < width; i++)
	{
		map[length-1][i] = 1;
		map[1][i] = 1;
	}
	printf("\033[2J");
}
void print()
{
	
}
void generate(int *x,int *y)
{
	srand((int)time(0));
	*x = 4 + rand() % (length - 10);
	*y = 4 + rand() % (width - 10);
	while (map[*x][*y] != 0)
	{
		*x = 4 + rand() % (length - 10);
		*y = 4 + rand() % (width - 10);
	}
}
int make_server_socket(int port)
{
	int sock_id;
	struct sockaddr_in server;
	sock_id = socket(AF_INET, SOCK_STREAM, 0);
	if (sock_id == -1)
	{
		perror("creating socket failed");
		return -1;
	}
	int opt = SO_REUSEADDR;
	setsockopt(sock_id, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt));
	bzero(&server, sizeof(server));
	server.sin_family = AF_INET;
	server.sin_port = htons(port);
	server.sin_addr.s_addr = htonl(INADDR_ANY);
	if (bind(sock_id, (struct sockaddr *)&server, sizeof(struct sockaddr)) == -1)
	{
		perror("bind error");
		return -1;
	}
	if (listen(sock_id, 5) == -1)
	{
		perror("listen error");
		return -1;
	}
	return sock_id;
}
void game(int fd)
{
	int bodyx[100], bodyy[100];
	int headx = 0, heady = 0, h = 0, t = 0, dir, i, score = 0;
	srand((int)time(0));
	dir = rand() % 4;
	generate(&headx, &heady);
	for (i = 0; i < 5; i++)
	{
		t++;
		headx += forwardx[dir];
		heady += forwardy[dir];
		bodyx[i] = headx;
		bodyy[i] = heady;
		map[headx][heady] = 1;
		printf("\033[%d;%dH*", headx, heady);
		fflush(stdout);
	}
	FILE *f;
	f = fdopen(fd, "r");
	char c;
	while (1)
	{
		c = fgetc(f);
		fflush(stdout);
		if (c != 'l' && c != 'r' && c != 'w') continue;
		switch (c)
		{
		case 'r':
		{
			dir++;
			if (dir == 4)dir = 0;
			break;
		}
		case 'l':
		{
			dir--;
			if (dir == -1)dir = 3;
			break;
		}
		default:
			break;
		}
		headx += forwardx[dir]; heady += forwardy[dir];
		//printf("\033[41;1H %d %d %d", headx, heady,map[headx][heady]); fflush(stdout);
		if (map[headx][heady] == 1)
		{
			for (i = h; i <=t-1; i++)
			{
				map[bodyx[i]][bodyy[i]] = 0;
				printf("\033[%d;%dH ", bodyx[i], bodyy[i]);
				fflush(stdout);
			}
			close(fd);
			return;
		}
		bodyx[t] = headx; bodyy[t] = heady;
		map[bodyx[t]][bodyy[t]] = 1;
		fflush(stdout);
		printf("\033[%d;%dH*", headx, heady);
		t++; if (t == 100) t = 0;
		if (headx == seedx && heady == seedy)
		{
			score++;
			generate(&seedx, &seedy);
			printf("\033[%d;%dH*", seedx, seedy); fflush(stdout);
			continue;
		}
		else {
			printf("\033[%d;%dH ", bodyx[h], bodyy[h]);
			fflush(stdout);
			map[bodyx[h]][bodyy[h]] = 0;
			h++; if (h == 100) h = 0;
		}
	}
}
int main() 
{
	int socket, fd;
	init();
	int i, j;
	for (i = 1; i < length; i++)
	{
		for (j = 1; j < width; j++)
		{
			if (map[i][j])printf("*");
			else printf(" ");
		}
		printf("\n");
	}
	fflush(stdout);
	generate(&seedx, &seedy);
	printf("\033[%d;%dH*", seedx, seedy); fflush(stdout);
	if ((socket = make_server_socket(PORT))==-1)
	{
		printf("cannot open socket");
		exit(0);
	}
	while (1)
	{
		fd = accept(socket, NULL, NULL);
		pthread_create((pthread_t *)malloc(sizeof(pthread_t)), NULL, game, fd);
	}
	return 0;
}