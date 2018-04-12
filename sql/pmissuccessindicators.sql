[getRootNodes]
SELECT node.title, node.objid,node.`parentid`,node.`state`,node.`code`,node.`type`,node.`lft`,node.`rgt`
FROM pmis_successindicators AS node
WHERE node.parentid IS NULL AND  node.type='root'
GROUP BY node.title
ORDER BY node.lft

[getRootNodes1]
SELECT a.* FROM pmis_successindicators a  WHERE 
a.orgid IN ('ROOT',$P{orgid}) AND a.parentid IS NULL and a.type='root' ORDER BY a.code

[getChildNodes]
SELECT node.title, node.objid,node.`parentid`,node.`state`,node.`code`,node.`type`,node.`lft`,node.`rgt`
FROM pmis_successindicators AS node
WHERE node.parentid=$P{objid} 
AND (node.title LIKE $P{searchtext} OR node.code LIKE $P{searchtext})
GROUP BY node.title
ORDER BY node.lft

[getChildNodes1]
SELECT a.* FROM pmis_successindicators a WHERE 
a.parentid=$P{objid} AND a.type='root' ORDER BY a.code

[getList]
SELECT node.title, node.objid,node.`parentid`,node.`state`,node.`code`,node.`type`,node.`lft`,node.`rgt`
FROM pmis_successindicators AS node
WHERE node.parentid=$P{objid}
AND (node.title LIKE $P{searchtext} OR node.code LIKE $P{searchtext})
GROUP BY node.title
ORDER BY node.lft

[getListByOrg]
SELECT node.title, node.objid,node.`parentid`,node.`state`,node.`code`,node.`type`,node.`lft`,node.`rgt`
FROM pmis_successindicators AS node
WHERE node.parentid=$P{objid} 
AND (node.title LIKE $P{searchtext} OR node.code LIKE $P{searchtext})
AND node.objid IN (SELECT DISTINCT
mfo.objid AS objid
FROM pmis_successindicators mfo
INNER JOIN pmis_successindicators op ON op.parentid = mfo.objid
INNER JOIN pmis_successindicators dp ON dp.parentid = op.objid
INNER JOIN pmis_successindicators ip ON ip.parentid = dp.objid
INNER JOIN pmis_successindicators_org o ON o.siid = op.objid OR o.siid = dp.objid
INNER JOIN tagabukid_subay.subay_org_unit org ON org.OrgUnitId = o.orgid
WHERE o.orgid = $P{orgid}
AND mfo.type = 'mfo'

UNION

SELECT DISTINCT
op.objid AS objid
FROM pmis_successindicators mfo
INNER JOIN pmis_successindicators op ON op.parentid = mfo.objid
INNER JOIN pmis_successindicators dp ON dp.parentid = op.objid
INNER JOIN pmis_successindicators ip ON ip.parentid = dp.objid
INNER JOIN pmis_successindicators_org o ON o.siid = op.objid OR o.siid = dp.objid
INNER JOIN tagabukid_subay.subay_org_unit org ON org.OrgUnitId = o.orgid
WHERE o.orgid = $P{orgid}
AND mfo.type = 'mfo'

UNION

SELECT DISTINCT
dp.objid AS objid
FROM pmis_successindicators mfo
INNER JOIN pmis_successindicators op ON op.parentid = mfo.objid
INNER JOIN pmis_successindicators dp ON dp.parentid = op.objid
INNER JOIN pmis_successindicators ip ON ip.parentid = dp.objid
INNER JOIN pmis_successindicators_org o ON o.siid = op.objid OR o.siid = dp.objid
INNER JOIN tagabukid_subay.subay_org_unit org ON org.OrgUnitId = o.orgid
WHERE o.orgid = $P{orgid}
AND mfo.type = 'mfo'

UNION

SELECT DISTINCT
ip.objid AS objid
FROM pmis_successindicators mfo
INNER JOIN pmis_successindicators op ON op.parentid = mfo.objid
INNER JOIN pmis_successindicators dp ON dp.parentid = op.objid
INNER JOIN pmis_successindicators ip ON ip.parentid = dp.objid
INNER JOIN pmis_successindicators_org o ON o.siid = op.objid OR o.siid = dp.objid
INNER JOIN tagabukid_subay.subay_org_unit org ON org.OrgUnitId = o.orgid
WHERE o.orgid = $P{orgid}
AND mfo.type = 'mfo')
GROUP BY node.title
ORDER BY node.lft

