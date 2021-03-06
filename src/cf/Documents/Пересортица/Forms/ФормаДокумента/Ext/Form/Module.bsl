﻿&НаКлиенте
Процедура ВыполнитьДействие(Команда)
	УправлениеДиалогамиКлиент.ВыполнитьДействие(Команда.Имя, ЭтаФорма, Объект);
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
// Произвольные алгоритмы

&НаКлиенте
Процедура ВыполнитьАлгоритмКлиент(Команда)
	ВыполнитьАлгоритм(Команда.Имя, "АлгоритмВыполнения");
КонецПроцедуры

&НаСервере
Процедура ВыполнитьАлгоритмСервер(Алгоритм, СтруктураКоманды)
	Выполнить(Алгоритм);
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ВыполнитьАлгоритмСерверБезКонтекста(Алгоритм, СтруктураКоманды)
	Выполнить(Алгоритм);
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьАлгоритм_ОбработчикОповещения(Параметр1, Параметр2=Неопределено) Экспорт
	Если Параметр1=Неопределено Тогда Возврат; КонецЕсли;
	ВыполнитьАлгоритм(ЭтаФорма.ТекущийЭлемент.Имя, "АлгоритмОповещения", Параметр1, Параметр2);
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьАлгоритм(стрКоманда, стрИмяАлгоритма, Параметр1=Неопределено, Параметр2=Неопределено) Экспорт
	Если НЕ ТипЗнч(ПроизвольныеАлгоритмы)=Тип("Структура") Тогда Возврат; КонецЕсли;

	СтруктураКоманды=Неопределено; ПроизвольныеАлгоритмы.Свойство(стрКоманда, СтруктураКоманды);
	Если НЕ ТипЗнч(СтруктураКоманды)=Тип("Структура") Тогда Возврат; КонецЕсли;

	Для каждого СтрокаКоллекции Из СтруктураКоманды[стрИмяАлгоритма] Цикл
		Если СтрокаКоллекции.Ключ="НаКлиенте" Тогда
			Выполнить(СтрокаКоллекции.Значение);
		ИначеЕсли СтрокаКоллекции.Ключ="НаСервере" Тогда
			ВыполнитьАлгоритмСервер(СтрокаКоллекции.Значение, СтруктураКоманды);
		ИначеЕсли СтрокаКоллекции.Ключ="НаСервереБезКонтекста" Тогда
			ВыполнитьАлгоритмСерверБезКонтекста(СтрокаКоллекции.Значение, СтруктураКоманды);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// Обработчики оповещений

&НаКлиенте
Процедура ОбработчикОповещения_ЗаполнитьСебестоимостьПоТипуЦены(Параметр1, Параметр2) Экспорт
	Если Параметр1=Неопределено Тогда Возврат; КонецЕсли;
	
	Если Параметр2.Команда="ЗаполнитьСебестоимостьПриходПоТипуЦены" Тогда
		Для каждого СтрокаКоллекции Из Объект.Товары Цикл
			Цена=ЦенообразованиеСервер.ПолучитьЦенуНоменклатуры(СтрокаКоллекции.НоменклатураПриход, СтрокаКоллекции.ХарактеристикаНоменклатурыПриход, Параметр1, ТекущаяДата(), СтрокаКоллекции.ЕдиницаИзмеренияПриход);
			СтрокаКоллекции.СебестоимостьПриходНУ=СтрокаКоллекции.КоличествоПриход*Цена;
			СтрокаКоллекции.СебестоимостьПриходУУ=СтрокаКоллекции.КоличествоПриход*Цена;
		КонецЦикла;
	ИначеЕсли Параметр2.Команда="ЗаполнитьСебестоимостьРасходПоТипуЦены" Тогда
		Для каждого СтрокаКоллекции Из Объект.Товары Цикл
			Цена=ЦенообразованиеСервер.ПолучитьЦенуНоменклатуры(СтрокаКоллекции.НоменклатураРасход, СтрокаКоллекции.ХарактеристикаНоменклатурыРасход, Параметр1, ТекущаяДата(), СтрокаКоллекции.ЕдиницаИзмеренияРасход);
			СтрокаКоллекции.СебестоимостьРасходНУ=СтрокаКоллекции.КоличествоРасход*Цена;
			СтрокаКоллекции.СебестоимостьРасходУУ=СтрокаКоллекции.КоличествоРасход*Цена;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры
 
