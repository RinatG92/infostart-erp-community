﻿Перем мПериод Экспорт;
Перем мТаблицаДвижений Экспорт;

Процедура ВыполнитьПриход() Экспорт
	ОбщегоНазначения.ВыполнитьДвижениеПоРегистру(ЭтотОбъект, ВидДвиженияНакопления.Приход);
КонецПроцедуры

Процедура ВыполнитьРасход() Экспорт
	ОбщегоНазначения.ВыполнитьДвижениеПоРегистру(ЭтотОбъект, ВидДвиженияНакопления.Расход);
КонецПроцедуры

Процедура ВыполнитьДвижения() Экспорт
	Загрузить(мТаблицаДвижений);
КонецПроцедуры