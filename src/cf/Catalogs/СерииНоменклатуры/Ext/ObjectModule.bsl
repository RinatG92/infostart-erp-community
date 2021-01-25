﻿// Функция устанавливает новое наименование серии по значениям реквизитов.
//
// Возвращаемое значение:
//  Строка - сформированное наименование.
//
Функция СформироватьНаименование() Экспорт

	Строка = "";

	Если ЗначениеЗаполнено(СерийныйНомер) Тогда
		Строка = Строка + СерийныйНомер + ", ";
	КонецЕсли;

	Если ЗначениеЗаполнено(Сертификат) Тогда
		Строка = Строка + Сертификат + ", ";
	КонецЕсли;

	Если ЗначениеЗаполнено(СрокГодности) Тогда
		Строка = Строка + Формат(СрокГодности,"ДФ=""дд.ММ.гггг""") + ", ";
	КонецЕсли;

	Если ЗначениеЗаполнено(НомерГТД) Тогда
		Строка = Строка + СокрЛП(НомерГТД.Код) + ", ";
	КонецЕсли;

	Если ЗначениеЗаполнено(СтранаПроисхождения) Тогда
		Строка = Строка + СтранаПроисхождения.Наименование + ", ";
	КонецЕсли;

	Строка = Лев(Строка, СтрДлина(Строка) - 2);

	Если ПустаяСтрока(Строка) Тогда
		Строка = "<Свойства не назначены>";
	КонецЕсли;

	Возврат Строка;

КонецФункции

// Функция проверяет, существуют ли ссылки на договор в движениях регистров накопления.
// Если есть - нельзя менять:
//  - Валюту взаиморасчетов
//  - Ведение взаиморасчетов.
//
// Параметры:
//  Нет.
//
// Возвращаемое значение:
//  Истина - если есть движения, Ложь - если нет.
//
Функция СуществуютСсылки() Экспорт
	Запрос=Новый Запрос();
	Запрос.УстановитьПараметр("СерияНоменклатуры", Ссылка);
	Запрос.Текст="
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	РегистрНакопления.ТоварыНаСкладах.СерияНоменклатуры
	|ГДЕ
	|	СерияНоменклатуры = &СерияНоменклатуры
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	РегистрНакопления.ПартииТоваровНаСкладах.СерияНоменклатуры
	|ГДЕ
	|	СерияНоменклатуры = &СерияНоменклатуры
	|";
	Возврат НЕ Запрос.Выполнить().Пустой();
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ПриКопировании(ОбъектКопирования)
	
	Если Не ЭтоГруппа Тогда
		ОсновноеИзображение = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)

	// Проверим можно ли изменять реквизиты договора.
	// Проверка осуществляется только если записывается уже существующий договор
	Если НЕ ОбменДанными.Загрузка И НЕ ЭтоНовый() Тогда
		// Проверим возможность смены способа ведения взаиморасчетов и валюты взаиморасчетов
		Если НомерГТД <> Ссылка.НомерГТД Тогда //ИЛИ СтранаПроисхождения <> Ссылка.СтранаПроисхождения Тогда
			Если ЭтотОбъект.СуществуютСсылки() Тогда
				Сообщить("Существуют документы, проведенные по сериии """ + Наименование + """.
					|Реквизит ""Номер ГТД"" не может быть изменен, элемент не записан.", 
						 //|Реквизиты ""Номер ГТД"" и ""Страна происхождения"" не могут быть изменены, элемент не записан.", 
						 СтатусСообщения.Важное);
				Отказ = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

