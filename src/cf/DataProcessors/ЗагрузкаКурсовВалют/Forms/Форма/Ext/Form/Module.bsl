﻿&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда Возврат; КонецЕсли;
	
	Если НЕ Параметры.Свойство("ОткрытиеИзСписка") Тогда
		Если РаботаСКурсамиВалют.КурсыАктуальны() Тогда
			СообщитьЧтоКурсыАктуальны=Истина; Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ЗаполнитьВалюты();
	
	// Начало и окончание периода загрузки курсов.
	Объект.ОкончаниеПериодаЗагрузки = НачалоДня(ТекущаяДатаСеанса());
	Объект.НачалоПериодаЗагрузки = Объект.ОкончаниеПериодаЗагрузки;
	МинимальнаяДата = НачалоГода(Объект.ОкончаниеПериодаЗагрузки);
	Для Каждого Валюта Из Объект.СписокВалют Цикл
		Если ЗначениеЗаполнено(Валюта.ДатаКурса) И Валюта.ДатаКурса < Объект.НачалоПериодаЗагрузки Тогда
			Если Валюта.ДатаКурса < МинимальнаяДата Тогда
				Объект.НачалоПериодаЗагрузки = МинимальнаяДата;
				Прервать;
			КонецЕсли;
			Объект.НачалоПериодаЗагрузки = Валюта.ДатаКурса;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если СообщитьЧтоКурсыАктуальны Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'Курсы валют актуальны.'"));
		Отказ=Истина; Возврат;
	КонецЕсли;	
	Если Объект.СписокВалют.Количество()=0 Тогда
		Отказ=Истина; ПоказатьПредупреждение(, НСтр("ru = 'В справочнике валют отсутствуют валюты, курсы которых можно загружать из сети Интернет.'"), 20);
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура СписокВалютВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ПереключитьЗагрузку();
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьКурсыВалют(Команда)
	ОчиститьСообщения();

	Если Не ЗначениеЗаполнено(Объект.НачалоПериодаЗагрузки) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не задана дата начала периода загрузки.'"),,"Объект.НачалоПериодаЗагрузки");
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.ОкончаниеПериодаЗагрузки) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не задана дата окончания периода загрузки.'"),,"Объект.ОкончаниеПериодаЗагрузки");
		Возврат;
	КонецЕсли;
	
	ОперацияЗагрузкиКурсов = ВыполнитьЗагрузкуКурсов();	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВсеВалюты(Команда)
	УстановитьВыбор(Истина);
	УстановитьДоступностьЭлементов();
КонецПроцедуры

&НаКлиенте
Процедура СнятьВыбор(Команда)
	УстановитьВыбор(Ложь);
	УстановитьДоступностьЭлементов();
КонецПроцедуры

&НаКлиенте
Процедура ЗагружатьПриИзменении(Элемент)
	УстановитьДоступностьЭлементов();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВыбор(Выбор)
	Для Каждого Валюта Из Объект.СписокВалют Цикл
		Валюта.Загружать = Выбор;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВалюты()
	// Заполнение табличной части списком валют, курс которых не зависит от курса других валют.
	ОкончаниеПериодаЗагрузки=Объект.ОкончаниеПериодаЗагрузки;
	Объект.СписокВалют.Очистить();

	ЗагружаемыеВалюты=РаботаСКурсамиВалют.ЗагружаемыеВалюты();	
	Для Каждого ЭлементВалюта Из ЗагружаемыеВалюты Цикл
		ДобавитьВалютуВСписок(ЭлементВалюта);
	КонецЦикла;	
КонецПроцедуры

&НаСервере
Процедура ДобавитьВалютуВСписок(Валюта)
	НоваяСтрока=Объект.СписокВалют.Добавить();
	НоваяСтрока.Загружать=Истина;	
	
	// Заполнение информации о курсе на основе ссылки валюты.
	ЗаполнитьДанныеСтрокиТаблицыНаОсновеВалюты(НоваяСтрока, Валюта);
КонецПроцедуры

&НаСервере
Процедура ОбновитьСведенияВСпискеВалют()
	Для Каждого СтрокаДанных Из Объект.СписокВалют Цикл
		СсылкаНаВалюту = СтрокаДанных.Валюта;
		ЗаполнитьДанныеСтрокиТаблицыНаОсновеВалюты(СтрокаДанных, СсылкаНаВалюту);
	КонецЦикла;	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеСтрокиТаблицыНаОсновеВалюты(СтрокаТаблицы, Валюта);
	
	СведенияОВалюте=ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Валюта, "НаименованиеПолное,Код,Наименование");
	
	СтрокаТаблицы.Валюта=Валюта;
	СтрокаТаблицы.КодВалюты=СведенияОВалюте.Код;
	СтрокаТаблицы.СимвольныйКод=СведенияОВалюте.Наименование;
	СтрокаТаблицы.Представление=СведенияОВалюте.НаименованиеПолное;
	ЗаполнитьЗначенияСвойств(СтрокаТаблицы, РаботаСКурсамиВалют.ЗаполнитьДанныеКурсаДляВалюты(Валюта));
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьЭлементов()
	
	ЕстьВыбранныеВалюты = Объект.СписокВалют.НайтиСтроки(Новый Структура("Загружать", Истина)).Количество() > 0;
	Элементы.ФормаЗагрузитьКурсыВалют.Доступность = ЕстьВыбранныеВалюты;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьЗагрузкуКурсаВыбраннойВалютыИзИнтернета(Команда)
	ТекущиеДанные = Элементы.СписокВалют.ТекущиеДанные;
	СнятьПризнакЗагрузкиИзИнтернета(ТекущиеДанные.Валюта);
	Объект.СписокВалют.Удалить(ТекущиеДанные);