[getList1]
SELECT * FROM pmis_successindicators WHERE 
orgid IN ('ROOT',$P{orgid}) AND parentid=$P{objid} ORDER BY code 

[getListDetails]
SELECT CONCAT( REPEAT( '-', (COUNT(parent.title) - 1) ), node.title) AS location,node.title, node.objid,node.`parentid`,node.`state`,node.`code`,node.`type`,node.`lft`,node.`rgt`
FROM pmis_successindicators AS node,
        pmis_successindicators AS parent
WHERE (node.lft BETWEEN parent.lft AND parent.rgt) AND (node.title LIKE $P{searchtext} OR node.code LIKE $P{searchtext}) AND  node.type='op'
GROUP BY node.title
ORDER BY node.lft

[getListDetails1]
SELECT DISTINCT a.* FROM 
( 
  SELECT * FROM pmis_successindicators WHERE 
  code LIKE $P{searchtext}
  UNION 
  SELECT * FROM pmis_successindicators WHERE 
  title LIKE $P{searchtext}
) a
WHERE 
a.orgid IN ('ROOT',$P{orgid}) AND  a.type='op'
ORDER BY a.code 

[getSearch]
SELECT CONCAT( REPEAT( '-', (COUNT(parent.title) - 1) ), node.title) AS location,node.title, node.objid,node.`parentid`,node.`state`,node.`code`,node.`type`,node.`lft`,node.`rgt`
FROM pmis_successindicators AS node,
        pmis_successindicators AS parent
WHERE (node.lft BETWEEN parent.lft AND parent.rgt) AND (node.title LIKE $P{searchtext} OR node.code LIKE $P{searchtext})
GROUP BY node.title
ORDER BY node.lft


[getSearchByOrg]
SELECT node.title, node.objid,node.`parentid`,node.`state`,node.`code`,node.`type`,node.`lft`,node.`rgt`
FROM pmis_successindicators node
WHERE (node.title LIKE $P{searchtext} OR node.code LIKE $P{searchtext})
AND node.objid IN (SELECT DISTINCT
mfo.objid AS objid
FROM pmis_successindicators mfo
INNER JOIN pmis_successindicators op ON op.parentid = mfo.objid
INNER JOIN pmis_successindicators dp ON dp.parentid = op.objid
INNER JOIN pmis_successindicators ip ON ip.parentid = dp.objid
INNER JOIN pmis_successindicators_org o ON o.siid = op.objid OR o.siid = dp.objid
INNER JOIN tagabukid_subay.subay_org_unit org ON org.OrgUnitId = o.orgid
WHERE o.orgid = $P{orgid}
AND mfo.type = 'mfo'

UNION

SELECT DISTINCT
op.objid AS objid
FROM pmis_successindicators mfo
INNER JOIN pmis_successindicators op ON op.parentid = mfo.objid
INNER JOIN pmis_successindicators dp ON dp.parentid = op.objid
INNER JOIN pmis_successindicators ip ON ip.parentid = dp.objid
INNER JOIN pmis_successindicators_org o ON o.siid = op.objid OR o.siid = dp.objid
INNER JOIN tagabukid_subay.subay_org_unit org ON org.OrgUnitId = o.orgid
WHERE o.orgid = $P{orgid}
AND mfo.type = 'mfo'

UNION

SELECT DISTINCT
dp.objid AS objid
FROM pmis_successindicators mfo
INNER JOIN pmis_successindicators op ON op.parentid = mfo.objid
INNER JOIN pmis_successindicators dp ON dp.parentid = op.objid
INNER JOIN pmis_successindicators ip ON ip.parentid = dp.objid
INNER JOIN pmis_successindicators_org o ON o.siid = op.objid OR o.siid = dp.objid
INNER JOIN tagabukid_subay.subay_org_unit org ON org.OrgUnitId = o.orgid
WHERE o.orgid = $P{orgid}
AND mfo.type = 'mfo'

UNION

SELECT DISTINCT
ip.objid AS objid
FROM pmis_successindicators mfo
INNER JOIN pmis_successindicators op ON op.parentid = mfo.objid
INNER JOIN pmis_successindicators dp ON dp.parentid = op.objid
INNER JOIN pmis_successindicators ip ON ip.parentid = dp.objid
INNER JOIN pmis_successindicators_org o ON o.siid = op.objid OR o.siid = dp.objid
INNER JOIN tagabukid_subay.subay_org_unit org ON org.OrgUnitId = o.orgid
WHERE o.orgid = $P{orgid}
AND mfo.type = 'mfo')
GROUP BY node.title
ORDER BY node.lft

