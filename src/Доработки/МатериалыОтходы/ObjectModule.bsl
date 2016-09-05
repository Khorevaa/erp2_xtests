﻿Перем КонтекстЯдра;
Перем Ожидаем;
Перем Утверждения;
Перем ГенераторТестовыхДанных;
Перем ЗапросыИзБД;
Перем УтвержденияПроверкаТаблиц;

#Область ЮнитТестирование

Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
	КонтекстЯдра = КонтекстЯдраПараметр;
	Ожидаем = КонтекстЯдра.Плагин("УтвержденияBDD");
	Утверждения = КонтекстЯдра.Плагин("БазовыеУтверждения");
	ГенераторТестовыхДанных = КонтекстЯдра.Плагин("СериализаторMXL");
	ЗапросыИзБД = КонтекстЯдра.Плагин("ЗапросыИзБД");
	УтвержденияПроверкаТаблиц = КонтекстЯдра.Плагин("УтвержденияПроверкаТаблиц");
КонецПроцедуры

Процедура ЗаполнитьНаборТестов(НаборТестов) Экспорт
	
	//Материал и отход в одном маршрутном листе
	// Сиситема считает что-то остается к распределению
	// Исправление - ФактическоеОкончание в маршрутном листе не должно быть началом дня
	
	НаборТестов.НачатьГруппу("МатериалыОтходы", Истина);
	НаборТестов.Добавить("УдалитьДокументы");
	НаборТестов.Добавить("ПровестиДокументы");
	НаборТестов.Добавить("ЗакрытьМесяц");
	
КонецПроцедуры

Процедура ПередЗапускомТеста() Экспорт
	
КонецПроцедуры

Процедура ПослеЗапускаТеста() Экспорт
	
КонецПроцедуры

Функция РазрешенСлучайныйПорядокВыполненияТестов() Экспорт
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти

#Область Тест

Процедура УдалитьДокументы() Экспорт
	
	Структура = ГенераторТестовыхДанных.СоздатьДанныеПоМакетам(ЭтотОбъект, "Организация");
	УдалитьДокументыПоОрганизации(Структура.Организация);
	
	КонтекстЯдра.СохранитьКонтекст(Структура);
	
КонецПроцедуры	

Процедура ПровестиДокументы() Экспорт
	
	СтруктураДанных = ГенераторТестовыхДанных.СоздатьДанныеПоМакетам(ЭтотОбъект, "Данные");
	ПровестиВыбранныеДокументы(СтруктураДанных);
	
	Структура = КонтекстЯдра.ПолучитьКонтекст();
	
	Результат = МатериалыИРаботывПроизводстве(Структура.Организация, '2016-02-01');
	Утверждения.ПроверитьИстину(Результат, "Обнаружены остатки по регистру МатериалыИРаботыВПроизводстве");
	
	КРаспределению = РаспределениеЗатраты(Структура.Организация, '2016-01-01');
	Утверждения.ПроверитьРавенство(КРаспределению, 0, "Обнаружено количество к распределению");
	
	Для каждого КлючИЗначение из Структура Цикл
		СтруктураДанных.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла;	
	
	КонтекстЯдра.СохранитьКонтекст(СтруктураДанных);
	
КонецПроцедуры	

Процедура ЗакрытьМесяц() Экспорт
	
	СтруктураДанных = КонтекстЯдра.ПолучитьКонтекст();
	ЗакрытьМесяцПоОрганизации(СтруктураДанных.Организация);
	
КонецПроцедуры

#КонецОбласти

#Область ВыполнениеТеста

Процедура ПровестиВыбранныеДокументы(СтруктураДанных)
	
	ДокументОбъект = СтруктураДанных.ЗаказНаПроизводство.ПолучитьОбъект();
	ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение); //ЗаказНаПроизводство
	
	ДокументОбъект = СтруктураДанных.МаршрутныйЛистПроизводства1.ПолучитьОбъект();
	ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение); //МаршрутныйЛистПроизводства1
	
	ДокументОбъект = СтруктураДанных.ВыпускПродукции1.ПолучитьОбъект();
	ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение); //ВыпускПродукции1
	
	ДокументОбъект = СтруктураДанных.ПоступлениеТоваровИУслуг.ПолучитьОбъект();
	ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение); //ПоступлениеТоваровИУслуг
	
	ДокументОбъект = СтруктураДанных.ПередачаМатериаловВПроизводство.ПолучитьОбъект();
	ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение); //ПередачаМатериаловВПроизводство
	
КонецПроцедуры	