///////////////////////////////////////////////////////////////////////////////
// Обработчики событий атрибутов шапки

&НаКлиенте
Процедура Атрибут_ПриИзменении(Элемент)
	Если Элемент.Имя="Организация" Тогда
			УчетнаяПолитика=ОбщегоНазначенияСервер.ПараметрыУчетнойПолитики(Объект.Организация, Объект.Дата);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Атрибут_Нажатие(Элемент, СтандартнаяОбработка)
	СобытияЭлементовФормыКлиент.Нажатие(ЭтаФорма, Элемент, СтандартнаяОбработка);
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
// Обработчики событий табличного поля "Товары"

&НаКлиенте
Процедура кпТовары_ВыполнитьДействие(Команда)
	стрКоманда=стрЗаменить(Команда.Имя, "кпТовары_", "");
	Если Команда.Имя="ЗаполнитьОтрицательнымиОстатками" Тогда
		Объект.Товары.Очистить();
		тзОстаткиТМЦ=тпТовары_ОстатковТМЦ();
		Для Каждого СтрокаКоллекции Из тзОстаткиТМЦ Цикл
			ЗаполнитьЗначенияСвойств(Объект.Товары.Добавить(), СтрокаКоллекции);
		КонецЦикла;

	ИначеЕсли стрКоманда="Сортировать" Тогда
		СортировкаТабличнойЧастиКлиент.Открыть("Товары", ЭтаФорма, Объект);

	ИначеЕсли стрКоманда="ЗаполнитьСебестоимостьПриходПоТипуЦены" Или стрКоманда="ЗаполнитьСебестоимостьРасходПоТипуЦены" Тогда
		ОписаниеОповещения=Новый ОписаниеОповещения("ОбработчикОповещения_ЗаполнитьСебестоимостьПоТипуЦены", ЭтотОбъект, Новый Структура("Команда", стрКоманда));
		ПоказатьВводЗначения(ОписаниеОповещения,,"Укажите тип цены", Тип("СправочникСсылка.ТипыЦенНоменклатуры"));

	ИначеЕсли стрКоманда="ЗаполнитьТОП" Тогда
		ЗаполнитьТиповыеОперации("Товары");
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция тпТовары_ОстатковТМЦ()
	Запрос=Новый Запрос;
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	Запрос.УстановитьПараметр("Склад", Объект.Склад);
	Запрос.УстановитьПараметр("Дата", ТекущаяДата());
	Запрос.Текст="
	|ВЫБРАТЬ
	|	ПартииТоваровНаСкладахОстатки.Номенклатура КАК Номенклатура,
	|	ПартииТоваровНаСкладахОстатки.Номенклатура.ЕдиницаДляОтчетов Как ЕдиницаИзмеренияПриход,
	
	|	ПартииТоваровНаСкладахОстатки.Склад КАК Склад,
	|	ПартииТоваровНаСкладахОстатки.Организация КАК Организация,
	|	-ПартииТоваровНаСкладахОстатки.КоличествоОстаток КАК КоличествоПриход,
	|	ЦеныНоменклатурыСрезПоследних.Цена КАК ЦенаПриход,
	|	-ПартииТоваровНаСкладахОстатки.СтоимостьНУОстаток КАК СебестоимостьПриходНУ,
	|	ПартииТоваровНаСкладахОстатки.Качество КАК КачествоПриход
	|ИЗ
	|	РегистрНакопления.ПартииТоваровНаСкладах.Остатки(&Дата, Организация = &Организация И Склад = &Склад) КАК ПартииТоваровНаСкладахОстатки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних(, ) КАК ЦеныНоменклатурыСрезПоследних
	|		ПО ПартииТоваровНаСкладахОстатки.Номенклатура = ЦеныНоменклатурыСрезПоследних.Номенклатура
	|			И ПартииТоваровНаСкладахОстатки.Склад.ТипЦенРозничнойТорговли = ЦеныНоменклатурыСрезПоследних.ТипЦен
	|ГДЕ
	|	ПартииТоваровНаСкладахОстатки.КоличествоОстаток < 0
	|";
	Возврат Запрос.Выполнить().Выгрузить();	