[getSearch1]
SELECT DISTINCT a.* FROM 
( 
  SELECT * FROM pmis_successindicators WHERE 
  code LIKE $P{searchtext}
  UNION 
  SELECT * FROM pmis_successindicators WHERE 
  title LIKE $P{searchtext}
) a
WHERE a.orgid IN ('ROOT',$P{orgid})
ORDER BY a.code 

[findInfo]
SELECT a.*, p.code AS parent_code, p.title AS parent_title 
FROM pmis_successindicators a
LEFT JOIN pmis_successindicators p ON a.parentid = p.objid
WHERE a.objid=$P{objid}

[getLookup]
SELECT node.title, node.objid,node.`parentid`,node.`state`,node.`code`,node.`type`,node.`lft`,node.`rgt`
FROM pmis_successindicators AS node
WHERE node.type = $P{type}
AND title LIKE $P{searchtext}
GROUP BY node.title
ORDER BY node.lft

[getLookup1]
SELECT a.* FROM 
(
	SELECT objid,code,title,type FROM pmis_successindicators t WHERE 
	t.orgid IN ('ROOT',$P{orgid}) AND t.code LIKE $P{searchtext} AND type=$P{type} AND parentid LIKE $P{parentid}
	UNION
	SELECT objid,code,title,type FROM pmis_successindicators t WHERE 
	t.orgid IN ('ROOT',$P{orgid}) AND t.title LIKE $P{searchtext} AND type=$P{type} AND parentid LIKE $P{parentid} 
) a
ORDER BY a.code

[getLookupForMapping]
SELECT a.* FROM 
(
	SELECT objid,code,title,type FROM pmis_successindicators t WHERE 
	a.orgid IN ('ROOT',$P{orgid}) AND t.code LIKE $P{searchtext} 
	UNION
	SELECT objid,code,title,type FROM pmis_successindicators t WHERE 
	a.orgid IN ('ROOT',$P{orgid}) AND t.title LIKE $P{searchtext}
) a
WHERE 
a.orgid IN ('ROOT',$P{orgid}) AND a.type IN ( 'op', 'subaccount' )
ORDER BY a.code

[approve]
UPDATE pmis_successindicators SET state='APPROVED' WHERE 
objid=$P{objid} 

[changeParent]
UPDATE pmis_successindicators SET parentid=$P{parentid},lft=$P{lft},rgt=$P{rgt} WHERE 
objid=$P{objid} 

[getSubAccounts]
SELECT a.* FROM pmis_successindicators a WHERE 
a.orgid IN ('ROOT',$P{orgid}) AND a.parentid=$P{objid} AND a.type='subaccount' ORDER BY a.code

[getRevenueItemList]
SELECT r.objid,r.code,r.title,
a.objid AS account_objid, a.title AS account_title, a.code AS account_code
FROM itemaccount r 
LEFT JOIN sre_revenue_mapping m ON m.revenueitemid=r.objid
LEFT JOIN pmis_successindicators a ON a.objid=m.acctid
WHERE 
a.orgid IN ('ROOT',$P{orgid}) AND r.title LIKE $P{searchtext} 
ORDER BY r.code