КонецПроцедуры

&НаСервере
Процедура СнятьПризнакЗагрузкиИзИнтернета(ВалютаСсылка)
	ВалютаОбъект = ВалютаСсылка.ПолучитьОбъект();
	ВалютаОбъект.СпособУстановкиКурса = Перечисления.СпособыУстановкиКурсаВалюты.РучнойВвод;
	ВалютаОбъект.Записать();
КонецПроцедуры

&НаКлиенте
Процедура ПереключитьЗагрузку()
	Элементы.СписокВалют.ТекущиеДанные.Загружать = Не Элементы.СписокВалют.ТекущиеДанные.Загружать;
	УстановитьДоступностьЭлементов();
КонецПроцедуры

&НаСервере
Функция ВыполнитьЗагрузкуКурсов()
	УстановитьПривилегированныйРежим(Истина);

	ПараметрыЗагрузки=Новый Структура;
	ПараметрыЗагрузки.Вставить("НачалоПериода", Объект.НачалоПериодаЗагрузки);
	ПараметрыЗагрузки.Вставить("КонецПериода", Объект.ОкончаниеПериодаЗагрузки);
	ПараметрыЗагрузки.Вставить("СписокВалют", ОбщегоНазначения.ТаблицаЗначенийВМассив(Объект.СписокВалют.Выгрузить(Объект.СписокВалют.НайтиСтроки(Новый Структура("Загружать", Истина)), "КодВалюты,Валюта")));

	РаботаСКурсамиВалют.ЗагрузитьАктуальныйКурс(ПараметрыЗагрузки);		
	
	УстановитьПривилегированныйРежим(Ложь);
КонецФункции

&НаКлиенте
Процедура ПриЗавершенииЗагрузкиКурсов(Результат, ДополнительныеПараметры) Экспорт
	Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаСписокВалют;
	Элементы.КоманднаяПанель.Доступность = Истина;

	Если Результат=Неопределено Тогда Возврат; КонецЕсли;
	
	Если Результат.Статус = "Ошибка" Тогда
		ВызватьИсключение(Результат.КраткоеПредставлениеОшибки);
	КонецЕсли;
	
	ОбработатьРезультатЗагрузки(ПолучитьИзВременногоХранилища(Результат.АдресРезультата));	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьРезультатЗагрузки(РезультатЗагрузки)
	
	ЕстьУспешноЗагруженныеКурсы = Ложь;
	БезОшибок = Истина;
	
	КоличествоОшибок = 0;
	
	СписокОшибок = Новый ТекстовыйДокумент;
	Для Каждого СостояниеЗагрузки Из РезультатЗагрузки Цикл
		Если СостояниеЗагрузки.СтатусОперации Тогда
			ЕстьУспешноЗагруженныеКурсы = Истина;
		Иначе
			БезОшибок = Ложь;
			КоличествоОшибок = КоличествоОшибок + 1;
			СписокОшибок.ДобавитьСтроку(СокрЛП(СостояниеЗагрузки.Сообщение) + Символы.ПС);
		КонецЕсли;
	КонецЦикла;
	
	Если ЕстьУспешноЗагруженныеКурсы Тогда
		ОбновитьСведенияВСпискеВалют();
		ПараметрыЗаписи = Неопределено;
		МассивОбновляемыхВалют = Новый Массив;
		Для Каждого СтрокаТаблицы Из Объект.СписокВалют Цикл
			МассивОбновляемыхВалют.Добавить(СтрокаТаблицы.Валюта);
		КонецЦикла;
		Оповестить("Запись_ЗагрузкаКурсовВалют", ПараметрыЗаписи, МассивОбновляемыхВалют);
		ПоказатьОповещениеПользователя(НСтр("ru = 'Курсы валют успешно обновлены'"),,НСтр("ru = 'Курсы валют обновлены'"), БиблиотекаКартинок.ДиалогИнформация);
	КонецЕсли;
	
	Если БезОшибок Тогда
		Закрыть(); Возврат; 
	КонецЕсли;
	
	ПредставлениеОшибки=СокрЛП(СписокОшибок.ПолучитьТекст());
	Если КоличествоОшибок > 1 Тогда
		Кнопки=Новый СписокЗначений;
		Кнопки.Добавить("Подробнее", НСтр("ru = 'Подробнее...'"));
		Кнопки.Добавить("Продолжить", НСтр("ru = 'Продолжить'"));
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Не удалось загрузить курсы валют (%1).'"), КоличествоОшибок);
		ОписаниеОповещения = Новый ОписаниеОповещения("ОбработатьРезультатЗагрузкиПриОтветеНаВопрос", ЭтотОбъект, ПредставлениеОшибки);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, Кнопки);
	Иначе
		ПоказатьПредупреждение(, ПредставлениеОшибки);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьРезультатЗагрузкиПриОтветеНаВопрос(РезультатВопроса, ПредставлениеОшибки) Экспорт
	Если НЕ РезультатВопроса="Подробнее" Тогда Возврат; КонецЕсли;	
	ОткрытьФорму("Обработка.ЗагрузкаКурсовВалют.Форма.СообщенияОбОшибках", Новый Структура("Текст", ПредставлениеОшибки));	
КонецПроцедуры
