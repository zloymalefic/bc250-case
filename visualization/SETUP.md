# Развёртывание 3D-визуализации BC-250

## Требования

- Git;
- Python 3.10 или новее;
- OpenSCAD с доступной командой `openscad` — только для пересборки STL;
- современный браузер с WebGL 2;
- интернет при открытии страницы: Three.js загружается с jsDelivr.

Установка OpenSCAD:

- macOS: `brew install --cask openscad`;
- Ubuntu/Debian: `sudo apt install openscad`;
- Windows: установить OpenSCAD и добавить его в `PATH`. Также распознаётся стандартный путь `C:\Program Files\OpenSCAD`.

## Получение проекта

```sh
git clone <URL-ЭТОГО-РЕПОЗИТОРИЯ> bc250-case
cd bc250-case
```

Mesh-модель BC-250 находится во внешнем репозитории и намеренно не коммитится
сюда из-за отсутствия явной лицензии. Для локальной инженерной визуализации:

```sh
git clone https://github.com/hafriedlander/bc250-case.git references/hafriedlander-bc250-case
git -C references/hafriedlander-bc250-case checkout cf807f35897c43f5c489bf60b8fa54bf1fba0f00
```

Без этого источника корпус откроется, но плата BC-250 не загрузится. Нельзя
включать `bc250_alt.stl` в релизные архивы до подтверждения лицензии.

## Запуск с автообновлением

```sh
python3 tools/dev_visualization.py
```

Открыть <http://localhost:8000/visualization/> и оставить команду работающей.
Остановка — `Ctrl+C`.

Watcher:

1. Запускает сервер только на локальном адресе `127.0.0.1`.
2. Следит за интерфейсом и готовыми `visualization/assets/*.stl`.
3. Автоматически перезагружает открытую вкладку после их изменения.
4. Не пересобирает `cad/` автоматически.

Принудительная полная пересборка (только по явному запросу):

```sh
python3 tools/dev_visualization.py --rebuild
```

Другой порт:

```sh
python3 tools/dev_visualization.py --port 8080
```

## Ручной экспорт

На macOS, Linux, WSL или в Git Bash:

```sh
tools/export_visualization_assets.sh
```

Единая команда аудита и обновления (`/up-model` в терминологии проекта):

```sh
tools/up-model
```

Поддерживаемое явное имя skill в Codex — `$up-model`. Режим только проверки:

```sh
tools/up-model --check
```

Команда экспортирует модели во временный каталог, сравнивает их с браузерными
STL и атомарно обновляет только `visualization/assets/`. Каталоги `cad/` и
`cad-visualization/` остаются только для чтения.

## Структура

- `cad/core-assembly-v0.1.scad` — основная сборка;
- `cad/` — авторитетный инженерный CAD, только для чтения со стороны визуализации;
- `cad-visualization/` — непечатные исходники визуализации, также только для чтения;
- `visualization/MODEL-SOURCES.md` — точная карта происхождения всех моделей;
- `visualization/viewer.js` — сцена, материалы, transforms и модель JF13K;
- `visualization/styles.css` — интерфейс;
- `tools/dev_visualization.py` — watcher и локальный сервер.

Если добавлен новый `part` или изменилась экспортная ориентация, обновить нужно
и список экспорта в watcher, и `specs` в `viewer.js`.

## Типичные проблемы

### OpenSCAD не найден

Проверить `openscad --version`. На macOS скрипт дополнительно ищет
`/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD`.

### Плата не отображается

Проверить наличие файла:

```text
references/hafriedlander-bc250-case/_extern/bc250_alt.stl
```

### Страница не открывается

Проверить, что watcher работает и порт свободен. При необходимости использовать
`--port 8080`. Открывать HTML через `file://` нельзя — браузер заблокирует STL.

### Изменения ещё не появились

Дождаться окончания сообщений `Exporting ...`. При ошибке исправить SCAD-файл;
предыдущая рабочая визуализация останется доступна.