Функция ПолучитьПараметрыРасчета(Организация = Неопределено)

	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания();
	
	Если Организация = Неопределено Тогда
		Организация = Справочники.Организации.ПустаяСсылка();
	КонецЕсли;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ПараметрыЗакрытия.ЗакрываемыйПериод
	|ИЗ
	|	РегистрСведений.РегламентныеЗаданияЗакрытияМесяца КАК ПараметрыЗакрытия
	|ГДЕ
	|	ПараметрыЗакрытия.Организация = &Организация
	|");
	Запрос.УстановитьПараметр("Организация", Организация);
	Результат = Запрос.Выполнить();
	
	ЗакрываемыйПериод = Дата("00010101000000");
	ВыборкаДетальныеЗаписи = Результат.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ЗакрываемыйПериод = ВыборкаДетальныеЗаписи.ЗакрываемыйПериод;
	КонецЦикла;
	
	СписокОрганизаций = Новый Массив();
	Если ЗначениеЗаполнено(Организация) Тогда
		СписокОрганизаций.Добавить(Организация);
	КонецЕсли;
	
	МассивОпераций = Новый Массив();
	//++ НЕ УТ
	Для Каждого Значение Из Перечисления.ТипыРегламентныхОпераций Цикл
		Если Значение <> Перечисления.ТипыРегламентныхОпераций.ЗакрытиеГода Тогда
			МассивОпераций.Добавить(Значение);
		ИначеЕсли КонецМесяца(ЗакрываемыйПериод) = КонецГода(ЗакрываемыйПериод) Тогда // надо закрыть год
			МассивОпераций.Добавить(ЗакрываемыйПериод);
		КонецЕсли;
	КонецЦикла;
	//-- НЕ УТ
	
	ПараметрыРасчета = Новый Структура("СписокОрганизаций, Организация, ПериодРегистрации, Период, МассивОпераций, АдресХранилища");
	ПараметрыРасчета.СписокОрганизаций = СписокОрганизаций;
	ПараметрыРасчета.Организация = Организация;
	ПараметрыРасчета.ПериодРегистрации = ЗакрываемыйПериод;
	ПараметрыРасчета.Период = ЗакрываемыйПериод;
	ПараметрыРасчета.МассивОпераций = МассивОпераций;
	ПараметрыРасчета.АдресХранилища = Неопределено;
	
	Возврат ПараметрыРасчета;
	//ЗакрытиеМесяцаУТВызовСервера.РассчитатьВФоновомЗадании(ПараметрыРасчета);
	
КонецФункции

Процедура ЗакрытьМесяцПоОрганизации(Организация)
	
	Запись = РегистрыСведений.РегламентныеЗаданияЗакрытияМесяца.СоздатьМенеджерЗаписи();
	Запись.ЗакрываемыйПериод = '2016-01-01';
	Запись.Организация       = Организация;
	Запись.Период            = ТекущаяДата();
	Запись.Записать();
	
	ПараметрыРасчета = ПолучитьПараметрыРасчета(Организация);
	ЗакрытиеМесяцаУТВызовСервера.РассчитатьЭтапы(ПараметрыРасчета);
	
	//Результат = РаспределниеМатериаловНаПродукцию(ВыпускПродукции);
	//Утверждения.ПроверитьРавенство(Результат, 2, "Должно быть 2 материала, каждый на свою продукцию")
	//Ожидаем.Что(Результат).ЭтоИстина();
	
КонецПроцедуры	

#КонецОбласти

#Область Проверки

Функция МатериалыИРаботывПроизводстве(Организация, Период)
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("Организация", Организация);
	Запрос.Параметры.Вставить("Период",        Период);
	
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Рег.Организация,
	|	Рег.Номенклатура,
	|	Рег.Характеристика,
	|	Рег.Подразделение,
	|	Рег.Серия,
	|	Рег.Назначение,
	|	Рег.УдалитьАналитикаУчетаНоменклатуры,
	|	Рег.КоличествоОстаток
	|ИЗ
	|	РегистрНакопления.МатериалыИРаботыВПроизводстве.Остатки(&Период, Организация = &Организация) КАК Рег";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;	
	
КонецФункции

