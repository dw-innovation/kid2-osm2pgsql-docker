-- define empty tables
local tables = {}

-- define nodes table
tables.nodes = osm2pgsql.define_node_table('nodes', {{
    column = 'tags',
    type = 'jsonb'
}, {
    column = 'geom',
    type = 'point',
    projection = 4326
}})

-- define ways table
tables.ways = osm2pgsql.define_way_table('ways', {{
    column = 'tags',
    type = 'jsonb'
}, {
    column = 'geom',
    type = 'geometry',
    projection = 4326
}})

-- define relations table
tables.relations = osm2pgsql.define_relation_table('relations', {{
    column = 'tags',
    type = 'jsonb'
}, {
    column = 'geom',
    type = 'geometry',
    projection = 4326
}})

tables.boundaries = osm2pgsql.define_area_table('boundaries', {{
    column = 'tags',
    type = 'jsonb'
}, {
    column = 'geom',
    type = 'geometry',
    projection = 4326
}})

-- define function to load allowed tags from a file
local function load_allowed_tags(filename)
    local allowed_tags = {}
    for line in io.lines(filename) do
        allowed_tags[line] = true
    end
    return allowed_tags
end

-- define allowed tags
local allowed_tags = load_allowed_tags("/data/allowed_tags.txt")

-- define function to filter tags
local function filter_tags(tags)
    local filtered = {}
    local has_allowed_tag = false
    for k, v in pairs(tags) do
        if allowed_tags[k] then
            filtered[k] = v
            has_allowed_tag = true
        end
    end
    return filtered, has_allowed_tag
end

-- process function for nodes
function osm2pgsql.process_node(object)
    local filtered_tags, has_allowed_tag = filter_tags(object.tags)
    if has_allowed_tag then
        tables.nodes:add_row{
            tags = filtered_tags,
            geom = {
                create = 'point'
            }
        }
    end
end

-- process function for ways
function osm2pgsql.process_way(object)
    local filtered_tags, has_allowed_tag = filter_tags(object.tags)
    if has_allowed_tag then
        tables.ways:add_row{
            tags = filtered_tags,
            geom = {
                create = 'area'
            }
        }
    end
end

-- process function for relations
function osm2pgsql.process_relation(object)
    local filtered_tags, has_allowed_tag = filter_tags(object.tags)
    if has_allowed_tag then
        tables.relations:add_row{
            tags = filtered_tags,
            geom = {
                create = 'area'
            }
        }
    end
end

-- process function for boundaries
function osm2pgsql.process_relation(object)
    if object.tags.boundary == 'administrative' then
        tables.boundaries:add_row{
            tags = object.tags,
            geom = {
                create = 'area'
            }
        }
    end
end
