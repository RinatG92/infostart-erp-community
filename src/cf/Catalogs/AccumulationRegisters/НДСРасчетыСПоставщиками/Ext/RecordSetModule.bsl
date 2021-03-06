﻿Перем мПериод          Экспорт; // Период движений
Перем мТаблицаДвижений Экспорт; // Таблица движений

Процедура ДобавитьДвижение(ЗаполнитьДатуСобытия = истина) Экспорт
	
	Если мТаблицаДвижений.Колонки.Найти("ДатаСобытия") = Неопределено Тогда
		мТаблицаДвижений.Колонки.Добавить("ДатаСобытия");
		ЗаполнитьДатуСобытия = истина;
	КонецЕсли; 
	
	Если ЗаполнитьДатуСобытия Тогда
		мТаблицаДвижений.ЗаполнитьЗначения( мПериод, "ДатаСобытия");
	КонецЕсли; 
	ОбщегоНазначения.ВыполнитьДвижениеПоРегистру(ЭтотОбъект,,,ЗаполнитьДатуСобытия);
КонецПроцедуры

Процедура ВыполнитьПриход(ЗаполнитьДатуСобытия = истина) Экспорт
	Если мТаблицаДвижений.Колонки.Найти("ДатаСобытия") = Неопределено Тогда
		мТаблицаДвижений.Колонки.Добавить("ДатаСобытия");
		ЗаполнитьДатуСобытия = истина;
	КонецЕсли; 
	
	Если ЗаполнитьДатуСобытия Тогда
		мТаблицаДвижений.ЗаполнитьЗначения( мПериод, "ДатаСобытия");
	КонецЕсли; 
	
	ОбщегоНазначения.ВыполнитьДвижениеПоРегистру(ЭтотОбъект, ВидДвиженияНакопления.Приход,,ЗаполнитьДатуСобытия);
КонецПроцедуры

Процедура ВыполнитьРасход(ЗаполнитьДатуСобытия = истина) Экспорт
	Если мТаблицаДвижений.Колонки.Найти("ДатаСобытия") = Неопределено Тогда
		мТаблицаДвижений.Колонки.Добавить("ДатаСобытия");
		ЗаполнитьДатуСобытия = истина;
	КонецЕсли; 
	
	Если ЗаполнитьДатуСобытия Тогда
		мТаблицаДвижений.ЗаполнитьЗначения( мПериод, "ДатаСобытия");
	КонецЕсли; 
	
	ОбщегоНазначения.ВыполнитьДвижениеПоРегистру(ЭтотОбъект, ВидДвиженияНакопления.Расход,,ЗаполнитьДатуСобытия);
КонецПроцедуры

Процедура ВыполнитьДвижения() Экспорт
	Загрузить(мТаблицаДвижений);
КонецПроцедуры
              