Функция РаспределениеЗатраты(Организация, Период)
	
	Запрос = Новый Запрос;
	Запрос.Текст = Документы.РаспределениеПроизводственныхЗатрат.ТекстЗапросаЗаполнитьПроизводственныеЗатраты();
	Запрос.УстановитьПараметр("НачалоПериода",		НачалоМесяца(Период));
	
	ГраницаДатаОкончания = Новый Граница(КонецМесяца(Период), ВидГраницы.Включая);
	Запрос.УстановитьПараметр("ГраницаОкончаниеПериода", ГраницаДатаОкончания);
	Запрос.УстановитьПараметр("ОкончаниеПериода",	     КонецМесяца(Период));
	Запрос.УстановитьПараметр("Организация",             Организация);
	Запрос.УстановитьПараметр("ВсеПодразделения",	     Истина);
	
	ПодразделениеПараметр = Новый Массив;
	ПодразделениеПараметр.Добавить(Справочники.СтруктураПредприятия.ПустаяСсылка());
	Запрос.УстановитьПараметр("Подразделение",	ПодразделениеПараметр);
	
	Результат = Запрос.Выполнить();
	ТаблицаЗатрат = Результат.Выгрузить();
	
	Возврат ТаблицаЗатрат.Итог("КРаспределению");
	
КонецФункции

#КонецОбласти

#Область УдалениеДокументов

Процедура УдалитьДокументыПоОрганизации(Организация)
	
	Таблица = Новый ТаблицаЗначений;
	Таблица.Колонки.Добавить("Имя");
	Таблица.Колонки.Добавить("Отбор");
	
	ДобавитьДокумент(Таблица, "Документ.РасчетСебестоимостиТоваров");
	ДобавитьДокумент(Таблица, "Документ.РегламентнаяОперация");
	ДобавитьДокумент(Таблица, "Документ.ПереоценкаВалютныхСредств");
	ДобавитьДокумент(Таблица, "Документ.ПоступлениеБезналичныхДенежныхСредств");
	ДобавитьДокумент(Таблица, "Документ.СчетФактураПолученныйАванс");
	ДобавитьДокумент(Таблица, "Документ.СчетФактураВыданный");
	ДобавитьДокумент(Таблица, "Документ.ВзаимозачетЗадолженности");
	ДобавитьДокумент(Таблица, "Документ.РеализацияТоваровУслуг");
	ДобавитьДокумент(Таблица, "Документ.АктВыполненныхРабот");
	ДобавитьДокумент(Таблица, "Документ.РаспределениеПроизводственныхЗатрат");
	ДобавитьДокумент(Таблица, "Документ.СборкаТоваров");
	ДобавитьДокумент(Таблица, "Документ.ВыпускПродукции");
	ДобавитьДокумент(Таблица, "Документ.ПередачаМатериаловВПроизводство");
	ДобавитьДокумент(Таблица, "Документ.ПеремещениеТоваров");
	ДобавитьДокумент(Таблица, "Документ.ЗаказНаПеремещение");
	ДобавитьДокумент(Таблица, "Документ.МаршрутныйЛистПроизводства");
	ДобавитьДокумент(Таблица, "Документ.СчетФактураПолученный");
	ДобавитьДокумент(Таблица, "Документ.ПоступлениеТоваровУслуг");
	ДобавитьДокумент(Таблица, "Документ.ПоступлениеУслугПрочихАктивов");
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Док.Ссылка
	|ИЗ
	|	Документ.АвансовыйОтчет КАК Док
	|ГДЕ
	|	Док.Организация = &Организация";
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("Организация", Организация);
	
	Для каждого СтрокаТЗ из Таблица Цикл
		
		Текст1 = СтрЗаменить(ТекстЗапроса, "Документ.АвансовыйОтчет", СтрокаТЗ.Имя);
		Текст1 = СтрЗаменить(Текст1, "Док.Организация", СтрокаТЗ.Отбор);
		
		Запрос.Текст = Текст1;
		ТаблицаДокументов = Запрос.Выполнить().Выгрузить();
		УдалитьОбъектыИзТаблицы(ТаблицаДокументов);
		
	КонецЦикла;	
	
КонецПроцедуры	

Процедура ДобавитьДокумент(Таблица, Имя, Отбор = "Организация")
	
	НоваяСтрока = Таблица.Добавить();
	НоваяСтрока.Имя   = Имя;
	НоваяСтрока.Отбор = Отбор;
	
КонецПроцедуры	

Функция УдалитьОбъектыИзТаблицы(Таблица)
	
	Для каждого СтрокаТЗ из Таблица Цикл
		
		УдалитьОбъект(СтрокаТЗ.Ссылка);
		
	КонецЦикла;	
	
КонецФункции	

Функция УдалитьОбъект(Ссылка)
	
	Объект = Ссылка.ПолучитьОбъект();
	
	Если Объект <> Неопределено Тогда
		
		Попытка
			Объект.Удалить();
		Исключение
			//Сообщить(Строка(ТипЗнч(Объект)) + ": " + Строка(Объект));
		КонецПопытки;
		
	КонецЕсли;	
	
КонецФункции	

#КонецОбласти

