# Dynamic Location Metadata Generator
# ---
# Automatically generates the locations metadata by going through all Plauscherl pages
# and extracting the "oldmap" locations for the pins. It also counts how often a Plauscherl
# was at a certain location and provides the information accordingly.
# Locations with the same coordinations will not be merged.

module Jekyll
  # This generator runs before other generators
  class LocationDataGenerator < Generator
    safe true
    priority :highest

    def generate(site)
      location_counts = {}
      location_coords = {}
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

        # Count occurrences of each location
        if location_counts.key?(location_name)
          location_counts[location_name] += 1
        else
          location_counts[location_name] = 1
          location_coords[location_name] = coordinates
        end
        
        processed_count += 1
      end

      # Log processing results (visible in build output)
      puts "LocationDataGenerator: Processed #{processed_count} plauscherl events, found #{location_counts.size} unique locations"

      # Generate the locations array with coordinate format as expected by OpenLayer
      locations = location_counts.map do |name, count|
        {
          'name' => name,
          'count' => count,
          'coordinates' => location_coords[name]
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