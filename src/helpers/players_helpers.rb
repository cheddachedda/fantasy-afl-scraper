def extract_names full_name
  edge_cases = {
    'McDonald-Tipungwuti' => {
      :first_name => 'Anthony',
      :middle_initial => nil,
      :last_name => 'McDonald-Tipungwuti'
    }
  }

  return edge_cases[full_name] if edge_cases.keys.include?(full_name)

  first_name = full_name.split(' ').first
  middle_initial = nil
  last_name = full_name.split(' ').drop(1).join(' ')

  if full_name.include?('.')
    middle_initial = last_name.split('. ').first
    last_name = last_name.split('. ').drop(1).join(' ')
  end

  {
    :first_name => first_name,
    :middle_initial => middle_initial,
    :last_name => last_name
  }
end

def parse_positions(string)
  "{#{ string.sub('/', ',') }}"
end