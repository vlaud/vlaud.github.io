
module Jekyll
  class TaxonomyHandlerGenerator < Jekyll::Generator
    safe true
    priority :high # Run this early

    def generate(site)
      # Initialize maps
      site.data['taxonomy_slugs'] = {} # Original -> Slug
      site.data['taxonomy_labels'] = {} # Slug -> Original

      # Helper for consistent slugging
      def slugify_name(name)
        slug_source = name.gsub('+', 'plus').gsub('#', 'sharp')
        Jekyll::Utils.slugify(slug_source)
      end

      # 1. First pass: Collect all unique taxonomies and populate maps
      all_taxonomies = []
      site.posts.docs.each do |post|
        all_taxonomies.concat(post.data['categories'] || [])
        all_taxonomies.concat(post.data['tags'] || [])
      end

      all_taxonomies.uniq.each do |name|
        next unless name.is_a?(String)
        slug = slugify_name(name)
        site.data['taxonomy_slugs'][name] = slug
        site.data['taxonomy_labels'][slug] = name
      end

      # 2. Second pass: Modify post data for permalinks
      site.posts.docs.each do |post|
        if post.data['categories']
          post.data['categories'] = post.data['categories'].map do |cat|
            site.data['taxonomy_slugs'][cat] || cat
          end
        end
        if post.data['tags']
          post.data['tags'] = post.data['tags'].map do |tag|
            site.data['taxonomy_slugs'][tag] || tag
          end
        end
      end
    end
  end
end
