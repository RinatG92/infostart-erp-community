﻿Процедура ПроверитьДубли(Отказ, Заголовок)
	Запрос=Новый Запрос;
	Запрос.УстановитьПараметр("ДокументСсылка", Ссылка);
	Запрос.Текст="
	|ВЫБРАТЬ
	|	Док.НоменклатурнаяЦеноваяГруппа,
	|	Док.УсловиеПродаж,
	|	СУММА(1) КАК КоличествоДублей
	|ИЗ
	|	Документ.УстановкаНаценокПоУсловиямПродаж.Наценки КАК Док
	|ГДЕ
	|	Док.Ссылка = &ДокументСсылка
	|СГРУППИРОВАТЬ ПО
	|	НоменклатурнаяЦеноваяГруппа,
	|	УсловиеПродаж
	|";	
	ТаблицаПроверкиДублей=Запрос.Выполнить().Выгрузить();

	СтруктураПолей=Новый Структура("НоменклатурнаяЦеноваяГруппа,УсловиеПродаж");
	Для Каждого СтрокаДублей Из ТаблицаПроверкиДублей Цикл
		Если СтрокаДублей.КоличествоДублей > 1 Тогда
			СтрокаСообщения = "Дублируется строка: ";
			Для Каждого Поле Из СтруктураПолей Цикл
				СтрокаСообщения = СтрокаСообщения + СтрокаДублей[Поле.Ключ] + ", ";
			КонецЦикла;
			// Уберем из текста сообщения последнюю запятую и пробел.
			СтрокаСообщения = Лев(СтрокаСообщения, СтрДлина(СтрокаСообщения) - 2);
			ОбщегоНазначения.СообщитьОбОшибке(СтрокаСообщения + "!", Отказ, Заголовок);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Процедура ПроверитьПересекающиесяДокументы(Отказ, Заголовок)
	Запрос=Новый Запрос;
	Запрос.УстановитьПараметр("ДокументСсылка", Ссылка);
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Док.НоменклатурнаяЦеноваяГруппа КАК Группа,
	|	Док.УсловиеПродаж КАК УсловиеПродаж,
	|	РегНаценкиПоУсловиямПродаж.ПроцентНаценки КАК ПроцентНаценки,
	|	РегНаценкиПоУсловиямПродаж.Период КАК ДатаНачала,
	|	РегНаценкиПоУсловиямПродаж.Регистратор КАК Регистратор
	|ИЗ
	|	Документ.УстановкаНаценокПоУсловиямПродаж.Наценки КАК Док
	|ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|	Справочник.Номенклатура КАК СпрНоменклатура
	|ПО
	|	СпрНоменклатура.НоменклатурнаяГруппа = Док.НоменклатурнаяЦеноваяГруппа
	|	ИЛИ СпрНоменклатура.ЦеноваяГруппа = Док.НоменклатурнаяЦеноваяГруппа
	|ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|	РегистрСведений.НаценкиПоУсловиямПродаж КАК РегНаценкиПоУсловиямПродаж
	|ПО
	|	(СпрНоменклатура.НоменклатурнаяГруппа = РегНаценкиПоУсловиямПродаж.НоменклатурнаяЦеноваяГруппа
	|	ИЛИ СпрНоменклатура.ЦеноваяГруппа = РегНаценкиПоУсловиямПродаж.НоменклатурнаяЦеноваяГруппа)
	|	И Док.УсловиеПродаж = РегНаценкиПоУсловиямПродаж.УсловиеПродаж
	|ГДЕ
	|	Док.Ссылка = &ДокументСсылка
	|УПОРЯДОЧИТЬ ПО Период Возр, Группа Возр, ПроцентНаценки Убыв
	|";
	ТЗ=Запрос.Выполнить().Выгрузить();
	ТЗ.Колонки.Добавить("ДатаОкончания");
	ТЗ.ЗаполнитьЗначения('00010101', "ДатаОкончания");

	// Сопоставим строки, которые начинают действие наценок и строки, которые его заканчивают.
	КоличествоСтрок = ТЗ.Количество() - 1;
	Для Тмп = 0 По КоличествоСтрок Цикл
		СтрокаТЗ = ТЗ[КоличествоСтрок - Тмп];

		Если НЕ ЗначениеЗаполнено(СтрокаТЗ.ПроцентНаценки) Тогда
			Для Тмп1 = 0 По ТЗ.Количество() -1 Цикл
				СтрокаПоиска = ТЗ[Тмп];

				Если СтрокаПоиска.Группа = СтрокаТЗ.Группа
				   И СтрокаПоиска.УсловиеПродаж = СтрокаТЗ.УсловиеПродаж
				   И НЕ ЗначениеЗаполнено(СтрокаПоиска.ДатаОкончания) Тогда
					СтрокаПоиска.ДатаОкончания = СтрокаТЗ.ДатаНачала;
					ТЗ.Удалить(СтрокаТЗ);
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;

	// Если дата окончания по строке больше даты документа - это пересечение.
	СтрокаДокументовПересечений = "";
	Для Каждого СтрокаТЗ Из ТЗ Цикл
		Если СтрокаТЗ.ДатаОкончания > Дата Или НЕ ЗначениеЗаполнено(СтрокаТЗ.ДатаОкончания) Тогда 
			СтрокаДокументовПересечений = СтрокаДокументовПересечений + Символы.ПС + СтрокаТЗ.Группа + ", " + СтрокаТЗ.УсловиеПродаж +": " + СтрокаТЗ.Регистратор;
		КонецЕсли;
	КонецЦикла;

	Если НЕ ПустаяСтрока(СтрокаДокументовПересечений) Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Найдены записи о наценках для групп по условиям продаж, которые уже действуют:" + СтрокаДокументовПересечений, Отказ, Заголовок);
		Отказ = Истина;
	КонецЕсли;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Движения по регистрам 

