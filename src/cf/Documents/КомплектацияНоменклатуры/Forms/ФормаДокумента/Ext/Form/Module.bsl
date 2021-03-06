﻿&НаКлиенте
Процедура ВыполнитьДействие(Команда)
	Если Команда.Имя="УправлениеШапкой" Тогда
		Видимость=НЕ Элементы.ШапкаПанель1.Видимость;		
		Элементы.ШапкаПанель1.Видимость=Видимость;
		Элементы.ШапкаПанель2.Видимость=Видимость;
		Элементы[Команда.Имя].Картинка=?(Видимость, БиблиотекаКартинок.СтрелкаВнизСплошная, БиблиотекаКартинок.СтрелкаВправоКрасная);
		Элементы.ШапкаИнфо.Видимость=Не Видимость;

		МассивДанных=Новый Массив;
		МассивДанных.Добавить(Новый ФорматированнаяСтрока(" Организация: ", Новый Шрифт(,,Истина), Новый Цвет(0,0,255)));
		МассивДанных.Добавить(СокрЛП(Объект.Организация));
		
		МассивДанных.Добавить(Новый ФорматированнаяСтрока(" | Склад: ", Новый Шрифт(,,Истина), Новый Цвет(0,0,255)));
		МассивДанных.Добавить(СокрЛП(Объект.Склад));
		
		МассивДанных.Добавить(Новый ФорматированнаяСтрока(" | Номенклатура: ", Новый Шрифт(,,Истина), Новый Цвет(0,0,255)));
		МассивДанных.Добавить(СокрЛП(Объект.Номенклатура));

		Элементы.ШапкаИнфо.Заголовок=Новый ФорматированнаяСтрока(МассивДанных);
	Иначе
		УправлениеДиалогамиКлиент.ВыполнитьДействие(Команда.Имя, ЭтаФорма, Объект);
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ВыборВидаОперации(Команда)
	Объект.ВидОперации=ПредопределенноеЗначение("Перечисление.ВидыОперацийКомплектацияНоменклатуры."+стрЗаменить(Команда.Имя, "Операция_", ""));
	УстановитьВидимостьЭлементовФормы();
КонецПроцедуры

&НаСервере
Функция ТекущийВидОперации(стрВидОперации) Экспорт
	Возврат Объект.ВидОперации=Перечисления.ВидыОперацийКомплектацияНоменклатуры[стрВидОперации];
КонецФункции

&НаКлиенте
Процедура ОбновитьРеквизитыФормы(стрРеквизиты)
	МассивРеквизитов=СтрРазделить(стрРеквизиты, ",");
	Для каждого ИмяРеквизита Из МассивРеквизитов Цикл
		Если ИмяРеквизита="УчетнаяПолитика" Тогда
			УчетнаяПолитика=ОбщегоНазначенияСервер.ПараметрыУчетнойПолитики(Объект.Организация, Объект.Дата);
			УстановитьВидимостьЭлементовФормы();
		КонецЕсли; 
	КонецЦикла; 
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимостьЭлементовФормы()
	ВидОперацииРазукомплектация=Объект.ВидОперации=ПредопределенноеЗначение("Перечисление.ВидыОперацийКомплектацияНоменклатуры.Разукомплектация");
	//*** ВидОперацииКомплектация=Объект.ВидОперации=ПредопределенноеЗначение("Перечисление.ВидыОперацийКомплектацияНоменклатуры.Комплектация");
	//** Элементы.МатериалыДоляСтоимости.Видимость=(ВидОперацииРазукомплектация И ЗначениеЗаполнено(Объект.Заказ));
	Элементы.МатериалыДоляСтоимости.Видимость=ВидОперацииРазукомплектация;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий табличного поля "Вложения"

&НаКлиенте
Процедура тпВложение_ВыполнитьДействие(Команда)
	Если Команда.Имя="ВложенияПредпросмотр" Тогда
		Элементы.ВложенияПредпросмотр.Пометка=НЕ Элементы.ВложенияПредпросмотр.Пометка;
		Элементы.ВложенияГруппаПросмотр.Видимость=Элементы.ВложенияПредпросмотр.Пометка;
		Если Элементы.ВложенияПредпросмотр.Пометка Тогда
			тпВложения_ОбработчикОжидания();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры	 

