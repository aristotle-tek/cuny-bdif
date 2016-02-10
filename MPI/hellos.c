#include <stdio.h>
#include <mpi.h>


int main(int argc, char **argv)
{
	int id;
	int worldsize;
	MPI_Init (&argc, &argv);	/* starts MPI */
	MPI_Comm_rank (MPI_COMM_WORLD, &id);
	MPI_Comm_size (MPI_COMM_WORLD, &worldsize);

	if ( id == 0 )
	{
		printf("This will only be printed by process 0.\n");
	}

	printf( "Hello from process %d of %d\n", id, worldsize);
	MPI_Finalize();
	return 0;
}