[getRevenueItemListByCode]
SELECT r.objid,r.code,r.title,
a.objid AS account_objid, a.title AS account_title, a.code AS account_code
FROM itemaccount r 
LEFT JOIN sre_revenue_mapping m ON m.revenueitemid=r.objid
LEFT JOIN pmis_successindicators a ON a.objid=m.acctid
WHERE 
a.orgid IN ('ROOT',$P{orgid}) AND r.code LIKE $P{searchtext} 
ORDER BY r.code

[getAccountpmiss]
SELECT 
  objid,
  CASE WHEN parentid IS NULL THEN 'ROOT' ELSE parentid END AS parentid,
  code,
  title,
  type,
  0 AS amount 
FROM pmis_successindicators 
ORDER BY code


[findParent]
SELECT * FROM pmis_successindicators WHERE objid = $P{parentid}

[changeNodeRight]
UPDATE pmis_successindicators SET rgt = rgt + 2 WHERE rgt > $P{myRight}

[changeNodeLeft]
UPDATE pmis_successindicators SET lft = lft + 2 WHERE lft > $P{myRight}

[changeParentRight]
UPDATE pmis_successindicators SET rgt = rgt + 2 WHERE rgt > $P{myLeft}

[changeParentLeft]
UPDATE pmis_successindicators SET lft = lft + 2 WHERE lft > $P{myLeft}

[getSuccessIndicatorOrg]
SELECT * FROM pmis_successindicators_org WHERE siid = $P{xxx}

[deleteSuccessIndicatorOrg]
DELETE FROM pmis_successindicators_org WHERE siid = $P{siid} AND orgid = $P{orgid}

[findOrgById]
SELECT * FROM subay_org_unit WHERE OrgUnitId = $P{orgid}

[getOrgUnit]
SELECT * FROM subay_org_unit
WHERE (UPPER(Entity_Name) LIKE $P{searchtext} 
OR UPPER(Entity_AcronymAbbreviation) LIKE $P{searchtext})
ORDER BY Entity_Name

[getOrgUnitByParent]
SELECT * FROM subay_org_unit
WHERE (UPPER(Entity_Name) LIKE $P{searchtext} 
OR UPPER(Entity_AcronymAbbreviation) LIKE $P{searchtext})
AND ParentOrgUnitId = $P{orgparentid}
ORDER BY Entity_Name

[getOrgUnitByParents]
SELECT * FROM subay_org_unit
WHERE (UPPER(Entity_Name) LIKE $P{searchtext} 
OR UPPER(Entity_AcronymAbbreviation) LIKE $P{searchtext})
${filter}
ORDER BY Entity_Name

[getSuccessIndicatorRatings]
SELECT * FROM pmis_ratings WHERE siid = $P{xxx}

[deleteSuccessIndicatorRating]
DELETE FROM pmis_ratings WHERE siid = $P{xxx}

[getProfile]
SELECT xx.*,oo.* FROM "hrmis"."tblProfile" xx
INNER JOIN "hrmis"."tblEmploymentEmployeeRoster" xxx ON xxx."ProfileId" = xx."PersonId"
INNER JOIN "references"."tblOrganizationUnit" oo ON oo."OrgUnitId" = xxx."OrganizationUnitId"
WHERE UPPER(xx."Name_LastName") LIKE $P{searchtext} 
OR UPPER(xx."Name_FirstName") LIKE $P{searchtext} 
OR UPPER(xx."Name_MiddleName") LIKE $P{searchtext} 
ORDER BY xx."Name_LastName"

[findProfileById]
SELECT xx.*,oo.* FROM "hrmis"."tblProfile" xx
INNER JOIN "hrmis"."tblEmploymentEmployeeRoster" xxx ON xxx."ProfileId" = xx."PersonId"
INNER JOIN "references"."tblOrganizationUnit" oo ON oo."OrgUnitId" = xxx."OrganizationUnitId"
WHERE xxx."ProfileId" = ${ProfileId}

