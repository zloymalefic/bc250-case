# Реестр инженерных источников

Статус на 2026-08-19. Наличие файла не означает подтверждение его точности или разрешение на прямое переиспользование.

## Получено локально

| Источник | Форматы | Полезность | Статус лицензии |
|---|---|---|---|
| [hafriedlander/bc250-case](https://github.com/hafriedlander/bc250-case) | OpenSCAD, STL, изображения | Детальная proxy-модель BC-250, параметрический корпус, кронштейны | Отдельный LICENSE в репозитории не найден; прямое копирование деталей пока запрещено |
| [onemorecap/bc-250-shell-case](https://github.com/onemorecap/bc-250-shell-case) | STEP, 3MF, STL, изображения | Редактируемый модульный chassis, крепёж и разбиение для печати | Отдельный LICENSE в репозитории не найден; прямое копирование деталей пока запрещено |
| [NexGen-3D-Printing/SteamMachine](https://github.com/NexGen-3D-Printing/SteamMachine) | README, XLSX BOM, 3MF, архивы | Принципы модульности, PSU-модули, faceplates, обслуживание | CAD-пакет Printables: CC BY-NC 4.0 |
| [zloymalefic/BC-250-PC-Remote-Control](https://github.com/zloymalefic/BC-250-PC-Remote-Control) | Arduino/C++, HTML/CSS | Электрические интерфейсы контроллера питания и кнопки | Используется как связанный пользовательский проект; геометрия платы пока внешняя |

Зафиксированные ревизии:

- hafriedlander: `cf807f35897c43f5c489bf60b8fa54bf1fba0f00`;
- onemorecap: `ea2e59bab5ea5f5bd4cfce69b72c4a192391daea`;
- NexGen3D: `b305ccccd7133a7ae7340d578f10b4ec820ff63a`;
- Remote Control: `793f5d05ef1bef5f4681796562bda49f6b1ef97f`.

## Получено из Printables

### NexGen3D DIY Steam Machine REDUX Edition

- Source: https://www.printables.com/model/1649679-nexgen3d-diy-steam-machine-redux-edition
- Printables model 1649679; архив распакован в `references/printables-1649679-nexgen-redux`.
- 85 файлов: V4.2/V4.2.1 3MF, STEP-заготовки faceplate/button/PSU brackets, старые ревизии и PDF.
- Статус: более поздняя ревизия механизмов, уже принятых из PRO V2. Дополнительная ценность: editable blank-button STEP, обновлённые snap-tabs, split covers и storage caddy.
- `redux-optional-usb-cover.3mf`: raw envelope около 12,65 × 70,35 × 32,58 мм.
- Лицензия: CC BY-NC 4.0.

### Nyacom Industrial Style Case for FlexATX

- Source: https://www.printables.com/model/1737913-nyacoms-amd-bc-250-industrial-style-case-for-flexa
- Printables model 1737913; полный архив распакован в `references/printables-1737913-nyacom-flex`.
- 36 STL, 2 reference 3MF и 42-страничный PDF.
- Общий envelope корпуса по STL: около 125 × 315 × 175 мм (~6,9 л), без внешних кабелей и ножек.
- 3MF помечены автором как outdated/reference; актуальными считаются отдельные STL.
- Лицензия: CC BY-NC-SA 4.0.

### NexGen3D Steam Machine PRO V2

- Files: https://www.printables.com/model/1793043-nexgen3d-diy-steam-machine-pro-v2-liquid-cooled-bc/files
- Printables model 1793043; полный архив распакован в `references/printables-1793043-nexgen-pro-v2`.
- 43 файла 3MF, 1 редактируемый STEP пустой faceplate и 15-страничный PDF.
- Примерный общий envelope front + rear: 329,1 × 109,35 × 282,1 мм (~10,15 л); требует проверки сборочных transforms.
- Присутствуют отдельные крепления server PSU/FlexATX/LOP, вертикальная подставка, access panel и multipurpose bay.
- Лицензия: CC BY-NC 4.0.

### BC-250 Quiet Case Tower Cooler

- Source: https://www.printables.com/model/1652979
- Printables model 1652979; архив распакован в `references/printables-1652979-quiet-case`.
- Это дополнительный референс, а не запрошенный адаптер AN600.
- 16 STL и 7-страничный PDF; envelope assembled STL около 180 × 368 × 269 мм (~17,8 л).
- Полезен для USB routing, большого воздушного кулера и front USB hub.
- Лицензия: CC BY-NC 4.0.

### DeepCool AN600 adapter for AMD BC-250

- Source: https://www.printables.com/model/1707972-deepcool-an600-adapter-for-amd-bc-250
- Printables model 1707972; полный архив распакован в `references/printables-1707972-an600-adapter`.
- Содержит STL, 3MF и 3-страничный PDF; редактируемого STEP/CAD нет.
- STL и 3MF имеют совпадающий envelope 105 × 105 × 8 мм.
- Рассчитан на Intel mounting brackets из комплекта DeepCool AN600.
- Крепёж автора: 4× M3×12, 4× M3×20, 8× M3 nuts.
- Лицензия: Public Domain.

### Sean BC-250 Heat Sink Mount (MK7)

- Source: https://www.printables.com/model/1217021-bc-250-heat-sink-mount
- Printables model 1217021; supplied archive extracted to
  `references/printables-1217021-heatsink-mount`.
- Contains one 105.56 × 104.39 × 8 mm STL and a 2-page Printables PDF.
- Intended for the PCCOOLER RZ620 Intel clip bracket, not the JIUSHARK JF13K.
- Author describes M4 installation from below, either self-tapped or through
  with nuts, using a mixture of cooler and removed stock-heatsink hardware.
- License in supplied PDF: Public Domain.

## Доступно в каталогах, но файлы ещё не получены

## Дополнительные источники геометрии BC-250

- Printables model 1341336: accurate 3D model of AMD BC-250.
- Printables model 1537364: AMD BC-250 STEP file.
- Полученная proxy-модель `references/hafriedlander-bc250-case/_extern/BC-250.scad` сгенерирована из FreeCAD и должна быть сверена с этими двумя источниками.

## Правило использования

До проверки лицензии и геометрии внешние модели применяются только для анализа envelope, интерфейсов и архитектурных принципов. Финальные детали не копируются из источника с неясной лицензией.
