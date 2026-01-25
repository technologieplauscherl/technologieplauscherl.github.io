# Dynamic Location Metadata Generator
# ---
# Automatically generates the locations metadata by going through all Plauscherl pages
# and extracting the "oldmap" locations for the pins. It also counts how often a Plauscherl
# was at a certain location and provides the information accordingly.
# Locations with the same coordinates will be merged and their counts combined.

module Jekyll
  # This generator runs before other generators
  class LocationDataGenerator < Generator
    safe true
    priority :highest

    def generate(site)
      location_data_by_coords = {}
      processed_count = 0

      # Go through all files in "_plauscherl"
      site.collections['plauscherl'].docs.each do |doc|
        # Skip if no location data is present
        location_data = doc.data['location']
        unless location_data && location_data['oldmap']
          puts "LocationDataGenerator: Skipping #{doc.data['title']} (#{doc.basename}) - missing location or oldmap data"
          next
        end

        location_name = location_data['name']
        coordinates = [
          location_data['oldmap']['lng'],
          location_data['oldmap']['lat']
        ]
        coord_key = "#{coordinates[0]},#{coordinates[1]}"

        # Group by coordinates, merge locations at the same place
        if location_data_by_coords.key?(coord_key)
          location_info = location_data_by_coords[coord_key]
          location_info[:count] += 1
          
          # Add unique location names
          unless location_info[:names].include?(location_name)
            location_info[:names] << location_name
          end
        else
          location_data_by_coords[coord_key] = {
            count: 1,
            names: [location_name],
            coordinates: coordinates
          }
        end
        
        processed_count += 1
      end

      puts "LocationDataGenerator: Processed #{processed_count} plauscherl events, found #{location_data_by_coords.size} unique coordinate locations"

      # Generate the locations array
      locations = location_data_by_coords.map do |_, location_info|
        display_name = if location_info[:names].length == 1
          location_info[:names].first
        else 
           location_info[:names].sort.join(' / ')
        end

        {
          'name' => display_name,
          'count' => location_info[:count],
          'coordinates' => location_info[:coordinates],
          'all_names' => location_info[:names].sort
        }
      end

      # Sort by count (descending) and then by name (ascending)
      locations.sort! { |a, b| [b['count'], a['name']] <=> [a['count'], b['name']] }

      # Store generated location in site's data.generated_metadata
      site.data["generated_metadata"] ||= {}
      site.data["generated_metadata"].merge!({
        "locations" => locations
      })
    end
  end
end