КонецФункции

&НаКлиенте
Процедура тпТовары_Колонка_ПриИзменении(Элемент)
	стрКолонка=стрЗаменить(Элемент.Имя, "Товары", "");
	ТекущиеДанные=Элементы.Товары.ТекущиеДанные;
	
	Если стрКолонка="НоменклатураРасход" Тогда
		ТекущиеДанные.ЕдиницаИзмеренияРасход=ОбщегоНазначенияСервер.ЗначениеРеквизитаОбъекта(ТекущиеДанные.НоменклатураРасход, "ЕдиницаХраненияОстатков");	
		ТекущиеДанные.КоэффициентРасход=ОбщегоНазначенияСервер.ЗначениеРеквизитаОбъекта(ТекущиеДанные.ЕдиницаИзмеренияРасход, "Коэффициент");
		Если ТекущиеДанные.КоличествоРасход=0 Тогда ТекущиеДанные.КоличествоРасход=1; КонецЕсли;
		ТекущиеДанные.ЦенаРасход=ЦенообразованиеСервер.ПолучитьЦенуНоменклатуры(ТекущиеДанные.НоменклатураРасход, ТекущиеДанные.ХарактеристикаНоменклатурыРасход, Объект.ТипЦен, ТекущаяДата(), ТекущиеДанные.ЕдиницаИзмеренияРасход);

	ИначеЕсли стрКолонка="ХарактеристикаНоменклатурыРасход" Тогда
		Если НЕ ТекущиеДанные.ХарактеристикаНоменклатурыРасход.Владелец=ТекущиеДанные.НоменклатураРасход Тогда
			ТекущиеДанные.НоменклатураРасход=ОбщегоНазначенияСервер.ЗначениеРеквизитаОбъекта(ТекущиеДанные.ХарактеристикаНоменклатурыРасход, "Владелец");
			ТекущиеДанные.ЕдиницаИзмеренияРасход=ОбщегоНазначенияСервер.ЗначениеРеквизитаОбъекта(ТекущиеДанные.НоменклатураРасход, "ЕдиницаХраненияОстатков");
			ТекущиеДанные.КоэффициентРасход=ОбщегоНазначенияСервер.ЗначениеРеквизитаОбъекта(ТекущиеДанные.ЕдиницаИзмеренияРасход, "Коэффициент");
		КонецЕсли;
		ТекущиеДанные.ЦенаРасход=ЦенообразованиеСервер.ПолучитьЦенуНоменклатуры(ТекущиеДанные.НоменклатураРасход, ТекущиеДанные.ХарактеристикаНоменклатурыРасход, Объект.ТипЦен, ТекущаяДата(), ТекущиеДанные.ЕдиницаИзмеренияРасход);
		
	ИначеЕсли стрКолонка="ЕдиницаИзмеренияРасход" Тогда
		СтароеЗначениеКоэффициента=ТекущиеДанные.КоэффициентРасход;
		ТекущиеДанные.КоэффициентРасход=ОбщегоНазначенияСервер.ЗначениеРеквизитаОбъекта(ТекущиеДанные.ЕдиницаИзмеренияРасход, "Коэффициент");
		Если НЕ ТекущиеДанные.КоэффициентРасход=СтароеЗначениеКоэффициента Тогда
			Если СтароеЗначениеКоэффициента > 0 Тогда
				ТекущиеДанные.ЦенаРасход=ТекущиеДанные.ЦенаРасход*ТекущиеДанные.КоэффициентРасход/СтароеЗначениеКоэффициента;
			КонецЕсли;
		КонецЕсли;		
		
	ИначеЕсли стрКолонка="НоменклатураПриход" Тогда
		ТекущиеДанные.ЕдиницаИзмеренияПриход=ОбщегоНазначенияСервер.ЗначениеРеквизитаОбъекта(ТекущиеДанные.НоменклатураПриход, "ЕдиницаХраненияОстатков");	
		ТекущиеДанные.КоэффициентПриход=ОбщегоНазначенияСервер.ЗначениеРеквизитаОбъекта(ТекущиеДанные.ЕдиницаИзмеренияПриход, "Коэффициент");
		Если ТекущиеДанные.КоличествоПриход=0 Тогда ТекущиеДанные.КоличествоПриход=1; КонецЕсли;
		ТекущиеДанные.ЦенаПриход=ЦенообразованиеСервер.ПолучитьЦенуНоменклатуры(ТекущиеДанные.НоменклатураПриход, ТекущиеДанные.ХарактеристикаНоменклатурыПриход, Объект.ТипЦен, ТекущаяДата(), ТекущиеДанные.ЕдиницаИзмеренияПриход);

	ИначеЕсли стрКолонка="ХарактеристикаНоменклатурыПриход" Тогда
		Если НЕ ТекущиеДанные.ХарактеристикаНоменклатурыПриход.Владелец=ТекущиеДанные.НоменклатураПриход Тогда
			ТекущиеДанные.НоменклатураПриход=ОбщегоНазначенияСервер.ЗначениеРеквизитаОбъекта(ТекущиеДанные.ХарактеристикаНоменклатурыПриход, "Владелец");
			ТекущиеДанные.ЕдиницаИзмеренияПриход=ОбщегоНазначенияСервер.ЗначениеРеквизитаОбъекта(ТекущиеДанные.НоменклатураПриход, "ЕдиницаХраненияОстатков");
			ТекущиеДанные.КоэффициентПриход=ОбщегоНазначенияСервер.ЗначениеРеквизитаОбъекта(ТекущиеДанные.ЕдиницаИзмеренияПриход, "Коэффициент");
		КонецЕсли;
		ТекущиеДанные.ЦенаПриход=ЦенообразованиеСервер.ПолучитьЦенуНоменклатуры(ТекущиеДанные.НоменклатураПриход, ТекущиеДанные.ХарактеристикаНоменклатурыПриход, Объект.ТипЦен, ТекущаяДата(), ТекущиеДанные.ЕдиницаИзмеренияПриход);
		
	ИначеЕсли стрКолонка="ЕдиницаИзмеренияПриход" Тогда
		СтароеЗначениеКоэффициента=ТекущиеДанные.КоэффициентПриход;
		ТекущиеДанные.КоэффициентПриход=ОбщегоНазначенияСервер.ЗначениеРеквизитаОбъекта(ТекущиеДанные.ЕдиницаИзмеренияПриход, "Коэффициент");
		Если НЕ ТекущиеДанные.КоэффициентПриход=СтароеЗначениеКоэффициента Тогда
			Если СтароеЗначениеКоэффициента > 0 Тогда
				ТекущиеДанные.ЦенаПриход=ТекущиеДанные.ЦенаПриход*ТекущиеДанные.КоэффициентПриход/СтароеЗначениеКоэффициента;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий формы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	СобытияФормыСервер.ПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтаФорма, Объект);	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
			УчетнаяПолитика=ОбщегоНазначенияСервер.ПараметрыУчетнойПолитики(Объект.Организация, Объект.Дата);
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
	СобытияФормыСервер.ПриЧтенииНаСервере(ТекущийОбъект, ЭтаФорма, Объект);
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	СобытияФормыКлиент.ПередЗаписью(Отказ, ПараметрыЗаписи, ЭтаФорма, Объект);
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
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
