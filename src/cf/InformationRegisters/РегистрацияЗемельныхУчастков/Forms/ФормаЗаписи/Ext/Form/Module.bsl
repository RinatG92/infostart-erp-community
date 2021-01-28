﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Ключ.Пустой() Тогда
		
		Запись.Период = ТекущаяДатаСеанса();
		Запись.ВключатьВНалоговуюБазу=Запись.ВидЗаписи = Перечисления.ВидЗаписиОРегистрации.Регистрация;
		Если ЗначениеЗаполнено(Запись.ОсновноеСредство) Тогда
			ЗаполнитьПараметрыПоОсновномуСредству();
		КонецЕсли;
		
		НастроитьФормуПоОбъекту();
	КонецЕсли;
	
	УстановитьЗаголовокФормы(ЭтаФорма, Параметры.Ключ.Пустой());
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(Запись, ВыбранноеЗначение);
		УстановитьТекстНалоговойЛьготы(ЭтаФорма);
		
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	НастроитьФормуПоОбъекту();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если Параметры.Ключ.Организация <> ТекущийОбъект.Организация
		ИЛИ Параметры.Ключ.ОсновноеСредство <> ТекущийОбъект.ОсновноеСредство
		ИЛИ Параметры.Ключ.Период <> ТекущийОбъект.Период Тогда
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Период",           ТекущийОбъект.Период);
		Запрос.УстановитьПараметр("Организация",      ТекущийОбъект.Организация);
		Запрос.УстановитьПараметр("ОсновноеСредство", ТекущийОбъект.ОсновноеСредство);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ПРЕДСТАВЛЕНИЕ(РегистрацияЗемельныхУчастков.ВидЗаписи) КАК ВидЗаписи
		|ИЗ
		|	РегистрСведений.РегистрацияЗемельныхУчастков КАК РегистрацияЗемельныхУчастков
		|ГДЕ
		|	РегистрацияЗемельныхУчастков.Период = &Период
		|	И РегистрацияЗемельныхУчастков.Организация = &Организация
		|	И РегистрацияЗемельныхУчастков.ОсновноеСредство = &ОсновноеСредство";
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Количество() > 0 Тогда
			
			Выборка.Следующий();
			
			ШаблонСообщения = НСтр("ru = '%1 по основному средству <%2> 
			|уже есть запись <%3> в организации <%4>.'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения,
				Формат(ТекущийОбъект.Период, "ДЛФ=D"), ТекущийОбъект.ОсновноеСредство, ТекущийОбъект.ВидЗаписи,
				ТекущийОбъект.Организация);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , , , Отказ);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если НЕ Отказ Тогда
		
		Если Запись.ПостановкаНаУчетВНалоговомОргане = Перечисления.ПостановкаНаУчетВНалоговомОргане.СДругимКодомПоОКАТО Тогда
			ТекущийОбъект.КодПоОКТМО = КодПоОКТМОПоМестуНахожденияОрганизации;
			ТекущийОбъект.КодПоОКАТО = КодПоОКАТОПоМестуНахожденияОрганизации;
		ИначеЕсли Запись.ПостановкаНаУчетВНалоговомОргане = Перечисления.ПостановкаНаУчетВНалоговомОргане.ВДругомНалоговомОргане Тогда
			ТекущийОбъект.КодПоОКТМО = КодПоОКТМОВДругомНалоговомОргане;
			ТекущийОбъект.КодПоОКАТО = КодПоОКАТОВДругомНалоговомОргане;
		Иначе
			ТекущийОбъект.НалоговыйОрган = Справочники.РегистрацияВИФНС.ПустаяСсылка();
		КонецЕсли;
		
		Если Год(ТекущийОбъект.Период) >= 2014 Тогда
			ТекущийОбъект.КодПоОКАТО = "";
		КонецЕсли;
		
		Если НЕ Запись.ОбщаяСобственность Тогда
			ТекущийОбъект.ДоляВПравеОбщейСобственностиЧислитель   = 0;
			ТекущийОбъект.ДоляВПравеОбщейСобственностиЗнаменатель = 0;
		КонецЕсли;
		
		Если НЕ Запись.ЖилищноеСтроительство Тогда
			ТекущийОбъект.ДатаНачалаПроектирования                = '00010101';
			ТекущийОбъект.ДатаРегистрацииПравНаОбъектНедвижимости = '00010101';
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если Запись.ОбщаяСобственность Тогда
		
		Если НЕ ЗначениеЗаполнено(Запись.ДоляВПравеОбщейСобственностиЧислитель) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(, , НСтр("ru = 'Доля в праве общей собственности числитель'"));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Запись.ДоляВПравеОбщейСобственностиЧислитель", , Отказ);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Запись.ДоляВПравеОбщейСобственностиЗнаменатель) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(, , НСтр("ru = 'Доля в праве общей собственности знаменатель'"));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Запись.ДоляВПравеОбщейСобственностиЗнаменатель", , Отказ);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Запись.ДоляВПравеОбщейСобственностиЧислитель)
			И ЗначениеЗаполнено(Запись.ДоляВПравеОбщейСобственностиЗнаменатель)
			И Запись.ДоляВПравеОбщейСобственностиЧислитель > Запись.ДоляВПравеОбщейСобственностиЗнаменатель Тогда
			
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(, "КОРРЕКТНОСТЬ", НСтр("ru = 'Доля в праве общей собственности числитель'"), , ,
				НСтр("ru = 'Доля в праве на участок: числитель дроби больше знаменателя.'"));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Запись.ДоляВПравеОбщейСобственностиЧислитель", , Отказ);
		КонецЕсли;
		
	КонецЕсли;
		
	Если Запись.ВидЗаписи = Перечисления.ВидЗаписиОРегистрации.Регистрация
		И Запись.ПостановкаНаУчетВНалоговомОргане = Перечисления.ПостановкаНаУчетВНалоговомОргане.СДругимКодомПоОКАТО Тогда
		
		Если ПустаяСтрока(КодПоОКТМОПоМестуНахожденияОрганизации) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(, , НСтр("ru = 'Код по ОКТМО'"));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "КодПоОКТМОПоМестуНахожденияОрганизации", , Отказ);
		КонецЕсли;
		
		Если ПустаяСтрока(КодПоОКАТОПоМестуНахожденияОрганизации) И Год(Запись.Период) < 2014 Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(, , НСтр("ru = 'Код по ОКАТО'"));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "КодПоОКАТОПоМестуНахожденияОрганизации", , Отказ);
		КонецЕсли;
		
	КонецЕсли;
	
	Если Запись.ВидЗаписи = Перечисления.ВидЗаписиОРегистрации.Регистрация
		И Запись.ПостановкаНаУчетВНалоговомОргане = Перечисления.ПостановкаНаУчетВНалоговомОргане.ВДругомНалоговомОргане Тогда
		
		Если НЕ ЗначениеЗаполнено(Запись.НалоговыйОрган) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(, , НСтр("ru = 'Налоговый орган'"));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Запись.НалоговыйОрган", , Отказ);
		КонецЕсли;
		
		Если ПустаяСтрока(КодПоОКТМОВДругомНалоговомОргане) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(, , НСтр("ru = 'Код по ОКТМО'"));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "КодПоОКТМОВДругомНалоговомОргане", , Отказ);
		КонецЕсли;
		
		Если ПустаяСтрока(КодПоОКАТОВДругомНалоговомОргане) И Год(Запись.Период) < 2014 Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(, , НСтр("ru = 'Код по ОКАТО'"));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "КодПоОКАТОВДругомНалоговомОргане", , Отказ);
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("ИзмененаИнформацияОС");
	
	УстановитьЗаголовокФормы(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	
	ПериодПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	Если ЗначениеЗаполнено(Запись.ОсновноеСредство) И ЗначениеЗаполнено(Запись.Организация) Тогда
		ЗаполнитьПараметрыПоОсновномуСредству();
	КонецЕсли;	
	УправлениеФормой(ЭтаФорма);	
КонецПроцедуры

&НаКлиенте
Процедура ОсновноеСредствоПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Запись.ОсновноеСредство)
		И ЗначениеЗаполнено(Запись.Организация) Тогда
		
		ЗаполнитьПараметрыПоОсновномуСредству();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КодКатегорииЗемельНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ВыборКода("КодКатегорииЗемель", "КатегорииЗемельныхУчастков");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбщаяСобственностьПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЖилищноеСтроительствоПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПостановкаНаУчетВНалоговомОрганеПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура НалоговыйОрганПриИзменении(Элемент)
	
	НалоговыйОрганПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура КБКНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ВыборКода("КБК", "КБК");
	
