# Night Moves

Welcome to the NightMoves Beer Manager. This application will manage the beer menu at your frinedly local bar.

It's based on a REST API backend with a (coming) fronend client. It's a work in progress though.

## Installation

NightMoves is a Perl based application, some experience with Perl is useful. If you need help at any step of this process
join `#perl-help` on irc.perl.org and ask.

You must be using Perl 5.24.0 or higher to run NightMoves. To get started make sure that `carton` is installed
on your local system. Clone the repostiory and run `carton install` in the root directory. This will download
all the dependencies.

Next run `carton exec plackup` to start the development server.

## REST API
To add a beer simply POST a new beer description.

    POST /beer
        {
            "name" : "Beer Name",  # required
            "tap_id" : "tap ID",
            "style" : "Beer Style",
            "IBU" : "IBU",
            "SRM" : "SRM"
            "brewery" : "brewery name"
        }

To retrieve a specific beer

    GET /beer/:id
		{
			"_links" : {},
			"SRM" : null,
			"name" : "Bud Light",
			"id" : 2,
			"IBU" : null,
			"brewery" : null,
			"tap_id" : 2,
			"style" : null
		}

To get back a list of *all* the beers

    GET /beer
		{
			"_links" : {}
			"embedded" : [
			{
				"tap_id" : 1,
				"style" : null,
				"id" : 1,
				"IBU" : null,
				"brewery" : null,
				"SRM" : null,
				"name" : "Negro Modelo"
			},
			{
				"style" : null,
				"tap_id" : 2,
				"SRM" : null,
				"name" : "Miller Lite",
				"id" : 2,
				"IBU" : null,
				"brewery" : null
			}
			],
		}

To update a specific Beer's information

    PUT /beer/2
		{
			"style" : "Pilsner",
			"tap_id" : 2,
			"SRM" : 2.0,
			"name" : "Miller Light",
			"IBU" : 10,
			"brewery" : "Miller Brewing Company"
		}


