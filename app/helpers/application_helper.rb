module ApplicationHelper
	def name_to_russian value
		value = value.to_s.strip
		translator = {
			'Ә' => 'A',
			'І' => 'И',
			'Ң' => 'Н',
			'Ғ' => 'Г',
			'Ү' => 'У',
			'Ұ' => 'У',
			'Қ' => 'К',
			'Ө' => 'О',
			'Һ' => 'Х',
		}
		translator_small = {}
		translator.each do |key, value|
			translator_small[key.downcase] = value.downcase
		end

		translator.each do |key, val|
			value = value.gsub(key, val)
		end
		translator_small.each do |key, val|
			value = value.gsub(key, val)
		end

		return value
	end
	def name_to_english value
		value = value.to_s.strip
		translator = {
			'А' => 'A',
			'Ә' => 'A',
			'Б' => 'B',
			'В' => 'V',
			'Г' => 'G',
			'Ғ' => 'G',
			'Д' => 'D',
			'Е' => 'E',
			'Ё' => 'Yo',
			'Ж' => 'Zh',
			'З' => 'Z',
			'И' => 'I',
			'Й' => 'I',
			'К' => 'K',
			'Қ' => 'K',
			'Л' => 'L',
			'М' => 'M',
			'Н' => 'N',
			'Ң' => 'N',
			'О' => 'O',
			'Ө' => 'O',
			'П' => 'P',
			'Р' => 'R',
			'С' => 'S',
			'Т' => 'T',
			'У' => 'U',
			'Ұ' => 'U',
			'Ф' => 'F',
			'Х' => 'Kh',
			'Һ' => 'Kh',
			'Ц' => 'C',
			'Ч' => 'Ch',
			'Ш' => 'Sh',
			'Щ' => 'Sh',
			'Ъ' => '',
			'Ы' => 'Y',
			'І' => 'I',
			'Ь' => '',
			'Э' => 'E',
			'Ю' => 'Yu',
			'Я' => 'Ya',
		}
		translator_small = {}
		translator.each do |key, value|
			translator_small[key.downcase] = value.downcase
		end

		translator.each do |key, val|
			value = value.gsub(key, val)
		end
		translator_small.each do |key, val|
			value = value.gsub(key, val)
		end

		return value
	end
	def split_string value
		value = value.to_s.strip
		value = value.scan /[^\s]+/
		return value
	end
	def datetime_to_time value
		value.to_time.to_i
	end
end
