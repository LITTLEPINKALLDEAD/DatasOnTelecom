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
int file_not_exist(char* uri)
{
	struct stat file;
	return (stat(uri, &file) == -1);
}
void not_found_404(char* uri, int fd)
{
	FILE *fp = fdopen(fd, "w");
	fprintf(fp, "HTTP/1.0 404 Not Found\r\n");
	fprintf(fp, "Content-type:text/plain\r\n");
	fprintf(fp, "Content-length:%d\r\n", 0);
	fprintf(fp, "\r\n\r\n");
	fclose(fp);
}
void bad_request(int fd)
{
	FILE *fp = fdopen(fd, "w");
	fprintf(fp, "HTTP/1.0 400 Bad Request\r\n");
	fprintf(fp, "Content-type:text/plain\r\n");
	fprintf(fp, "Content-length:%d\r\n",0);
	fprintf(fp, "\r\n\r\n");
	fclose(fp);
}
char * file_type(char *f)
{
	char *token;
	if ((token = strrchr(f, '.')) != NULL)
		return token + 1;
	return "";
}
void browse(char *uri, int fd)
{
	FILE *f, *fp;
	char c; 
	struct stat file;
	stat(uri, &file);
	char *type = file_type(uri); 
	char*content = "text/plain";
	if (strcmp(type, "html") == 0) 
		content = "text/html"; 
	else if(strcmp(type, "gif") == 0) 
		content = "image/gif"; 
	else if(strcmp(type, "jpg") == 0) 
		content = "image/jpeg"; 
	else if(strcmp(type, "jpeg") == 0) 
		content = "image/jpeg";
	fp = fdopen(fd, "w");
	f = fopen(uri, "r");
	fprintf(fp, "HTTP/1.0 200 OK\r\n");
	fprintf(fp, "Content-type:%s\r\n",content);
	fprintf(fp, "Content-length:%d\r\n", file.st_size);
	fprintf(fp, "\r\n\r\n");
	if (fp != NULL && f != NULL)
	{
		while ((c = getc(f)) != EOF)
			putc(c, fp);
		fclose(f);
		fclose(fp);
	}
	exit(0);
}
void process(char* request, int fd)
{
	char cmd[BUFSIZ], uri[BUFSIZ],tmp[BUFSIZ]; 
	sscanf(request, "%s%s", cmd, tmp);
	strcpy(uri, tmp+1);
	if (fork() != 0)return;
	if (strcmp(cmd, "GET") != 0)
		bad_request(fd);
	else if (file_not_exist(uri))
		not_found_404(uri, fd);
	else browse(uri, fd);
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
int main(int ac, char* argv[])
{
	int socket, fd;
	FILE *f;
	char request[BUFSIZ];
	if (ac == 1) 
	{
		fprintf(stderr, "usage:ws portnum\r\n");
		exit(1);
	}
	socket = make_server_socket(atoi(argv[1]));
	if (socket == -1)exit(2);
	while (1)
	{
		fd = accept(socket, NULL, NULL);
		f = fdopen(fd, "r");
		fgets(request, BUFSIZ, f);
		printf("get request=%s", request);
		char buffer[BUFSIZ];
		while (fgets(buffer, BUFSIZ, f) != NULL && strcmp(buffer, "\r\n") != 0);
		process(request, fd);
		fclose(f);
	}
	return 0;
}