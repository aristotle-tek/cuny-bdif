# include <cstdlib>
# include "mpi.h"
using namespace std;

int main ( int argc, char *argv[] )
{
	int id;
	int worldsize;

	MPI::Init ( argc, argv );

	worldsize = MPI::COMM_WORLD.Get_size ( );

	id = MPI::COMM_WORLD.Get_rank ( );

	if ( id == 0 ) 
	{
	 cout << "This will only be printed by process 0.\n";
	 cout << "The number of processes involved is: " << worldsize << "\n";
	 cout << "\n";
	}

	cout << "Hello from process " << id << ". \n";

	MPI::Finalize ( );

	return 0;
}