&НаКлиенте
Процедура тпВложения_ПриАктивизацииСтроки(Элемент)
	Если Элементы.тпВложения.ТекущиеДанные=Неопределено Тогда Возврат; КонецЕсли;
	Если НЕ Элементы.ВложенияПредпросмотр.Пометка Тогда Возврат; КонецЕсли;
	
	тпВложения_ОбработчикОжидания();
КонецПроцедуры

&НаКлиенте
Процедура тпВложения_ПредпросмотПоказать(СтруктураДанных)
	Модуль=ОбщегоНазначенияКлиент.ОбщийМодуль("ВложенияКлиент");
	Модуль.ПредпросмотрПоказать(ЭтаФорма, СтруктураДанных);
КонецПроцедуры

&НаСервере
Процедура тпВложения_ПредпросмотСоздать(СтруктураДанных)
	Модуль=ОбщегоНазначенияСервер.ОбщийМодуль("ВложенияСервер");
	Модуль.ПредпросмотрСоздать(ЭтаФорма, СтруктураДанных);
КонецПроцедуры

&НаКлиенте
Процедура тпВложения_ОбработчикОжидания()
	Если Элементы.тпВложения.ТекущиеДанные=Неопределено Тогда Возврат; КонецЕсли;

	СтруктураДанных=Новый Структура("ИмяФайла,Каталог,ТипID,ID,ВариантХранения,ИндексПиктограммы");
	ЗаполнитьЗначенияСвойств(СтруктураДанных, Элементы.тпВложения.ТекущиеДанные);
	СтруктураДанных.Вставить("Ссылка", Объект.Ссылка);
	СтруктураДанных.Вставить("ИмяРеквизита", ОбщегоНазначенияКлиент.ОбщийМодуль("ВложенияОбщий").ИмяРеквизитаПоИндексуПиктограммы(СтруктураДанных.ИндексПиктограммы));

	Если Элементы.Найти("ВложениеПросмотр"+СтруктураДанных.ИмяРеквизита)=Неопределено Тогда	
		тпВложения_ПредпросмотСоздать(СтруктураДанных);
	КонецЕсли;

	тпВложения_ПредпросмотПоказать(СтруктураДанных);
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// Обработчики оповещения

&НаКлиенте
Процедура ОбработчикОповещения_ОбработкаПодбора(Параметр1, Параметр2) Экспорт
	Если Параметр1=Неопределено Тогда Возврат; КонецЕсли;
	тпТабличноеПоле_Изменить(Параметр1);
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикОповещения_ВводШтрихкода(Штрихкод, ПараметрыДоп) Экспорт
	Если Не ПустаяСтрока(Штрихкод) Тогда 
		СтруктураВозврата=ПодключаемоеОборудованиеСервер.ОбработатьВведенныйШтрихкод(Штрихкод);
		Если ЗначениеЗаполнено(СтруктураВозврата.Номенклатура) Тогда
			тпМатериалы_Добавить(СтруктураВозврата.Номенклатура, СтруктураВозврата.ХарактеристикаНоменклатуры, СтруктураВозврата.СерияНоменклатуры, СтруктураВозврата.Качество, СтруктураВозврата.ЕдиницаИзмерения, СтруктураВозврата.Количество);
		Иначе
			ПоказатьПредупреждение(,"штрих код не найден!", 10);
		КонецЕсли;
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикОповещения_Материалы_Заполнить(Параметр1, Параметр2) Экспорт
	Если Параметр1=КодВозвратаДиалога.Отмена Тогда Возврат; КонецЕсли; 
	
	Если Параметр1=КодВозвратаДиалога.Да Тогда
		Объект.Материалы.Очистить();
	КонецЕсли;

	//*** тпМатериалы_Заполнить(Параметр2.Команда);
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// Стандартные (универсальные) процедуры\функции

