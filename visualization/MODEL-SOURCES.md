# Источники моделей 3D-визуализации

`visualization/assets/*.stl` — готовые файлы для браузера. Они не являются
главными CAD-исходниками: при изменении конструкции их нужно сверять и
пересобирать командой `tools/up-model`.

## Собственная CAD-геометрия проекта

| Файлы в `visualization/assets` | Исходник |
| --- | --- |
| `front-core.stl`, `rear-core.stl` | `cad/core-assembly-v0.1.scad` |
| `board-spine-front.stl`, `board-spine-rear.stl` | `cad/board-spine-v0.1.scad`, вызывается из master CAD |
| `front-panel.stl`, `front-button-mount.stl`, `front-usb-cassette.stl` | `cad/front-service-module-v0.1.scad`, вызывается из master CAD |
| `ssd-cassette.stl`, `esp32-cassette.stl` | `cad/peripheral-bay-v0.1.scad`, вызывается из master CAD |
| `esp32-cover.stl` | `cad/esp32-service-cover-v0.1.scad`, вызывается из master CAD |
| `rear-cover-horizontal.stl`, `rear-cover-vertical.stl` | `cad/core-assembly-v0.1.scad` |
| `intake-cover-left.stl`, `intake-cover-right.stl` | `cad/intake-panel-snap-v0.1.scad` |
| `button-decorative-bezel.stl` | `cad-visualization/visualization-decorative-button.scad`; только визуализация |

Главная точка входа корпуса — `cad/core-assembly-v0.1.scad`. Параметр `part`
выбирает экспортируемую деталь.

## Модели из проекта NexGen PRO V2

| Файлы в `visualization/assets` | Исходник |
| --- | --- |
| `button-plate.stl` | `references/printables-1793043-nexgen-pro-v2/Power Button/pro-v2-button-mounting-plate.3mf` |
| `button-light-pipe.stl` | `references/printables-1793043-nexgen-pro-v2/Power Button/pro-v2-transparent-rear-section.3mf` |
| `button-cap-black.stl`, `button-logo-white.stl` | `references/printables-1793043-nexgen-pro-v2/Power Button/pro-v2-steam-logo.3mf` |
| `usb-cover.stl` | `references/printables-1793043-nexgen-pro-v2/Case/pro-v2-usb-cover-multi-material.3mf` |

Промежуточные `cad/vendor/nexgen/button-*.3mf` используются только для чтения.
Updater не создаёт и не изменяет их; если они отсутствуют, он сообщает точные
пути и останавливается. Лицензия и авторство описаны в `ATTRIBUTION.md`.

## Модели, создаваемые непосредственно в viewer

Следующие объекты пока не имеют отдельных STL и строятся кодом в
`visualization/viewer.js`:

- приблизительная геометрия JIUSHARK JF13K по габариту 241 × 92 × 121 мм;
- Cisco UCSC-PSU-650W V02 как проверочный габарит 240 × 40 × 96 мм;
- Anker A7516 как габарит и четыре USB-A-разъёма;
- вентиляторы, теплотрубки и простые внутренние прокси.

Это визуальные макеты, а не печатные детали.

## Плата BC-250

Viewer локально загружает
`references/hafriedlander-bc250-case/_extern/bc250_alt.stl`. Репозиторий-источник
и зафиксированный commit указаны в `SETUP.md`. Mesh намеренно не включён в этот
репозиторий: явная лицензия на распространение не найдена.

Предоставленная пользователем точная модель платы используется для проверки
датумов и размеров, но не должна автоматически попадать в публичный релиз до
уточнения лицензии.

## Фотографии и архивы

`Photo cooler/` — исходные фотографии реально установленного JF13K. Это не
мусор и не геометрия для viewer: фотографии подтверждают ориентацию и посадку,
описанную в `cad/JF13K-PHOTO-FIT.md`.

Корневые ZIP-файлы являются только пакетами загрузки. После распаковки нужные
лицензированные материалы хранятся в `references/`; ZIP можно удалить.
