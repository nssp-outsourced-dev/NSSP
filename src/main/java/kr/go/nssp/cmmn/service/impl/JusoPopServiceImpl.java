package kr.go.nssp.cmmn.service.impl;

import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.go.nssp.cmmn.service.JusoPopService;

@Service
public class JusoPopServiceImpl implements JusoPopService{

	@Autowired
	private JusoPopDao josoPopDao;

	@Override
	public List selectJusoList(Map<String, Object> param) throws Exception {
		return josoPopDao.selectJusoList(param);
	}
}