&НаСервере
Процедура ВыполнитьСортировкуТабличнойЧасти(ИмяТабличнойЧасти, стрСортировка) Экспорт
	СортировкаТабличнойЧастиСервер.Сортировать(ИмяТабличнойЧасти, стрСортировка, Объект);
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТиповыеОперации(стрТабличнаяЧасть)
	ДокументОбъект=РеквизитФормыВЗначение("Объект");
	Для каждого СтрокаТабличнойЧасти Из ДокументОбъект[стрТабличнаяЧасть] Цикл
		УправлениеТиповымиОперациямиСервер.УстановитьТиповуюОперацию(СтрокаТабличнойЧасти, ДокументОбъект, ЭтаФорма, стрТабличнаяЧасть);
	КонецЦикла;
	ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// Обработчики событий атрибутов

&НаКлиенте
Процедура Атрибут_ПриИзменении(Элемент)
	Если Элемент.Имя="Организация" Тогда
		ОбновитьРеквизитыФормы("УчетнаяПолитика");		

	ИначеЕсли Элемент.Имя="Заказ" Тогда
		УстановитьВидимостьЭлементовФормы();

	ИначеЕсли Элемент.Имя="Номенклатура" Тогда
		Объект.ЕдиницаИзмерения=ОбщегоНазначенияСервер.ЗначениеРеквизитаОбъекта(Объект.Номенклатура, "ЕдиницаХраненияОстатков");
		Объект.Коэффициент=ОбщегоНазначенияСервер.ЗначениеРеквизитаОбъекта(Объект.ЕдиницаИзмерения, "Коэффициент");

	ИначеЕсли Элемент.Имя="ЕдиницаИзмерения" Тогда
		Объект.Коэффициент=ОбщегоНазначенияСервер.ЗначениеРеквизитаОбъекта(Объект.ЕдиницаИзмерения, "Коэффициент");		
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Атрибут_НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СобытияЭлементовФормыКлиент.НачалоВыбора(ЭтаФорма, Элемент, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура Атрибут_Нажатие(Элемент, СтандартнаяОбработка)
	СобытияЭлементовФормыКлиент.Нажатие(ЭтаФорма, Элемент, СтандартнаяОбработка);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий табличного поля УНИВЕРСАЛЬНЫЕ

&НаКлиенте
Процедура кпТабличноеПоле_ВыполнитьДействие(Команда)
	стрКоманда=Команда.Имя;
	Если стрКоманда="Сортировать" Тогда
		стрТабличнаяЧасть=стрЗаменить(ЭтаФорма.Элементы.ТабличныеЧасти.ТекущаяСтраница.Имя, "Страница", "");
		СортировкаТабличнойЧастиКлиент.Открыть(стрТабличнаяЧасть, ЭтаФорма, Объект);

	ИначеЕсли стрКоманда="НайтиПоШтрихКоду" Тогда
		ОписаниеОповещения=Новый ОписаниеОповещения("ОбработчикОповещения_ВводШтрихкода", ЭтотОбъект);
		ПоказатьВводСтроки(ОписаниеОповещения, , "Введите штрихкод товара");

	ИначеЕсли стрКоманда="Подбор" Тогда
		ПараметрыФормы=УправлениеДиалогамиСервер.СтруктураПодбора();
		ПараметрыФормы.Вставить("Организация", Объект.Организация);
		ПараметрыФормы.Вставить("Склад", Объект.Склад);
		УправлениеДокументамиКлиент.ПодборТоваров(ЭтаФорма, ПараметрыФормы);

	ИначеЕсли стрКоманда="ЗаполнитьТОП" Тогда
		стрТабличнаяЧасть=стрЗаменить(ЭтаФорма.Элементы.ТабличныеЧасти.ТекущаяСтраница.Имя, "Страница", "");
		ЗаполнитьТиповыеОперации(стрТабличнаяЧасть);
		
	ИначеЕсли стрКоманда="ОбновитьПредставлениеТабличнойЧасти" Тогда
		стрТабличнаяЧасть=стрЗаменить(ЭтаФорма.Элементы.ТабличныеЧасти.ТекущаяСтраница.Имя, "Страница", "");
		тпТабличноеПоле_ОбновитьПредставление(стрТабличнаяЧасть);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура тпТабличноеПоле_Изменить(СтруктураПараметров) Экспорт
	Если СтруктураПараметров.Свойство("Ошибка") Тогда ПоказатьПредупреждение(, СтруктураПараметров.Ошибка, 10, "Ошибка"); Возврат; КонецЕсли; 

	УправлениеКоллекциямиЗначенийСервер.СвойствоСтруктуры(СтруктураПараметров, "ХарактеристикаНоменклатуры", ПредопределенноеЗначение("Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка"));
	УправлениеКоллекциямиЗначенийСервер.СвойствоСтруктуры(СтруктураПараметров, "СерииНоменклатуры", ПредопределенноеЗначение("Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка"));
	УправлениеКоллекциямиЗначенийСервер.СвойствоСтруктуры(СтруктураПараметров, "Качество", ПредопределенноеЗначение("Справочник.Качество.Новый"));

	стрТабличнаяЧасть=СтрЗаменить(Элементы.ТабличныеЧасти.ТекущаяСтраница.Имя, "Страница", "");
	
	СтруктураПоиска=Новый Структура("Номенклатура");
	Если стрТабличнаяЧасть="Материалы" Тогда
		СтруктураПоиска.Вставить("ХарактеристикаНоменклатуры", ПредопределенноеЗначение("Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка"));
		СтруктураПоиска.Вставить("СерияНоменклатуры", ПредопределенноеЗначение("Справочник.СерииНоменклатуры.ПустаяСсылка"));
	КонецЕсли; 

	ЗаполнитьЗначенияСвойств(СтруктураПоиска, СтруктураПараметров);

	РезультатПоиска=Объект[стрТабличнаяЧасть].НайтиСтроки(СтруктураПоиска);
	Если РезультатПоиска.Количество()=0 Тогда
		УправлениеКоллекциямиЗначенийСервер.СвойствоСтруктуры(СтруктураПараметров, "ЕдиницаИзмерения", ПредопределенноеЗначение("Справочник.ЕдиницыИзмерения.ПустаяСсылка"));
		Если ЗначениеЗаполнено(СтруктураПараметров.ЕдиницаИзмерения) Тогда
			СтруктураПараметров.ЕдиницаИзмерения=ОбщегоНазначенияСервер.ЗначениеРеквизитаОбъекта(СтруктураПараметров.Номенклатура, "ЕдиницаХраненияОстатков");
		КонецЕсли;
		ТекущиеДанные=Объект[стрТабличнаяЧасть].Добавить();
		ЗаполнитьЗначенияСвойств(ТекущиеДанные, СтруктураПараметров);
	Иначе
		ТекущиеДанные=РезультатПоиска[0];
		ТекущиеДанные.Количество=ТекущиеДанные.Количество+СтруктураПараметров.Количество;
	КонецЕсли;
	
	//Установим добавленную\найденную строку текущей
	Элементы[стрТабличнаяЧасть].ТекущаяСтрока=ТекущиеДанные.ПолучитьИдентификатор();

	//Выполним модуль при изменении номенклатуры(если новая строка) или количества(если строка найдена)
	Если стрТабличнаяЧасть="Материалы" Тогда
		тпМатериалы_Колонка_ПриИзменении(?(РезультатПоиска.Количество()=0, Элементы.МатериалыНоменклатура, Элементы.МатериалыКоличество));
	КонецЕсли;

	Элементы[стрТабличнаяЧасть].Обновить();
КонецПроцедуры

&НаСервере
Процедура тпТабличноеПоле_ОбновитьПредставление(стрТабличнаяЧасть)
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий табличного поля "Материалы"

Процедура кпМатериалы_ВыполнитьДействие(Команда)
	стрТабличнаяЧасть="Материалы"; стрКоманда=стрЗаменить(Команда.Имя, "кп"+стрТабличнаяЧасть+"_", "");
		
	Если стрКоманда="ЗаполнитьПоСериям" Тогда
		тпМатериалы_Заполнить(стрКоманда);		
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура тпМатериалы_Добавить(Номенклатура, Характеристика=Неопределено, Серия=Неопределено, Качество=Неопределено, Единица=Неопределено, Количество=1)
	Если Характеристика=Неопределено Тогда
		Характеристика=ПредопределенноеЗначение("Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка");
	КонецЕсли; 
	Если Серия=Неопределено Тогда
		Серия=ПредопределенноеЗначение("Справочник.СерииНоменклатуры.ПустаяСсылка");
	КонецЕсли;	
	Если Качество=Неопределено Тогда
		Качество=ПредопределенноеЗначение("Справочник.Качество.Новый");
	КонецЕсли;
	Если Единица=Неопределено Тогда
		Единица=ОбщегоНазначенияСервер.ЗначениеРеквизитаОбъекта(Номенклатура, "ЕдиницаХраненияОстатков");
	КонецЕсли; 

	СтруктураПоиска=Новый Структура;
	СтруктураПоиска.Вставить("Номенклатура", Номенклатура);
	СтруктураПоиска.Вставить("ХарактеристикаНоменклатуры", Характеристика);
	СтруктураПоиска.Вставить("СерияНоменклатуры", Серия);
	
	РезультатПоиска=Объект.Материалы.НайтиСтроки(СтруктураПоиска);
	Если РезультатПоиска.Количество()=0 Тогда
		ТекущиеДанные=Объект.Материалы.Добавить();
		ТекущиеДанные.Номенклатура=Номенклатура;
		ТекущиеДанные.ЕдиницаИзмерения=Единица;
		ТекущиеДанные.Коэффициент=ОбщегоНазначенияСервер.ЗначениеРеквизитаОбъекта(Единица, "Коэффициент");
	Иначе
		ТекущиеДанные=РезультатПоиска[0];
	КонецЕсли;
	ТекущиеДанные.Количество=ТекущиеДанные.Количество+Количество;
	ТекущиеДанные.Цена=ЦенообразованиеСервер.ПолучитьЦенуНоменклатуры(Номенклатура, Характеристика, Объект.ТипЦен, ТекущаяДата(), Единица);;
	ТекущиеДанные.Сумма=ТекущиеДанные.Количество*ТекущиеДанные.Цена;

	Элементы.Материалы.Обновить();
	Элементы.Материалы.ТекущаяСтрока=ТекущиеДанные.ПолучитьИдентификатор();

	//Выполним действия "при изменении"
	СтруктураПараметров=Новый Структура("Номенклатура,ХарактеристикаНоменклатуры,СерияНоменклатуры,Количество");
	ЗаполнитьЗначенияСвойств(СтруктураПараметров, ТекущиеДанные);
	тпТабличноеПоле_Изменить(СтруктураПараметров);
КонецПроцедуры

&НаКлиенте
Процедура тпМатериалы_ПриАктивизацииСтроки(Элемент)
	ТекущиеДанные=Элементы.Материалы.ТекущиеДанные;
КонецПроцедуры

&НаКлиенте
Процедура тпМатериалы_ПередНачаломИзменения(Элемент, Отказ)
КонецПроцедуры

&НаКлиенте
Процедура тпМатериалы_ПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НоваяСтрока Тогда
		Элемент.ТекущиеДанные.ID=Строка(Новый УникальныйИдентификатор);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура тпМатериалы_ПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
КонецПроцедуры

&НаКлиенте
Процедура тпМатериалы_ПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
КонецПроцедуры

&НаКлиенте
Процедура тпМатериалы_ПередУдалением(Элемент, Отказ)
КонецПроцедуры

&НаКлиенте
Процедура тпМатериалы_Колонка_ПриИзменении(Элемент)
	стрКолонка=стрЗаменить(Элемент.Имя, "Материалы", "");
	ТекущиеДанные=Элементы.Материалы.ТекущиеДанные;

	Если стрКолонка="Номенклатура" Тогда
		ТекущиеДанные.ЕдиницаИзмерения=ОбщегоНазначенияСервер.ЗначениеРеквизитаОбъекта(ТекущиеДанные.Номенклатура, "ЕдиницаХраненияОстатков");
		ТекущиеДанные.Коэффициент=ОбщегоНазначенияСервер.ЗначениеРеквизитаОбъекта(ТекущиеДанные.ЕдиницаИзмерения, "Коэффициент");
		Если ТекущиеДанные.Количество=0 Тогда ТекущиеДанные.Количество=1; КонецЕсли;

	ИначеЕсли стрКолонка="ХарактеристикаНоменклатуры" Тогда
		Номенклатура=ОбщегоНазначенияСервер.ЗначениеРеквизитаОбъекта(ТекущиеДанные.ХарактеристикаНоменклатуры, "Владелец");
		Если НЕ Номенклатура=ТекущиеДанные.Номенклатура Тогда
			ТекущиеДанные.Номенклатура=Номенклатура;
			ТекущиеДанные.ЕдиницаИзмерения=ОбщегоНазначенияСервер.ЗначениеРеквизитаОбъекта(ТекущиеДанные.Номенклатура, "ЕдиницаХраненияОстатков");
			ТекущиеДанные.Коэффициент=ОбщегоНазначенияСервер.ЗначениеРеквизитаОбъекта(ТекущиеДанные.ЕдиницаИзмерения, "Коэффициент");
			//ТекущиеДанные.Цена=ЦенообразованиеСервер.ПолучитьЦенуНоменклатуры(ТекущиеДанные.Номенклатура, ТекущиеДанные.ХарактеристикаНоменклатуры, Объект.ТипЦен, ТекущаяДата(), ТекущиеДанные.ЕдиницаИзмерения);
		КонецЕсли;

	ИначеЕсли стрКолонка="СерияНоменклатуры" Тогда
		Номенклатура=ОбщегоНазначенияСервер.ЗначениеРеквизитаОбъекта(ТекущиеДанные.СерияНоменклатуры, "Владелец");
		Если НЕ Номенклатура=ТекущиеДанные.Номенклатура Тогда
			ТекущиеДанные.Номенклатура=Номенклатура;
			ТекущиеДанные.ЕдиницаИзмерения=ОбщегоНазначенияСервер.ЗначениеРеквизитаОбъекта(ТекущиеДанные.Номенклатура, "ЕдиницаХраненияОстатков");
			ТекущиеДанные.Коэффициент=ОбщегоНазначенияСервер.ЗначениеРеквизитаОбъекта(ТекущиеДанные.ЕдиницаИзмерения, "Коэффициент");
		КонецЕсли;

	ИначеЕсли стрКолонка="ЕдиницаИзмерения" Тогда
		СтароеЗначениеКоэффициента=ТекущиеДанные.Коэффициент;
		ТекущиеДанные.Коэффициент=ОбщегоНазначенияСервер.ЗначениеРеквизитаОбъекта(ТекущиеДанные.ЕдиницаИзмерения, "Коэффициент");
		Если НЕ ТекущиеДанные.Коэффициент=СтароеЗначениеКоэффициента Тогда
			Если СтароеЗначениеКоэффициента > 0 Тогда
				//ТекущиеДанные.Цена=ТекущиеДанные.Цена*ТекущиеДанные.Коэффициент/СтароеЗначениеКоэффициента;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура тпМатериалы_Заполнить(стрКоманда)
	//ДокументОбъект=РеквизитФормыВЗначение("Объект");

	//Если стрКоманда="ЗаполнитьПоСериям" Тогда
	//	ОбработкаТабличныхЧастей.ЗаполнитьСерии(ДокументОбъект);
	//КонецЕсли;

	//ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий табличной части "Сделки"

&НаКлиенте
Процедура кпСделки_ВыполнитьДействие(Команда)
	тпСделки_Подбор("Заполнить", ЭтаФорма);
КонецПроцедуры
 
&НаКлиенте
Процедура тпСделки_Колонка_НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка=Ложь; тпСделки_Подбор("Изменить", Элемент);
КонецПроцедуры

&НаКлиенте
Процедура тпСделки_Подбор(стрКоманда, Владелец)
	СтруктураПараметров=Новый Структура;
	СтруктураПараметров.Вставить("Объект", Объект);
	СтруктураПараметров.Вставить("Организация", Объект.Организация);
	СтруктураПараметров.Вставить("Склад", Объект.Склад);
	//СтруктураПараметров.Вставить("Контрагент", Объект.Контрагент);
	//СтруктураПараметров.Вставить("ДоговорКонтрагента", Объект.ДоговорКонтрагента);
	СтруктураПараметров.Вставить("МножественныйВыбор", стрКоманда="Заполнить");

	УправлениеЗаказамиКлиент.ВыполнитьДействие(СтруктураПараметров, Владелец, стрКоманда);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий дополнительных реквизитов табличных частей

&НаКлиенте
Процедура тзРеквизитыТЧ_ПриИзменении_Клиент(Элемент)
	тзРеквизитыТЧ_ПриИзменении_Сервер(Элемент.Имя);
КонецПроцедуры

&НаСервере
Процедура тзРеквизитыТЧ_ПриИзменении_Сервер(стрИмя)
	МетаконфигураторСервер.ДопРеквизиты_ПриИзменении(стрИмя, ЭтаФорма);	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий формы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	СобытияФормыСервер.ПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтаФорма, Объект);	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбновитьРеквизитыФормы("УчетнаяПолитика");
	УстановитьВидимостьЭлементовФормы();
	СобытияФормыКлиент.ПриОткрытии(Отказ, ЭтаФорма, Объект);
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	СобытияФормыКлиент.ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка, ЭтаФорма, Объект);
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	СобытияФормыКлиент.ПриЗакрытии(ЗавершениеРаботы, ЭтаФорма, Объект);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	СобытияФормыКлиент.ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора, ЭтаФорма, Объект);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	СобытияФормыКлиент.ОбработкаОповещения(ИмяСобытия, Параметр, Источник, ЭтаФорма, Объект);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаАктивизации(АктивныйОбъект, Источник)
	СобытияФормыКлиент.ОбработкаАктивизации(АктивныйОбъект, Источник, ЭтаФорма, Объект);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаЗаписиНового(НовыйОбъект, Источник, СтандартнаяОбработка)
	СобытияФормыКлиент.ОбработкаЗаписиНового(НовыйОбъект, Источник, СтандартнаяОбработка, ЭтаФорма, Объект);
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	//тпТабличноеПоле_ОбновитьПредставление("Материалы");
	СобытияФормыСервер.ПриЧтенииНаСервере(ТекущийОбъект, ЭтаФорма, Объект);
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	СобытияФормыКлиент.ПередЗаписью(Отказ, ПараметрыЗаписи, ЭтаФорма, Объект);
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	//ТекущийОбъект.АвтоЗаполнениеРеквизитовДокумента();
	СобытияФормыСервер.ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи, ЭтаФорма, Объект);	
КонецПроцедуры
 
&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	СобытияФормыСервер.ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи, ЭтаФорма, Объект);
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	СобытияФормыСервер.ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи, ЭтаФорма, Объект);
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	//тпТабличноеПоле_ОбновитьПредставление("Материалы");
	СобытияФормыКлиент.ПослеЗаписи(ПараметрыЗаписи, ЭтаФорма, Объект);
КонецПроцедуры

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	СобытияФормыКлиент.ВнешнееСобытие(Источник, Событие, Данные, ЭтаФорма, Объект);
КонецПроцедуры

&НаКлиенте
Процедура ВыборЗначения(СтандартнаяОбработка)
	СобытияФормыКлиент.ВыборЗначения(СтандартнаяОбработка, ЭтаФорма, Объект);
КонецПроцедуры