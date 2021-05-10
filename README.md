# AvitoApi
Avito - самая большая нешардированная база объявлений в Европе!

Собственно данный гем - обертка для API Avito, которое используется мобильными приложениями.
Это не клиент для b2b https://api.avito.ru/docs/api.html .

Используйте на свой страх и риск.

## Installation

Add these line to your application's Gemfile:

```ruby
git_source(:github) { |repo| "https://github.com/#{repo}.git" }
gem 'avito_api', github: 'etspring/avito_api'
```

And then execute:

    $ bundle install

## Usage

### 1. Конфигурация
```ruby
    AvitoApi.configure do |config|
        config.key = 'ключ_установленного_приложений'
        config.endpoints = { .... }
    end
```

Увы я особо не разбирался откуда приложение берет данный ключ, но видимо при первом запуске приложение генерит/получает его.

Есть несколько вариантов получить данный ключ:
* Поискать в этих ваших Интернетах.
* При помощи mitmproxy/charles ( заодно посмотрите на API ).
* Завернуть трафик в сторону avito.ru на локалхост с поднятым nginx.

Теперь про endpoints. Получены они опытным путем.
Использование значения ключа uri из ответов API не всегда дает нужный результат.
На 2020-05-08 актуальные значения ( стоят дефолтом ):

```ruby
    @endpoints = {
        categories: '5',
        items: '10',
        phone: '1',
        full: '16'
    }
```
Значения можно получить самостоятельно при помощи mitmproxy/charles.

Если необходимо использовать площадку в других странах ( например avi.kz ), то следует указать *api_url*, а так же новые endpoints.

### 2. Использование

**Частые запросы ( более 1-2 в секунду ) приведут к 429 Too Many Requests.**

**Avito проверяет принадлежность ip к стране, поэтому если вы делаете запросы с Amazon - пользуйтесь proxy.**

```ruby
client = AvitoApi::Client.new
```
Клиент может быть инициализирован с options HTTParty.

Список категорий объявлений
```ruby
client.categories
```

Список предложений ( кратких )
```ruby
client.items
```
Методу могут быть переданы params запроса.

* categoryId - категория объявлений
* geoCoords - координаты через запятую
* locationId - город
* page - номер страницы
* sort - сортировка ( может принимать значения date/price/priceDesc)

```ruby
client.items({categoryId: 110, sort: 'date', page: 2})
```

Если известны endpoints можно использовать
```ruby
client.request(endpoint_url, params)
```

Для получения телефона объявления:
```ruby
client.items.map { |item| item.phone }
```

Для получения расширенной информации:
```ruby
client.items.map { |item| item.full }
```

## Development

Собственно в планах следующее:

1. Добавить обработку ошибок
2. Добавить работу с suggests/search

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/etspring/avito_api. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/etspring/avito_api/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Avito project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/etspring/avito_api/blob/master/CODE_OF_CONDUCT.md).