[getSIByEmployeeOffice]
SELECT DISTINCT
mfo.objid AS mfoid,
mfo.title AS mfotitle,
mfo.code as mfocode,
mfo.type AS mfotype,
op.objid AS opid,
op.title AS optitle,
op.code as opcode,
op.type AS optype,
dp.objid AS dpid,
dp.title AS dptitle,
dp.code as dpcode,
dp.type AS dptype,
o.orgid,org.Entity_Name AS orgname
FROM pmis_successindicators mfo
INNER JOIN pmis_successindicators op ON op.parentid = mfo.objid
INNER JOIN pmis_successindicators dp ON dp.parentid = op.objid
INNER JOIN pmis_successindicators ip ON ip.parentid = dp.objid
INNER JOIN pmis_successindicators_org o ON o.siid = op.objid OR o.siid = dp.objid
INNER JOIN tagabukid_subay.subay_org_unit org ON org.OrgUnitId = o.orgid
WHERE o.orgid = $P{orgid}
AND mfo.type = 'mfo'
ORDER BY dp.code

[getSIByIPCRId]
SELECT 
  id.objid,
  id.ipcrid,
  id.successindicatorid,
  id.qid,
  id.tid,
  id.eid,
  id.remarks,
  mfo.objid AS mfoid,
  mfo.title AS mfotitle,
  mfo.code AS mfocode,
  mfo.type AS mfotype,
  op.objid AS opid,
  op.title AS optitle,
  op.code AS opcode,
  op.type AS optype,
  dp.objid AS dpid,
  dp.title AS dptitle,
  dp.code AS dpcode, 
  dp.type AS dptype,
  ip.objid AS successindicator_objid,
  ip.title AS successindicator_title,
  ip.code AS successindicator_code,
  ip.type AS successindicator_type,
  prq.objid AS q_objid,
  prq.title AS q_title,
  prq.rating AS q_rating,
  prt.objid AS t_objid,
  prt.title AS t_title,
  prt.rating AS t_rating,
  pre.objid AS e_objid,
  pre.title AS e_title,
  pre.rating AS e_rating
FROM pmis_successindicators mfo
INNER JOIN pmis_successindicators op ON op.parentid = mfo.objid
INNER JOIN pmis_successindicators dp ON dp.parentid = op.objid
INNER JOIN pmis_successindicators ip ON ip.parentid = dp.objid
INNER JOIN pmis_ipcr_items id ON id.successindicatorid = ip.objid
LEFT JOIN pmis_rating_items prq ON prq.objid = id.qid
LEFT JOIN pmis_rating_items prt ON prt.objid = id.tid
LEFT JOIN pmis_rating_items pre ON pre.objid = id.eid
WHERE mfo.type = 'mfo'
AND id.ipcrid = $P{ipcrid}
ORDER BY dp.code

[getSIByIPCRIdV1]
SELECT 
  id.objid,
  id.ipcrid,
  id.successindicatorid,
  id.qid,
  id.tid,
  id.eid,
  id.remarks,
  mfo.objid AS mfoid,
  mfo.title AS mfotitle,
  mfo.code AS mfocode,
  mfo.type AS mfotype,
  op.objid AS opid,
  op.title AS optitle,
  op.code AS opcode,
  op.type AS optype,
  dp.objid AS dpid,
  dp.title AS dptitle,
  dp.code AS dpcode, 
  dp.type AS dptype,
  ip.objid AS successindicator_objid,
  ip.title AS successindicator_title,
  ip.code AS successindicator_code,
  ip.type AS successindicator_type,
  prq.objid AS q_objid,
  prq.title AS q_title,
  prq.rating AS q_rating,
  prt.objid AS t_objid,
  prt.title AS t_title,
  prt.rating AS t_rating,
  pre.objid AS e_objid,
  pre.title AS e_title,
  pre.rating AS e_rating