КонецПроцедуры

&НаКлиенте
Процедура ТекстНалоговойЛьготыНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	Если НЕ ТолькоПросмотр Тогда
		ЗаблокироватьДанныеФормыДляРедактирования();
	КонецЕсли;
	
	ПараметрыЛьготы = Новый Структура(
		"НалоговаяСтавка,
		|ВариантУменьшенияСуммыНалога,
		|ЛьготнаяСтавка,
		|ДоляНеОблагаемойНалогомПлощадиЗнаменатель,
		|ДоляНеОблагаемойНалогомПлощадиЧислитель,
		|КодНалоговойЛьготыОсвобождениеОтНалогообложенияПоСтатье395,
		|КодНалоговойЛьготыУменьшениеНалоговойБазыПоСтатье391,
		|НалоговаяЛьготаПоНалоговойБазе,
		|НеОблагаемаяНалогомСумма,
		|ПроцентУменьшенияСуммыНалога,
		|СнижениеНалоговойСтавки,
		|СниженнаяНалоговаяСтавка,
		|СуммаУменьшенияСуммыНалога,
		|УменьшениеНалоговойБазыНаСумму,
		|УменьшениеНалоговойБазыПоСтатье391,
		|Период");
	ЗаполнитьЗначенияСвойств(ПараметрыЛьготы, Запись);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", ПараметрыЛьготы);
	ПараметрыФормы.Вставить("ТолькоПросмотр"    , ТолькоПросмотр);
	
	ОткрытьФорму("РегистрСведений.РегистрацияЗемельныхУчастков.Форма.ФормаНастройкиЛьготы", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьПараметрыПоОсновномуСредству()
	
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ОсновноеСредство", Запись.ОсновноеСредство);
	Запрос.УстановитьПараметр("Организация",      Запись.Организация);
	Запрос.УстановитьПараметр("Период",           Запись.Период);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РегистрацияЗемельныхУчастковСрезПоследних.КодКатегорииЗемель,
	|	РегистрацияЗемельныхУчастковСрезПоследних.КадастровыйНомер,
	|	РегистрацияЗемельныхУчастковСрезПоследних.КадастроваяСтоимость,
	|	РегистрацияЗемельныхУчастковСрезПоследних.ОбщаяСобственность,
	|	РегистрацияЗемельныхУчастковСрезПоследних.ДоляВПравеОбщейСобственностиЧислитель,
	|	РегистрацияЗемельныхУчастковСрезПоследних.ДоляВПравеОбщейСобственностиЗнаменатель,
	|	РегистрацияЗемельныхУчастковСрезПоследних.ЖилищноеСтроительство,
	|	РегистрацияЗемельныхУчастковСрезПоследних.ДатаНачалаПроектирования,
	|	РегистрацияЗемельныхУчастковСрезПоследних.ДатаРегистрацииПравНаОбъектНедвижимости,
	|	РегистрацияЗемельныхУчастковСрезПоследних.ПостановкаНаУчетВНалоговомОргане,
	|	РегистрацияЗемельныхУчастковСрезПоследних.НалоговыйОрган,
	|	РегистрацияЗемельныхУчастковСрезПоследних.КодПоОКАТО,
	|	РегистрацияЗемельныхУчастковСрезПоследних.НалоговаяСтавка,
	|	РегистрацияЗемельныхУчастковСрезПоследних.НалоговаяЛьготаПоНалоговойБазе,
	|	РегистрацияЗемельныхУчастковСрезПоследних.КодНалоговойЛьготыОсвобождениеОтНалогообложенияПоСтатье395,
	|	РегистрацияЗемельныхУчастковСрезПоследних.КодНалоговойЛьготыУменьшениеНалоговойБазыПоСтатье391,
	|	РегистрацияЗемельныхУчастковСрезПоследних.УменьшениеНалоговойБазыПоСтатье391,
	|	РегистрацияЗемельныхУчастковСрезПоследних.УменьшениеНалоговойБазыНаСумму,
	|	РегистрацияЗемельныхУчастковСрезПоследних.ДоляНеОблагаемойНалогомПлощадиЧислитель,
	|	РегистрацияЗемельныхУчастковСрезПоследних.ДоляНеОблагаемойНалогомПлощадиЗнаменатель,
	|	РегистрацияЗемельныхУчастковСрезПоследних.НеОблагаемаяНалогомСумма,
	|	РегистрацияЗемельныхУчастковСрезПоследних.СниженнаяНалоговаяСтавка,
	|	РегистрацияЗемельныхУчастковСрезПоследних.ПроцентУменьшенияСуммыНалога,
	|	РегистрацияЗемельныхУчастковСрезПоследних.СуммаУменьшенияСуммыНалога
	|ИЗ
	|	РегистрСведений.РегистрацияЗемельныхУчастков.СрезПоследних(
	|			&Период,
	|			Организация = &Организация
	|				И ОсновноеСредство = &ОсновноеСредство) КАК РегистрацияЗемельныхУчастковСрезПоследних";
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Количество() > 0 Тогда
		
		Выборка.Следующий();
		
		ЗаполнитьЗначенияСвойств(Запись, Выборка);
		
		НастроитьФормуПоОбъекту();
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура НастроитьФормуПоОбъекту()
	
	ВыполнитьИнициализацию();
	
	УправлениеФормой(ЭтаФорма);
	УстановитьТекстНалоговойЛьготы(ЭтаФорма);

КонецПроцедуры

&НаСервере
Процедура ВыполнитьИнициализацию()
	
	Если ИнициализацияВыполнена Тогда
		Возврат;
	КонецЕсли;
	
	ИнициализацияВыполнена = Истина;
	
	Если Запись.ПостановкаНаУчетВНалоговомОргане = Перечисления.ПостановкаНаУчетВНалоговомОргане.СДругимКодомПоОКАТО Тогда
		КодПоОКТМОПоМестуНахожденияОрганизации = Запись.КодПоОКТМО;
		КодПоОКАТОПоМестуНахожденияОрганизации = Запись.КодПоОКАТО;
	ИначеЕсли Запись.ПостановкаНаУчетВНалоговомОргане = Перечисления.ПостановкаНаУчетВНалоговомОргане.ВДругомНалоговомОргане Тогда
		КодПоОКТМОВДругомНалоговомОргане = Запись.КодПоОКТМО;
		КодПоОКАТОВДругомНалоговомОргане = Запись.КодПоОКАТО;
	КонецЕсли;
	
	КодыКатегорийЗемель = ПолучитьКодыКатегорийЗемель(Запись.Период);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	Запись   = Форма.Запись;
	
	Элементы.ГруппаПараметрыРегистрации.Видимость = Запись.ВидЗаписи = ПредопределенноеЗначение("Перечисление.ВидЗаписиОРегистрации.Регистрация");
	
	ПоказыватьКодПоОКАТО = Год(Запись.Период) < 2014;
	
	ПостановкаНаУчетСДругимКодомПоОКАТО = Запись.ПостановкаНаУчетВНалоговомОргане = ПредопределенноеЗначение("Перечисление.ПостановкаНаУчетВНалоговомОргане.СДругимКодомПоОКАТО");
		
	Элементы.КодПоОКТМОПоМестуНахожденияОрганизации.Видимость = ПостановкаНаУчетСДругимКодомПоОКАТО;
	Элементы.КодПоОКАТОПоМестуНахожденияОрганизации.Видимость = ПоказыватьКодПоОКАТО И ПостановкаНаУчетСДругимКодомПоОКАТО;
	
	ПостановкаНаУчетВДругомНалоговомОргане = Запись.ПостановкаНаУчетВНалоговомОргане = ПредопределенноеЗначение("Перечисление.ПостановкаНаУчетВНалоговомОргане.ВДругомНалоговомОргане");
	Элементы.НалоговыйОрган.Видимость                   = ПостановкаНаУчетВДругомНалоговомОргане;
	Элементы.КодПоОКТМОВДругомНалоговомОргане.Видимость = ПостановкаНаУчетВДругомНалоговомОргане;
	Элементы.КодПоОКАТОВДругомНалоговомОргане.Видимость = ПоказыватьКодПоОКАТО И ПостановкаНаУчетВДругомНалоговомОргане;
	
	Элементы.КодКатегорииЗемель.РасширеннаяПодсказка.Заголовок = Форма.КодыКатегорийЗемель.Получить(Запись.КодКатегорииЗемель);
	
	Элементы.ГруппаДоляВПравеНаУчасток.Видимость   = Запись.ОбщаяСобственность;
	
	Элементы.ДатаНачалаПроектирования.Видимость                = Год(Запись.Период) < 2008 И Запись.ЖилищноеСтроительство;
	Элементы.ДатаРегистрацииПравНаОбъектНедвижимости.Видимость = Запись.ЖилищноеСтроительство;	
КонецПроцедуры

&НаСервере
Процедура ПериодПриИзмененииНаСервере()
	
	Если ЗначениеЗаполнено(Запись.ОсновноеСредство)
		И ЗначениеЗаполнено(Запись.Организация) Тогда
		
		ЗаполнитьПараметрыПоОсновномуСредству();
		
	КонецЕсли;
	
	КодыКатегорийЗемель = ПолучитьКодыКатегорийЗемель(Запись.Период);
	
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ВыборКода(ИмяКода, НазваниеМакета)
	ПараметрыФормы=Новый Структура;
	ПараметрыФормы.Вставить("ТипОбъекта",      "РегистрСведений");
	ПараметрыФормы.Вставить("НазваниеОбъекта", "РегистрацияЗемельныхУчастков");
	ПараметрыФормы.Вставить("НазваниеМакета",  НазваниеМакета);
	ПараметрыФормы.Вставить("ТекущийПериод",   Запись.Период);
	ПараметрыФормы.Вставить("ТекущийКод",      Запись[ИмяКода]);
	
	ДополнительныеПараметры=Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяКода", ИмяКода);
	
	ОповещениеОЗакрытии=Новый ОписаниеОповещения("ВыборКодаЗавершение", ЭтотОбъект, ДополнительныеПараметры);

	ОткрытьФорму("ОбщаяФорма.ФормаВыбораКода", ПараметрыФормы,,,,,ОповещениеОЗакрытии);	
КонецПроцедуры

&НаКлиенте
Процедура ВыборКодаЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	ИмяКода = ДополнительныеПараметры.ИмяКода;
	
	ВыбранныйКод = РезультатЗакрытия;
	
	Если ВыбранныйКод <> Неопределено Тогда
		
		Модифицированность = Истина;
		
		Запись[ИмяКода] = ВыбранныйКод;
		
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура НалоговыйОрганПриИзмененииНаСервере()
	
	Если ЗначениеЗаполнено(Запись.НалоговыйОрган) Тогда 
		КодПоОКТМОВДругомНалоговомОргане = Запись.НалоговыйОрган.КодПоОКТМО;
		КодПоОКАТОВДругомНалоговомОргане = Запись.НалоговыйОрган.КодПоОКАТО;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьЗаголовокФормы(Форма, НоваяЗапись = Ложь)
	
	Форма.АвтоЗаголовок = Ложь;
	
	Создание = ?(НоваяЗапись, НСтр("ru = ' (создание)'"), "");
	
	Если Форма.Запись.ВидЗаписи = ПредопределенноеЗначение("Перечисление.ВидЗаписиОРегистрации.Регистрация") Тогда
		Форма.Заголовок = СтрШаблон(НСтр("ru = 'Регистрация земельного участка%1'"), Создание);
	Иначе
		Форма.Заголовок = СтрШаблон(НСтр("ru = 'Снятие с регистрационного учета%1'"), Создание);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьКодыКатегорийЗемель(Период)

	КодыКатегорийЗемель = Новый Соответствие;
	
	Макет = РегистрыСведений.РегистрацияЗемельныхУчастков.ПолучитьМакет("КатегорииЗемельныхУчастков");
	
	Если Период < '20110101' Тогда
		ИмяОбласти = "Область2009";
	ИначеЕсли Период < '20130101' Тогда
		ИмяОбласти = "Область2011";
	ИначеЕсли Период < '20170101' Тогда
		ИмяОбласти = "Область2013";
	ИначеЕсли Период < '20180101' Тогда
		ИмяОбласти = "Область2017";
	Иначе
		ИмяОбласти = "Область2018";
	КонецЕсли;
	
	ТекущаяОбласть = Макет.Области.Найти(ИмяОбласти);

	Если ТекущаяОбласть <> Неопределено Тогда

		Для НомерСтр = ТекущаяОбласть.Верх По ТекущаяОбласть.Низ Цикл
			
			КодПоказателя = СокрП(Макет.Область(НомерСтр, 1).Текст);
			Название      = СокрП(Макет.Область(НомерСтр, 2).Текст);
			
			Если КодПоказателя = "###" Тогда
				Прервать;
			ИначеЕсли ПустаяСтрока(КодПоказателя) Тогда
				Продолжить;
			Иначе
				КодыКатегорийЗемель.Вставить(КодПоказателя, Название);
			КонецЕсли;

		КонецЦикла;
		
	КонецЕсли;
	
	Возврат Новый ФиксированноеСоответствие(КодыКатегорийЗемель);

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьТекстНалоговойЛьготы(Форма)
	
	ТекстНалоговойЛьготы = "";
	
	Если Форма.Запись.НалоговаяЛьготаПоНалоговойБазе
			= ПредопределенноеЗначение("Перечисление.ВидНалоговойЛьготыПоНалоговойБазеПоЗемельномуНалогу.ОсвобождениеОтНалогообложенияПоСтатье395") Тогда
		
		ТекстНалоговойЛьготы = НСтр("ru = 'Освобождение от налогообложения по ст. 395 НК РФ'");
		
		Если НЕ ПустаяСтрока(Форма.Запись.КодНалоговойЛьготыОсвобождениеОтНалогообложенияПоСтатье395) Тогда
			ШаблонТекста = НСтр("ru = '( %1 )'");
			ТекстНалоговойЛьготы = ТекстНалоговойЛьготы
				+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонТекста, Форма.Запись.КодНалоговойЛьготыОсвобождениеОтНалогообложенияПоСтатье395);
		КонецЕсли;
		
	КонецЕсли;
	
	Если Форма.Запись.НалоговаяЛьготаПоНалоговойБазе
			= ПредопределенноеЗначение("Перечисление.ВидНалоговойЛьготыПоНалоговойБазеПоЗемельномуНалогу.УменьшениеНалоговойБазы") Тогда
		
		Если Форма.Запись.УменьшениеНалоговойБазыПоСтатье391 И Форма.Запись.Период < '20170101' Тогда
		
			ТекстНалоговойЛьготы = ТекстНалоговойЛьготы + ?(ПустаяСтрока(ТекстНалоговойЛьготы), "", "; ")
				+ НСтр("ru = 'Необлагаемая налогом сумма 10 000 руб., установленная ст. 391 НК РФ'");
			
			Если НЕ ПустаяСтрока(Форма.Запись.КодНалоговойЛьготыУменьшениеНалоговойБазыПоСтатье391) Тогда
				ШаблонТекста = НСтр("ru = '( %1 )'");
				ТекстНалоговойЛьготы = ТекстНалоговойЛьготы
					+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонТекста, Форма.Запись.КодНалоговойЛьготыУменьшениеНалоговойБазыПоСтатье391);
			КонецЕсли;
			
		КонецЕсли;
		
		Если Форма.Запись.НеОблагаемаяНалогомСумма > 0 Тогда
			ШаблонТекста = НСтр("ru = 'Необлагаемая налогом сумма %1 руб., установленная местным нормативным актом'");
			ТекстНалоговойЛьготы = ТекстНалоговойЛьготы + ?(ПустаяСтрока(ТекстНалоговойЛьготы), "", "; ")
				+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонТекста, Форма.Запись.НеОблагаемаяНалогомСумма);
		КонецЕсли;
		
	КонецЕсли;
	
	Если Форма.Запись.НалоговаяЛьготаПоНалоговойБазе
			= ПредопределенноеЗначение("Перечисление.ВидНалоговойЛьготыПоНалоговойБазеПоЗемельномуНалогу.ОсвобождениеОтНалогообложенияМестное") Тогда
		
		ТекстНалоговойЛьготы = ТекстНалоговойЛьготы + ?(ПустаяСтрока(ТекстНалоговойЛьготы), "", "; ")
			+ НСтр("ru = 'Освобождение от налогообложения, установленное местным нормативным актом'");
		
	КонецЕсли;
		
		
	Если Форма.Запись.НалоговаяЛьготаПоНалоговойБазе
			= ПредопределенноеЗначение("Перечисление.ВидНалоговойЛьготыПоНалоговойБазеПоЗемельномуНалогу.НеОблагаемаяНалогомПлощадь") Тогда
		
		ШаблонТекста = НСтр("ru = 'Доля не облагаемой налогом площади %1 / %2'");
		ТекстНалоговойЛьготы = ТекстНалоговойЛьготы + ?(ПустаяСтрока(ТекстНалоговойЛьготы), "", "; ")
			+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонТекста,
				Форма.Запись.ДоляНеОблагаемойНалогомПлощадиЧислитель, Форма.Запись.ДоляНеОблагаемойНалогомПлощадиЗнаменатель);
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Форма.Запись.ПроцентУменьшенияСуммыНалога) Тогда
		
		ШаблонТекста = НСтр("ru = 'Уменьшение суммы налога на %1 %2'");
		ТекстНалоговойЛьготы = ТекстНалоговойЛьготы + ?(ПустаяСтрока(ТекстНалоговойЛьготы), "", "; ")
			+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонТекста, Форма.Запись.ПроцентУменьшенияСуммыНалога, "%");
		
	КонецЕсли;
		
	Если ЗначениеЗаполнено(Форма.Запись.СуммаУменьшенияСуммыНалога) Тогда
		
		ШаблонТекста = НСтр("ru = 'Уменьшение суммы налога в размере %1 руб.'");
		ТекстНалоговойЛьготы = ТекстНалоговойЛьготы + ?(ПустаяСтрока(ТекстНалоговойЛьготы), "", "; ")
			+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонТекста, Форма.Запись.СуммаУменьшенияСуммыНалога);
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Форма.Запись.СниженнаяНалоговаяСтавка) Тогда
		
		ШаблонТекста = НСтр("ru = 'Снижение налоговой ставки до %1 %2'");
		ТекстНалоговойЛьготы = ТекстНалоговойЛьготы + ?(ПустаяСтрока(ТекстНалоговойЛьготы), "", "; ")
			+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонТекста, Форма.Запись.СниженнаяНалоговаяСтавка, "%");
		
	КонецЕсли;
	
	Если ПустаяСтрока(ТекстНалоговойЛьготы) Тогда
		ТекстНалоговойЛьготы = НСтр("ru = 'Не применяется'");
	КонецЕсли;
	
	Форма.ТекстНалоговойЛьготы = ТекстНалоговойЛьготы;
	
КонецПроцедуры

#КонецОбласти
