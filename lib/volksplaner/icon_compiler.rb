# We want to add icons to links and buttons without having the designer to
# change any views or adding extra icon-specific classes. The only class would
# be 'create-comment' which the designer can @extend in scss.
#
# But as the SCSS-compiler runs _before_ the asset pipeline, we have to inject
# our own. For this, we will have config/icons.yml looking like this:
# icons:
#   dirty: 'pile'
#
# IconCompiler.observe will compile a file from this and write it to the wished path

class Volksplaner::IconCompiler
  class << self
    # Checks if paths are in sync and compiles and writes otherwise
    def observe(yaml_path, scss_path)
      unless File.exist?(scss_path) && uptodate?(yaml_path, scss_path)
        parsed = read_and_parse(yaml_path)
        scss = compile(parsed)
        write(scss_path, scss)
      end
    end

    def compile(hash)
      hash = hash[:icons] if hash.has_key?(:icons)
      hash.collect do |name,displayed|
        entry name, displayed
      end.join("\n")
    end

    def entry(name, displayed)
      return <<-EOSCSS
        .icon-#{name} {
          &:before {
            content: "#{displayed}";
          }
        }
      EOSCSS
    end

    def read_and_parse(path)
      YAML.parse_file(path).to_ruby.with_indifferent_access
    end

    def write(path, content)
      File.open path, 'w' do |f|
        f.write content
      end
      Rails.logger.debug { "#{self}: written #{path}" }
    end

    def uptodate?(source, result)
      Rails.logger.debug { "compare #{File.mtime(source)} < #{File.mtime(result)}" }
      File.mtime(source) < File.mtime(result)
    end
  end
end