FROM pmis_successindicators mfo
INNER JOIN pmis_successindicators op ON op.parentid = mfo.objid
INNER JOIN pmis_successindicators dp ON dp.parentid = op.objid
INNER JOIN pmis_successindicators ip ON ip.parentid = dp.objid
INNER JOIN pmis_ipcr_items id ON id.successindicatorid = ip.objid
LEFT JOIN pmis_ratings prq ON prq.objid = id.qid
LEFT JOIN pmis_ratings prt ON prt.objid = id.tid
LEFT JOIN pmis_ratings pre ON pre.objid = id.eid
WHERE mfo.type = 'mfo'
AND id.ipcrid = $P{ipcrid}
ORDER BY dp.code


[getSIByOrgId]
SELECT 
  mfo.objid AS mfoid,
  mfo.title AS mfotitle,
  mfo.description AS mfodecription,
  mfo.allotedbudget AS mfoallotedbudget,
  mfo.quantity AS mfoquantity,
  mfo.actualaccomplishment AS mfoactualaccomplishment,
  mfo.remarks AS mforemarks,
  mfo.code AS mfocode,
  mfo.type AS mfotype,
  op.objid AS opid,
  op.title AS optitle,
  op.description AS opdecription,
  op.allotedbudget AS opallotedbudget,
  op.quantity AS opquantity,
  op.actualaccomplishment AS opactualaccomplishment,
  op.remarks AS opremarks,
  op.code AS opcode,
  op.type AS optype,
  dp.objid AS dpid,
  dp.title AS dptitle,
  dp.description AS dpdecription,
  dp.allotedbudget AS dpallotedbudget,
  dp.quantity AS dpquantity,
  dp.actualaccomplishment AS dpactualaccomplishment,
  dp.remarks AS dpremarks,
  dp.code AS dpcode,
  dp.type AS dptype,
  ip.objid AS successindicator_objid,
  ip.title AS successindicator_title,
  ip.description AS successindicator_decription,
  ip.allotedbudget AS successindicator_allotedbudget,
  ip.quantity AS successindicator_quantity,
  ip.actualaccomplishment AS successindicator_actualaccomplishment,
  ip.remarks AS successindicator_remarks,
  ip.code AS successindicator_code,
  ip.type AS successindicator_type,
  r.objid AS r_objid,
  r.title AS r_title,
  r.rating AS r_rating,
  r.type AS r_type
FROM pmis_successindicators mfo
INNER JOIN pmis_successindicators op ON op.parentid = mfo.objid
INNER JOIN pmis_successindicators dp ON dp.parentid = op.objid
INNER JOIN pmis_successindicators ip ON ip.parentid = dp.objid
INNER JOIN pmis_successindicators_org o ON o.siid = op.objid OR o.siid = dp.objid
INNER JOIN pmis_ratings r ON r.`siid` = ip.`objid`
WHERE o.orgid = $P{orgid}
ORDER BY mfo.code,op.code,dp.code,ip.code

[getIPCRByDPCR]
SELECT * FROM pmis_successindicators
WHERE title LIKE  $P{searchtext}
AND parentid = $P{dpid}

[getSuccessIndicatorRating]
SELECT * FROM pmis_ratings 
WHERE (title LIKE $P{searchtext}
OR rating LIKE $P{searchtext})
AND siid = $P{ipid} AND type = $P{type} 
ORDER BY rating

[getBehavioral]
SELECT * FROM pmis_behavioral
WHERE type = $P{type}
ORDER BY sortorder

