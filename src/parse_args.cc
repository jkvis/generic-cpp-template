#include "../include/parse_args.h"
#include "../include/version.h"

#include <getopt.h>
#include <cstdio>
#include <cstdlib>


static char const* const   short_options  = "hv";
static struct option const long_options[] =
{
    {"help",    no_argument, 0, 'h'},
    {"version", no_argument, 0, 'v'},

    // this should be the last entry
    {0, 0, 0, 0}
}; // long_opts


static char const* command = 0;


void usage(void)
{
    fprintf(stderr, "usage: %s [options]\n  options:\n", command);

    int index = 0;
    while (long_options[index].name != 0)
    {
        fprintf(stderr, "    --%s\n", long_options[index].name);
        ++index;
    } // while
} // usage


void parse_args(int const argc, char* const argv[])
{
    command = argv[0];

    while (true)
    {
        int index = 0;
        int const option = getopt_long(argc,
                                       argv,
                                       short_options,
                                       long_options,
                                      &index);

        if (option == -1)
        {
            break;
        } // if

        switch (option)
        {
            case 0:
                if (long_options[index].flag != 0)
                {
                    break;
                } // if
                fprintf(stderr, "option %s", long_options[index].name);
                if (optarg != 0)
                {
                    fprintf(stderr, " with arg %s", optarg);
                } // if
                fprintf(stderr, "\n");
                break;

            case 'h':
                usage();
                break;

            case 'v':
                fprintf(stderr, "%s version %d.%d\n", NAME,
                                                      MAJOR_VERSION,
                                                      MINOR_VERSION);
                break;

            case '?':
                // getopt printed an error
                break;

            default:
                fprintf(stderr, "%s: getopt_long() error\n", command);
                abort();
        } // switch
    } // while

    // remaining command line arguments (not options)
    if (optind < argc)
    {
        while (optind < argc)
        {
            fprintf(stderr, "argument %s\n", argv[optind]);
            ++optind;
        } // while
    } // if
} // parse_args

