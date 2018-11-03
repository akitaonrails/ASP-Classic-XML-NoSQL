create table tbXML_folders (
	folder_id	decimal	primary key,
	root_id		decimal,
	url			varchar2(255),
	path		varchar2(255),
	description varchar2(255),
	creation_date	date	default SYSDATE not null,
	is_active		char(1)	default 0 not null,

	foreign key (root_id) references tbXML_folders(folder_id)
)

create table tbXML_base (
	id	decimal primary key,
	folder_id	decimal	not null,
	style_id	decimal,
	schema_id	decimal,
	filename	varchar2(255),
	type		char(3),
	creation_date	date default SYSDATE not null,
	author		varchar2(255),
	responsible varchar2(255),
	description varchar2(255),
	is_active	char(1)	default 1 not null,

	foreign key (folder_id) references tbXML_folders(folder_id),
	foreign key (style_id) references tbXML_base(id),
	foreign key (schema_id) references tbXML_base(id)
)

create table tbXML_front (
	front_id	decimal	primary key,
	xml_id		decimal not null,
	style_id	decimal	not null,
	language_id	int,
	shortcut	varchar2(200),
	creation	date default SYSDATE not null,
	deleted		char(1) not null

	foreign key (xml_id) references tbXML_base(id),
	foreign key (style_id) references tbXML_base(id),
	foreign key (language_id) references tbXML_Languages(id),
	constraint UK_FRONT_SHORTCUT unique (shortcut,language_id)
)

CREATE TABLE tbXML_Languages (
	id 			decimal 		primary key ,
	creation	date			default SYSDATE not null,
	label		varchar2(20)	not null,
	shortlabel	char(5),
	is_common	char(1)			default 0 not null,		
	is_active	char(1)			default 1 not null,

	constraint UK_LANGUAGES_LABEL unique (label),
	constraint UK_LANGUAGES_SHORTLABEL unique (shortlabel)
)

CREATE TABLE tbXML_Events (
	id			decimal			primary key,
	label		varchar2(50)	not null,
	is_active	char(1)			default 1 not null,

	constraint UK_EVENTS_LABEL unique (label)
)

CREATE TABLE tbXML_EventPages (
	id			decimal			primary key,
	event_id	decimal			not null,
	label		varchar2(50)	not null,
	xml_id		decimal			not null,
	xsl_id		decimal			not null,
	root_id		decimal			not null,

	constraint UK_EVENTPAGES unique (label, root_id, event_id),
	foreign key (xml_id) references tbXML_base(id),
	foreign key (xsl_id) references tbXML_base(id),
	foreign key (root_id) references tbXML_folders(folder_id),
	foreign key (event_id) references tbXML_Events(id)
)

CREATE TABLE tbXML_EventsList (
	id			decimal			primary key,
	label		varchar2(50)	not null,
	event_id	decimal			not null,
	root_id		decimal			not null,

	constraint UK_EVENTSLIST unique (label, event_id, root_id),
	foreign key (event_id) references tbXML_Events(id),
	foreign key (root_id) references tbXML_Folders(folder_id)
)

CREATE TABLE tbXML_Translation (
	id			decimal			primary key,
	category	varchar2(50),
	original	varchar2(200)	not null,
	translation	varchar2(200)	not null,
	source_id	int				not null,
	dest_id		int				not null,
	is_active	char(1)			default 1 not null,

	constraint UK_TRANSLATION_ORIGINAL unique (category, original, source_id, dest_id),
	foreign key (source_id) references tbXML_Languages(id),
	foreign key (dest_id) references tbXML_Languages(id)
)

create sequence seq_tbXML_base;
create sequence seq_tbXML_folders;
create sequence seq_tbXML_front;

create sequence seq_tbXML_Languages;
create sequence seq_tbXML_EventPages;
create sequence seq_tbXML_Events;
create sequence seq_tbXML_EventsList;
create sequence seq_tbXML_Translation;

grant select on seq_tbXML_base to pmiuser;
grant select on seq_tbXML_folders to pmiuser;
grant select on seq_tbXML_front to pmiuser;

grant select on seq_tbXML_Languages to pmiuser;
grant select on seq_tbXML_EventPages to pmiuser;
grant select on seq_tbXML_Events to pmiuser;
grant select on seq_tbXML_EventsList to pmiuser;
grant select on seq_tbXML_Translation to pmiuser;

grant select, insert, update on tbXML_base to pmiuser;
grant select, insert, update on tbXML_folders to pmiuser;
grant select, insert, update on tbXML_front to pmiuser;

grant select, insert, update on tbXML_EventPages to pmiuser;
grant select, insert, update on tbXML_Events to pmiuser;
grant select, insert, update on tbXML_EventsList to pmiuser;



---
08/09/2001 - Maintenance:


insert into tbXML_Languages values ( 1, SYSDATE, 'Common', 'x', 1, 1 )
insert into tbXML_Languages values ( 2, SYSDATE, 'Portuguese', 'pt', 0, 1 )
insert into tbXML_Languages values ( 3, SYSDATE, 'Spanish', 'sp', 0, 1 )

create sequence seq_tbXML_Languages;
select seq_tbXML_Languages.NextVal from dual
select seq_tbXML_Languages.NextVal from dual
select seq_tbXML_Languages.NextVal from dual

update tbXML_front set language_id = 1 where language_id = -1 or language_id is null

alter table tbXML_front add ( foreign key (language_id) references tbXML_Languages(id) )