Процедура ДвиженияПоРегистрам(Отказ)
	ДвижениеПоРегистру_НаценкиПоУсловиямПродаж(Отказ);
КонецПроцедуры

Процедура ДвижениеПоРегистру_НаценкиПоУсловиямПродаж(Отказ)
	тзДвижения=Движения.НаценкиПоУсловиямПродаж.ВыгрузитьКолонки();
	Для каждого СтркаКоллекции Из Наценки Цикл
		ЗаполнитьЗначенияСвойств(тзДвижения.Добавить(), СтркаКоллекции);
	КонецЦикла;
	тзДвижения.ЗаполнитьЗначения(Истина, "Активность");
	тзДвижения.ЗаполнитьЗначения(Дата, "Период");
	тзДвижения.ЗаполнитьЗначения(Ссылка, "Регистратор");
	Движения.НаценкиПоУсловиямПродаж.Загрузить(тзДвижения);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	УправлениеДокументамиСервер.ПередПроведением(Отказ, РежимПроведения, ЭтотОбъект);
	Если Отказ Тогда Возврат; КонецЕсли; 

	ПроверитьПересекающиесяДокументы(Отказ, ДополнительныеСвойства.Заголовок);
	ПроверитьДубли(Отказ, ДополнительныеСвойства.Заголовок);
	
	ДвиженияПоРегистрам(Отказ);
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	Заголовок=ЗаполнениеДокументов.ПредставлениеДокументаПриПроведении(ЭтотОбъект);
	
	Если Наценки.Количество()=0 Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Не заполнена табличная часть документа!", Отказ, Заголовок);
	КонецЕсли;

	//Инициализация доп.свойств документа	
    ДополнительныеСвойства.Вставить("Заголовок", Заголовок);	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Операторы основной программы

УправлениеДокументамиСервер.ИнициализацияМодуля(ДополнительныеСвойства);