[getIPCRIndividual]
SELECT ipcr.*,
mfo.`objid` AS mfoobjid,
mfo.`title` AS mfo,
op.`objid` AS opobjid,
op.`title` AS opcr,
dp.`objid` AS dpobjid,
dp.`title` AS dpcr,
ip.`objid` AS ipobjid,
ip.`title` AS ipcr,
rq.`objid` AS rqobjid,
rq.`title` AS rqtitle,
rq.`rating` AS rqrating,
re.`objid` AS reobjid,
re.`title` AS retitle,
re.`rating` AS rerating,
rt.`objid` AS rtobjid,
rt.`title` AS rttitle,
rt.`rating` AS rtrating
FROM `pmis_ipcr` ipcr
INNER JOIN pmis_ipcr_items ipitem ON ipitem.`ipcrid` = ipcr.`objid`
INNER JOIN pmis_successindicators ip ON ip.`objid` = ipitem.`successindicatorid`
INNER JOIN pmis_successindicators dp ON dp.`objid` = ip.`parentid`
INNER JOIN pmis_successindicators op ON op.`objid` = dp.`parentid`
INNER JOIN pmis_successindicators mfo ON mfo.`objid` = op.`parentid`
LEFT JOIN pmis_ratings rq ON rq.`objid` = ipitem.`qid`
LEFT JOIN pmis_ratings re ON re.`objid` = ipitem.`eid`
LEFT JOIN pmis_ratings rt ON rt.`objid` = ipitem.`tid`
WHERE ipcr.employee_PersonId = $P{PersonId}
AND ipcr.period = $P{period}
AND ipcr.year = $P{year}

[getSuccessIndicatorRatingBaseline]
SELECT * FROM pmis_ratings WHERE rating = 3 AND `type` = $P{type} AND title IS NOT NULL GROUP BY title ORDER BY title

[getSuccessIndicatorRatingByBaseline]
SELECT * FROM pmis_ratings WHERE siid = $P{siid} AND `type` = $P{type} ORDER by rating


[getListForVerification]
SELECT objid,title,`type`,recordlog_datecreated as datecreated,recordlog_createdbyuser as createdby
FROM pmis_successindicators 
WHERE title LIKE $P{title}
AND objid <> $P{objid}
ORDER BY title

[getBehavioralTypes]
SELECT * FROM pmis_behavioral ORDER BY `type`, `sortorder`

[getBehavioralRatingList]
SELECT bi.*,
b.`name`,
b.`description`,
b.`sortorder`,
b.`successindicator`,
b.`type`
FROM pmis_ipcr_behavioral_items bi
INNER JOIN pmis_behavioral b ON b.objid = bi.behavioralid 
WHERE bi.parentid = $P{parentid}
ORDER BY b.name,b.type

[removeIPCRItem]
DELETE FROM pmis_ipcr_items WHERE objid = $P{objid}

[changeParent]
UPDATE pmis_successindicators SET parentid=$P{parentid} WHERE 
objid=$P{objid}

[getMFO]
SELECT 
  mfo.objid AS mfoid,
  mfo.title AS mfotitle,
  mfo.description AS mfodecription,
  mfo.allotedbudget AS mfoallotedbudget,
  mfo.quantity AS mfoquantity,
  mfo.actualaccomplishment AS mfoactualaccomplishment,
  mfo.remarks AS mforemarks,
  mfo.code AS mfocode,
  mfo.type AS mfotype
FROM pmis_successindicators mfo
WHERE mfo.type = 'mfo'
ORDER BY mfo.code

[getRatingBaselineMaster]
SELECT * FROM pmis_rating WHERE (name LIKE $P{searchtext} OR code LIKE $P{searchtext}) AND type = $P{type}  ORDER BY name

[getSuccessIndicatorRatings2]
SELECT ri.* FROM pmis_successindicators_rating sir 
INNER JOIN pmis_rating_items ri ON ri.`objid` = sir.`ratingitemid`
WHERE sir.`objid` = $P{xxx}

[lookupSuccessIndicatorRatingByType]
SELECT ri.* FROM pmis_successindicators_rating sir 
INNER JOIN pmis_rating_items ri ON ri.`objid` = sir.`ratingitemid`
WHERE sir.`objid` = $P{ipid}
AND ri.type = $P{type}
AND (ri.title LIKE $P{searchtext} OR ri.rating LIKE $P{searchtext})

[deleteSIRating]
DELETE FROM pmis_successindicators_rating WHERE objid = $P{objid}